import UIKit

public protocol ZoomableView: UIView {
	var intrinsicContentSize: CGSize { get }
}
