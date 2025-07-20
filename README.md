# SwiftUI Zooming

[![CI](https://github.com/yourusername/swiftui-zooming/actions/workflows/ci.yml/badge.svg)](https://github.com/yourusername/swiftui-zooming/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/yourusername/swiftui-zooming/branch/main/graph/badge.svg)](https://codecov.io/gh/yourusername/swiftui-zooming)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Platform](https://img.shields.io/badge/platforms-iOS%2016.0+-333333.svg)](https://github.com/yourusername/swiftui-zooming)
[![Swift](https://img.shields.io/badge/Swift-6.1+-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A high-performance, native SwiftUI zooming and panning container that provides smooth, gesture-driven zoom interactions for any SwiftUI view.

## Features

- 🚀 **High Performance**: Optimized UIKit integration with minimal SwiftUI overhead
- 🎯 **Native Feel**: Smooth, responsive zoom and pan gestures matching system behavior
- 🔧 **Flexible**: Works with any SwiftUI view content
- 📱 **iOS Native**: Built specifically for iOS with UIScrollView under the hood
- 🎨 **Customizable**: Configurable zoom modes, scale limits, and state callbacks
- ⚡ **Efficient**: No `AnyView` type erasure for optimal performance
- 🧪 **Well Tested**: Comprehensive test suite ensuring reliability

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/swiftui-zooming.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter: `https://github.com/yourusername/swiftui-zooming.git`

## Quick Start

```swift
import SwiftUI
import Zooming

struct ContentView: View {
    var body: some View {
        ZoomContainer(
            contentSize: CGSize(width: 300, height: 200),
            initialMode: .fit
        ) {
            // Any SwiftUI content
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {
                    Text("Zoomable Content")
                        .font(.title)
                        .foregroundColor(.white)
                }
        }
    }
}
```

## Usage Examples

### Basic Image Zooming

```swift
ZoomContainer(
    contentSize: CGSize(width: 400, height: 300),
    initialMode: .fit
) {
    AsyncImage(url: URL(string: "https://example.com/image.jpg")) { image in
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
    } placeholder: {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .overlay {
                ProgressView()
            }
    }
}
```

### Complex Interactive Content

```swift
struct InteractiveContent: View {
    @State private var selectedItem: String?
    
    var body: some View {
        ZoomContainer(
            contentSize: CGSize(width: 500, height: 400),
            initialMode: .fit,
            onZoomStateChanged: { state in
                print("Zoom scale: \(state.scale), Mode: \(state.mode)")
            }
        ) {
            VStack(spacing: 20) {
                ForEach(1...10, id: \.self) { index in
                    Button("Item \(index)") {
                        selectedItem = "Item \(index)"
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}
```

### Document Viewer

```swift
struct DocumentViewer: View {
    let documentSize = CGSize(width: 612, height: 792) // Letter size
    
    var body: some View {
        ZoomContainer(
            contentSize: documentSize,
            initialMode: .fit
        ) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Document Title")
                    .font(.largeTitle)
                    .bold()
                
                Text("Lorem ipsum dolor sit amet...")
                    .font(.body)
                
                // More document content...
            }
            .padding(40)
            .frame(width: documentSize.width, height: documentSize.height)
            .background(Color.white)
            .shadow(radius: 5)
        }
        .background(Color.gray.opacity(0.1))
    }
}
```

## API Reference

### ZoomContainer

The main container view that provides zooming functionality.

```swift
public struct ZoomContainer<Content: View>: UIViewRepresentable {
    public init(
        contentSize: CGSize,
        initialMode: ZoomMode = .fit,
        onZoomStateChanged: ((ZoomState) -> Void)? = nil,
        @ViewBuilder content: () -> Content
    )
}
```

#### Parameters

- **contentSize**: The intrinsic size of the content being zoomed
- **initialMode**: Initial zoom mode (`.fit` or `.fill`)
- **onZoomStateChanged**: Optional callback for zoom state changes
- **content**: SwiftUI view builder for the zoomable content

### ZoomMode

Defines how content is initially sized within the container.

```swift
public enum ZoomMode {
    case fit   // Scales content to fit entirely within bounds
    case fill  // Scales content to fill bounds (may crop)
}
```

### ZoomState

Represents the current state of the zoom container.

```swift
public struct ZoomState {
    public let scale: CGFloat           // Current zoom scale (1.0 = fit size)
    public let offset: CGPoint          // Current pan offset
    public let mode: ZoomMode           // Current zoom mode
    public let isZooming: Bool          // Whether actively zooming
    public let isUserInteracting: Bool  // Whether user is interacting
}
```

## Gestures

- **Pinch to Zoom**: Standard pinch gesture for zooming in/out
- **Pan**: Drag to pan around zoomed content
- **Double Tap**: Toggle between fit and fill modes
- **Zoom Limits**: Automatic minimum (fit) and maximum (5x fit) zoom levels

## Performance Considerations

- Uses native `UIScrollView` for optimal performance
- Avoids `AnyView` type erasure through generic design
- Efficient view updates without recreating view hierarchy
- Minimal SwiftUI to UIKit bridging overhead

## Requirements

- iOS 16.0+
- Swift 6.1+
- Xcode 15.0+

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development Setup

1. Clone the repository
2. Open `Package.swift` in Xcode
3. Build and run tests: `⌘+U`

### Running Tests

```bash
swift test
```

### Code Style

This project uses SwiftLint for code formatting. Install it via Homebrew:

```bash
brew install swiftlint
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and version history.

## Support

- 📖 [Documentation](https://yourusername.github.io/swiftui-zooming)
- 🐛 [Issue Tracker](https://github.com/yourusername/swiftui-zooming/issues)
- 💬 [Discussions](https://github.com/yourusername/swiftui-zooming/discussions)

---

Made with ❤️ for the SwiftUI community