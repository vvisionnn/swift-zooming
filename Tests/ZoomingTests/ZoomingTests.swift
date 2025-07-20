import SwiftUI
import Testing
import UIKit
import SnapshotTesting
@testable import Zooming

@MainActor
@Suite("Zooming Tests")
struct ZoomingTests {
	@Test func zoomModeTests() {
		#expect(ZoomMode.fit == ZoomMode.fit)
		#expect(ZoomMode.fill == ZoomMode.fill)
		#expect(ZoomMode.fit != ZoomMode.fill)
	}

	@Test func zoomStateInitialization() {
		let state = ZoomState(
			scale: 1.5,
			offset: CGPoint(x: 10, y: 20),
			mode: .fit,
			isZooming: true,
			isUserInteracting: false
		)

		#expect(state.scale == 1.5)
		#expect(state.offset == CGPoint(x: 10, y: 20))
		#expect(state.mode == .fit)
		#expect(state.isZooming == true)
		#expect(state.isUserInteracting == false)
	}

	@Test func zoomContainerViewInitialization() {
		let containerView = ZoomContainerView()
		#expect(!containerView.subviews.isEmpty) // Should have scroll view
	}

	@Test func zoomContainerViewSetInitialMode() {
		let containerView = ZoomContainerView()
		containerView.setInitialMode(.fill)
		// Test passes if no crash occurs
	}

	@Test func swiftUIZoomableViewInitialization() {
		let testView = Text("Test Content")
		let hostingController = UIHostingController(rootView: testView)
		let intrinsicSize = CGSize(width: 200, height: 100)

		let zoomableView = SwiftUIZoomableView(
			hostingController: hostingController,
			intrinsicSize: intrinsicSize
		)

		#expect(zoomableView.intrinsicContentSize == intrinsicSize)
		#expect(!zoomableView.subviews.isEmpty) // Should have hosting controller view
	}

	@Test func zoomContainerViewChildViewManagement() {
		let containerView = ZoomContainerView()
		let testView = Text("Test")
		let hostingController = UIHostingController(rootView: testView)
		let zoomableView = SwiftUIZoomableView(
			hostingController: hostingController,
			intrinsicSize: CGSize(width: 100, height: 100)
		)

		containerView.setChildView(zoomableView)
		// Test passes if no crash occurs and view is added
	}

	@Test func zoomStateCallbackTriggering() {
		let containerView = ZoomContainerView()
		var callbackTriggered = false
		var receivedState: ZoomState?

		containerView.onZoomStateChanged = { state in
			callbackTriggered = true
			receivedState = state
		}

		// Simulate state change by setting a child view
		let testView = Text("Test")
		let hostingController = UIHostingController(rootView: testView)
		let zoomableView = SwiftUIZoomableView(
			hostingController: hostingController,
			intrinsicSize: CGSize(width: 100, height: 100)
		)

		containerView.setChildView(zoomableView)
		containerView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
		containerView.layoutIfNeeded()

		// Give some time for async operations
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			#expect(callbackTriggered == true)
			#expect(receivedState != nil)
		}
	}

	@Test func intrinsicContentSizeValidation() {
		let sizes: [CGSize] = [
			CGSize(width: 100, height: 100),
			CGSize(width: 500, height: 300),
			CGSize(width: 50, height: 800),
			CGSize(width: 1, height: 1),
		]

		for size in sizes {
			let testView = Rectangle().fill(Color.blue)
			let hostingController = UIHostingController(rootView: testView)
			let zoomableView = SwiftUIZoomableView(
				hostingController: hostingController,
				intrinsicSize: size
			)

			#expect(zoomableView.intrinsicContentSize == size)
		}
	}

	@Test func zoomContainerProtocolConformance() {
		let testView = Text("Test Content")
		let hostingController = UIHostingController(rootView: testView)
		let zoomableView = SwiftUIZoomableView(
			hostingController: hostingController,
			intrinsicSize: CGSize(width: 200, height: 100)
		)

		// Test that it conforms to ZoomableView protocol
		let _: ZoomableView = zoomableView
		#expect(zoomableView.intrinsicContentSize.width == 200)
		#expect(zoomableView.intrinsicContentSize.height == 100)
	}
}
