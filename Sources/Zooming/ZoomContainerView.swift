import UIKit

#if canImport(SwiftUI)
import SwiftUI
#endif

public class ZoomContainerView: UIView {
	private let scrollView = UIScrollView()
	private var childView: ZoomableView?
	private var currentMode: ZoomMode = .fit
	private var initialMode: ZoomMode = .fit
	private var isZooming: Bool = false
	private var isUserInteracting: Bool = false

	public var onZoomStateChanged: ((ZoomState) -> Void)?

	// Cache reference for efficient updates
	public private(set) var zoomableChildView: ZoomableView?

	private var fitScale: CGFloat = 1.0
	private var fillScale: CGFloat = 1.0

	// Layout caching to prevent repeated calculations
	private var lastContainerSize: CGSize = .zero
	private var lastContentSize: CGSize = .zero
	private var isLayoutValid: Bool = false

	// State diffing for callback optimization
	private var lastNotifiedState: ZoomState?
	private let stateDiffThreshold: CGFloat = 0.001 // Threshold for meaningful state changes

	// Simple throttling without Timer overhead
	private var lastNotificationTime: CFTimeInterval = 0
	private let throttleInterval: CFTimeInterval = 0.016 // ~60fps

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

	deinit {
		// No cleanup needed for simple time-based throttling
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
		zoomableChildView = view // Cache for efficient access

		// Invalidate layout cache when child view changes
		isLayoutValid = false

		scrollView.addSubview(view)
		view.translatesAutoresizingMaskIntoConstraints = false

		setupInitialLayout()
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		if childView != nil {
			// Invalidate cache if bounds changed
			if bounds.size != lastContainerSize {
				isLayoutValid = false
			}
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

		// Early return if layout hasn't changed to avoid unnecessary calculations
		if isLayoutValid,
		   lastContainerSize == containerSize,
		   lastContentSize == contentSize {
			return
		}

		// Cache the current sizes
		lastContainerSize = containerSize
		lastContentSize = contentSize

		let widthScale = containerSize.width / contentSize.width
		let heightScale = containerSize.height / contentSize.height

		fitScale = min(widthScale, heightScale)
		fillScale = max(widthScale, heightScale)

		scrollView.minimumZoomScale = fitScale
		scrollView.maximumZoomScale = max(fitScale * 5.0, fillScale * 1.1)

		scrollView.contentSize = contentSize
		childView.frame = CGRect(origin: .zero, size: contentSize)

		// Mark layout as valid
		isLayoutValid = true

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

	private func notifyZoomStateChanged(immediate: Bool = false) {
		let currentState = ZoomState(
			scale: normalizedScale,
			offset: scrollView.contentOffset,
			mode: currentMode,
			isZooming: isZooming,
			isUserInteracting: isUserInteracting,
		)

		// Only proceed if state has meaningfully changed
		guard shouldNotifyStateChange(currentState) else { return }

		if immediate || !isUserInteracting {
			// Immediate notification for important state changes
			lastNotificationTime = CACurrentMediaTime()
			lastNotifiedState = currentState
			onZoomStateChanged?(currentState)
		} else {
			// Simple time-based throttling without Timer overhead
			let currentTime = CACurrentMediaTime()
			if currentTime - lastNotificationTime >= throttleInterval {
				lastNotificationTime = currentTime
				lastNotifiedState = currentState
				onZoomStateChanged?(currentState)
			}
		}
	}

	private func shouldNotifyStateChange(_ newState: ZoomState) -> Bool {
		guard let lastState = lastNotifiedState else {
			return true // First notification
		}

		// Check for meaningful differences
		let scaleChanged = abs(newState.scale - lastState.scale) > stateDiffThreshold
		let offsetChanged = abs(newState.offset.x - lastState.offset.x) > stateDiffThreshold ||
			abs(newState.offset.y - lastState.offset.y) > stateDiffThreshold
		let modeChanged = newState.mode != lastState.mode
		let zoomingChanged = newState.isZooming != lastState.isZooming
		let interactionChanged = newState.isUserInteracting != lastState.isUserInteracting

		return scaleChanged || offsetChanged || modeChanged || zoomingChanged || interactionChanged
	}
}

extension ZoomContainerView: UIScrollViewDelegate {
	public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		childView
	}

	public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
		isZooming = true
		isUserInteracting = true
		notifyZoomStateChanged(immediate: true) // Immediate for interaction state changes
	}

	public func scrollViewDidZoom(_ scrollView: UIScrollView) {
		centerContent()
		updateModeBasedOnScale()
		notifyZoomStateChanged() // Throttled during interaction
	}

	public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
		isZooming = false
		isUserInteracting = false
		notifyZoomStateChanged(immediate: true) // Immediate for interaction state changes
	}

	public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		isUserInteracting = true
		notifyZoomStateChanged(immediate: true) // Immediate for interaction state changes
	}

	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		notifyZoomStateChanged() // Throttled during interaction
	}

	public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if !decelerate {
			isUserInteracting = false
			notifyZoomStateChanged(immediate: true) // Immediate for interaction state changes
		}
	}

	public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		isUserInteracting = false
		notifyZoomStateChanged(immediate: true) // Immediate for interaction state changes
	}
}

