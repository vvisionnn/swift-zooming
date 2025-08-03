import SwiftUI
import UIKit

class SwiftUIZoomableView: UIView, ZoomableView {
	private let hostingController: UIHostingController<AnyView>
	private var _intrinsicContentSize: CGSize

	override var intrinsicContentSize: CGSize {
		_intrinsicContentSize
	}

	init<Content: View>(hostingController: UIHostingController<Content>, intrinsicSize: CGSize) {
		// Create a single AnyView wrapper - simple and direct
		self.hostingController = UIHostingController(rootView: AnyView(hostingController.rootView))
		self._intrinsicContentSize = intrinsicSize
		super.init(frame: .zero)

		setupHostingController()
	}

	private func setupHostingController() {
		hostingController.view.translatesAutoresizingMaskIntoConstraints = false
		hostingController.view.backgroundColor = .clear

		addSubview(hostingController.view)
		NSLayoutConstraint.activate([
			hostingController.view.topAnchor.constraint(equalTo: topAnchor),
			hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
			hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
			hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
		])
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func updateContent<Content: View>(_ content: Content) {
		// Efficiently update the root view without recreating the controller
		hostingController.rootView = AnyView(content)
	}
	
	func updateIntrinsicContentSize(_ newSize: CGSize) {
		guard _intrinsicContentSize != newSize else { return }
		_intrinsicContentSize = newSize
		invalidateIntrinsicContentSize()
	}
}
