import SwiftUI

public struct ZoomContainer<Content: View>: UIViewRepresentable {
	let content: Content
	let contentSize: CGSize
	let initialMode: ZoomMode
	let onZoomStateChanged: ((ZoomState) -> Void)?

	public init(
		contentSize: CGSize,
		initialMode: ZoomMode = .fit,
		onZoomStateChanged: ((ZoomState) -> Void)? = nil,
		@ViewBuilder content: () -> Content
	) {
		self.contentSize = contentSize
		self.initialMode = initialMode
		self.onZoomStateChanged = onZoomStateChanged
		self.content = content()
	}

	public func makeUIView(context: Context) -> ZoomContainerView {
		let zoomContainer = ZoomContainerView()
		zoomContainer.setInitialMode(initialMode)
		zoomContainer.onZoomStateChanged = onZoomStateChanged

		let hostingController = UIHostingController(rootView: content)
		hostingController.view.backgroundColor = .clear

		let wrapperView = SwiftUIZoomableView(
			hostingController: hostingController,
			intrinsicSize: contentSize,
		)

		zoomContainer.setChildView(wrapperView)

		DispatchQueue.main.async {
			zoomContainer.setNeedsLayout()
			zoomContainer.layoutIfNeeded()
		}

		return zoomContainer
	}

	public func updateUIView(_ uiView: ZoomContainerView, context: Context) {
		uiView.onZoomStateChanged = onZoomStateChanged
	}
}

#if DEBUG
#Preview("Debug Example") {
	ZoomContainerDebugExample()
}

#Preview("Gradient Example") {
	ZoomContainerGradientExample()
}

#Preview("Photo Example") {
	ZoomContainerPhotoExample()
}

#Preview("Square Example") {
	ZoomContainerSquareExample()
}
#endif
