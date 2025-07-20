import CoreGraphics

public struct ZoomState {
	public let scale: CGFloat
	public let offset: CGPoint
	public let mode: ZoomMode
	public let isZooming: Bool
	public let isUserInteracting: Bool

	public init(scale: CGFloat, offset: CGPoint, mode: ZoomMode, isZooming: Bool = false, isUserInteracting: Bool = false) {
		self.scale = scale
		self.offset = offset
		self.mode = mode
		self.isZooming = isZooming
		self.isUserInteracting = isUserInteracting
	}
}
