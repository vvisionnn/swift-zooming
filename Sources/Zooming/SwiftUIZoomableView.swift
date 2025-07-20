import SwiftUI
import UIKit

class SwiftUIZoomableView: UIView, ZoomableView {
	private let hostingController: UIHostingController<AnyView>
	private let _intrinsicContentSize: CGSize

	override var intrinsicContentSize: CGSize {
		_intrinsicContentSize
	}

	init<Content: View>(hostingController: UIHostingController<Content>, intrinsicSize: CGSize) {
		self.hostingController = UIHostingController(rootView: AnyView(hostingController.rootView))
		self._intrinsicContentSize = intrinsicSize
		super.init(frame: .zero)

		addSubview(self.hostingController.view)
		self.hostingController.view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.hostingController.view.topAnchor.constraint(equalTo: topAnchor),
			self.hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
			self.hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
			self.hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
		])
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
