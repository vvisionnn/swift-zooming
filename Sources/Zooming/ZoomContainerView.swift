import UIKit

public class ZoomContainerView: UIView {
	private let scrollView = UIScrollView()
	private var childView: ZoomableView?
	private var currentMode: ZoomMode = .fit
	private var initialMode: ZoomMode = .fit
	private var isZooming: Bool = false
	private var isUserInteracting: Bool = false

	public var onZoomStateChanged: ((ZoomState) -> Void)?

	private var fitScale: CGFloat = 1.0
	private var fillScale: CGFloat = 1.0

	private var normalizedScale: CGFloat {
		scrollView.zoomScale / fitScale
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)
		setupScrollView()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupScrollView()
	}

	private func setupScrollView() {
		scrollView.delegate = self
		scrollView.minimumZoomScale = 0.1
		scrollView.maximumZoomScale = 5.0
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.bounces = true
		scrollView.bouncesZoom = true

		addSubview(scrollView)
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
		])

		let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
		doubleTapGesture.numberOfTapsRequired = 2
		scrollView.addGestureRecognizer(doubleTapGesture)
	}

	public func setChildView(_ view: ZoomableView) {
		childView?.removeFromSuperview()
		childView = view

		scrollView.addSubview(view)
		view.translatesAutoresizingMaskIntoConstraints = false

		setupInitialLayout()
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		if childView != nil {
			setupInitialLayout()
		}
	}

	private func setupInitialLayout() {
		guard let childView = childView else { return }

		let containerSize = bounds.size
		let contentSize = childView.intrinsicContentSize

		guard containerSize.width > 0, containerSize.height > 0,
		      contentSize.width > 0, contentSize.height > 0 else {
			DispatchQueue.main.async {
				self.setupInitialLayout()
			}
			return
		}

		let widthScale = containerSize.width / contentSize.width
		let heightScale = containerSize.height / contentSize.height

		fitScale = min(widthScale, heightScale)
		fillScale = max(widthScale, heightScale)

		scrollView.minimumZoomScale = fitScale
		scrollView.maximumZoomScale = max(fitScale * 5.0, fillScale * 1.1)

		scrollView.contentSize = contentSize
		childView.frame = CGRect(origin: .zero, size: contentSize)

		DispatchQueue.main.async {
			let targetScale = self.initialMode == .fit ? self.fitScale : self.fillScale
			self.scrollView.setZoomScale(targetScale, animated: false)
			self.currentMode = self.initialMode
			self.centerContent()
			self.notifyZoomStateChanged()
		}
	}

	private func centerContent() {
		let scrollViewSize = scrollView.bounds.size
		let contentSize = scrollView.contentSize

		let horizontalInset = max(0, (scrollViewSize.width - contentSize.width) / 2)
		let verticalInset = max(0, (scrollViewSize.height - contentSize.height) / 2)

		scrollView.contentInset = UIEdgeInsets(
			top: verticalInset,
			left: horizontalInset,
			bottom: verticalInset,
			right: horizontalInset,
		)
	}

	@objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
		let tolerance: CGFloat = 0.01
		let isFitScale = abs(normalizedScale - 1.0) < tolerance

		let targetScale: CGFloat
		let newMode: ZoomMode

		if isFitScale {
			targetScale = fillScale
			newMode = .fill
		} else {
			targetScale = fitScale
			newMode = .fit
		}

		currentMode = newMode

		let tapPoint = gesture.location(in: scrollView)
		zoomToPoint(tapPoint, scale: targetScale)
	}

	private func zoomToPoint(_ point: CGPoint, scale: CGFloat) {
		let scrollViewSize = scrollView.bounds.size
		let w = scrollViewSize.width / scale
		let h = scrollViewSize.height / scale
		let x = point.x - (w / 2.0)
		let y = point.y - (h / 2.0)

		let rectToZoom = CGRect(x: x, y: y, width: w, height: h)
		scrollView.zoom(to: rectToZoom, animated: true)
	}

	private func updateModeBasedOnScale() {
		let tolerance: CGFloat = 0.01
		let normalizedFillScale = fillScale / fitScale

		if abs(normalizedScale - 1.0) < tolerance {
			currentMode = .fit
		} else if abs(normalizedScale - normalizedFillScale) < tolerance {
			currentMode = .fill
		}
	}

	public func setInitialMode(_ mode: ZoomMode) {
		initialMode = mode
	}

	private func notifyZoomStateChanged() {
		let state = ZoomState(
			scale: normalizedScale,
			offset: scrollView.contentOffset,
			mode: currentMode,
			isZooming: isZooming,
			isUserInteracting: isUserInteracting,
		)
		onZoomStateChanged?(state)
	}
}

extension ZoomContainerView: UIScrollViewDelegate {
	public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		childView
	}

	public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
		isZooming = true
		isUserInteracting = true
		notifyZoomStateChanged()
	}

	public func scrollViewDidZoom(_ scrollView: UIScrollView) {
		centerContent()
		updateModeBasedOnScale()
		notifyZoomStateChanged()
	}

	public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
		isZooming = false
		isUserInteracting = false
		notifyZoomStateChanged()
	}

	public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		isUserInteracting = true
		notifyZoomStateChanged()
	}

	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		notifyZoomStateChanged()
	}

	public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if !decelerate {
			isUserInteracting = false
			notifyZoomStateChanged()
		}
	}

	public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		isUserInteracting = false
		notifyZoomStateChanged()
	}
}
