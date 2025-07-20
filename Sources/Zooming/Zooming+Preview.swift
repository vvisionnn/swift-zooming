import SwiftUI

#if DEBUG

// MARK: - Professional Showcase Examples

struct ZoomContainerShowcase: View {
	var body: some View {
		NavigationView {
			ScrollView {
				LazyVStack(spacing: 24) {
					// Hero Section
					VStack(spacing: 16) {
						HStack {
							Image(systemName: "viewfinder.circle.fill")
								.font(.largeTitle)
								.foregroundStyle(.blue.gradient)
							
							VStack(alignment: .leading, spacing: 4) {
								Text("SwiftUI Zooming")
									.font(.title)
									.fontWeight(.bold)
								Text("High-performance zoom container")
									.font(.subheadline)
									.foregroundColor(.secondary)
							}
							Spacer()
						}
						.padding(.horizontal)
					}
					
					// Feature Demonstrations
					Group {
						PhotoViewerDemo()
						DocumentViewerDemo()
						ArtworkViewerDemo()
						DiagramViewerDemo()
					}
				}
				.padding(.vertical)
			}
			.navigationBarHidden(true)
			.background(Color(.systemGroupedBackground))
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}
}

struct PhotoViewerDemo: View {
	@State private var zoomState: ZoomState?
	
	var body: some View {
		DemoCard(
			title: "Photo Viewer",
			subtitle: "Perfect for image galleries",
			icon: "photo.fill",
			iconColor: .orange
		) {
			ZoomContainer(
				contentSize: CGSize(width: 400, height: 300),
				initialMode: .fit,
				onZoomStateChanged: { state in
					zoomState = state
				}
			) {
				// Mock photo content
				ZStack {
					// Photo background
					LinearGradient(
						colors: [.orange.opacity(0.3), .pink.opacity(0.3), .purple.opacity(0.3)],
						startPoint: .topLeading,
						endPoint: .bottomTrailing
					)
					
					// Photo frame
					RoundedRectangle(cornerRadius: 12)
						.strokeBorder(.white, lineWidth: 4)
						.shadow(color: .black.opacity(0.1), radius: 8)
					
					// Photo content
					VStack(spacing: 12) {
						Image(systemName: "photo.circle.fill")
							.font(.system(size: 48))
							.foregroundColor(.white.opacity(0.9))
						
						Text("400 × 300")
							.font(.title2)
							.fontWeight(.semibold)
							.foregroundColor(.white)
						
						Text("Landscape Photo")
							.font(.caption)
							.foregroundColor(.white.opacity(0.8))
							.padding(.horizontal, 12)
							.padding(.vertical, 4)
							.background(.black.opacity(0.2))
							.clipShape(Capsule())
					}
				}
			}
			.containerBorder()
		} metrics: {
			MetricsPanel(zoomState: zoomState)
		}
	}
}

struct DocumentViewerDemo: View {
	@State private var zoomState: ZoomState?
	
	var body: some View {
		DemoCard(
			title: "Document Viewer",
			subtitle: "Ideal for PDFs and documents",
			icon: "doc.text.fill",
			iconColor: .blue
		) {
			ZoomContainer(
				contentSize: CGSize(width: 300, height: 420),
				initialMode: .fit,
				onZoomStateChanged: { state in
					zoomState = state
				}
			) {
				// Mock document
				ZStack {
					// Document background
					Rectangle()
						.fill(.white)
						.shadow(color: .black.opacity(0.1), radius: 8)
					
					// Document content
					VStack(alignment: .leading, spacing: 16) {
						// Header
						VStack(alignment: .leading, spacing: 8) {
							Text("Document Title")
								.font(.title3)
								.fontWeight(.bold)
							Rectangle()
								.fill(.blue)
								.frame(height: 2)
						}
						
						// Content lines
						VStack(alignment: .leading, spacing: 6) {
							ForEach(0..<8, id: \.self) { index in
								Rectangle()
									.fill(.gray.opacity(0.3))
									.frame(height: 8)
									.frame(maxWidth: index == 7 ? 120 : .infinity)
							}
						}
						
						// Footer info
						HStack {
							Text("300 × 420")
								.font(.caption)
								.foregroundColor(.secondary)
							Spacer()
							Text("A4 Document")
								.font(.caption)
								.foregroundColor(.secondary)
						}
						
						Spacer()
					}
					.padding(20)
					
					// Document border
					Rectangle()
						.strokeBorder(.gray.opacity(0.2), lineWidth: 1)
				}
			}
			.containerBorder()
		} metrics: {
			MetricsPanel(zoomState: zoomState)
		}
	}
}

struct ArtworkViewerDemo: View {
	@State private var zoomState: ZoomState?
	
	var body: some View {
		DemoCard(
			title: "Artwork Viewer",
			subtitle: "For detailed artwork inspection",
			icon: "paintbrush.fill",
			iconColor: .purple
		) {
			ZoomContainer(
				contentSize: CGSize(width: 350, height: 350),
				initialMode: .fit,
				onZoomStateChanged: { state in
					zoomState = state
				}
			) {
				// Mock artwork
				ZStack {
					// Artwork background
					AngularGradient(
						colors: [.red, .orange, .yellow, .green, .blue, .purple, .red],
						center: .center
					)
					
					// Frame
					RoundedRectangle(cornerRadius: 8)
						.strokeBorder(.black, lineWidth: 3)
					
					// Inner frame
					RoundedRectangle(cornerRadius: 4)
						.strokeBorder(.white, lineWidth: 1)
						.padding(8)
					
					// Artwork info
					VStack(spacing: 8) {
						Image(systemName: "paintbrush.pointed.fill")
							.font(.system(size: 32))
							.foregroundColor(.white)
							.shadow(radius: 2)
						
						Text("350 × 350")
							.font(.title3)
							.fontWeight(.bold)
							.foregroundColor(.white)
							.shadow(radius: 2)
						
						Text("Digital Artwork")
							.font(.caption)
							.foregroundColor(.white.opacity(0.9))
							.padding(.horizontal, 8)
							.padding(.vertical, 2)
							.background(.black.opacity(0.3))
							.clipShape(Capsule())
					}
				}
			}
			.containerBorder()
		} metrics: {
			MetricsPanel(zoomState: zoomState)
		}
	}
}

struct DiagramViewerDemo: View {
	@State private var zoomState: ZoomState?
	
	var body: some View {
		DemoCard(
			title: "Diagram Viewer",
			subtitle: "Technical diagrams and charts",
			icon: "chart.bar.fill",
			iconColor: .green
		) {
			ZoomContainer(
				contentSize: CGSize(width: 450, height: 300),
				initialMode: .fit,
				onZoomStateChanged: { state in
					zoomState = state
				}
			) {
				// Mock diagram
				ZStack {
					// Diagram background
					Rectangle()
						.fill(.white)
						.overlay(
							// Grid pattern
							Path { path in
								let gridSize: CGFloat = 20
								for i in stride(from: 0, through: 450, by: gridSize) {
									path.move(to: CGPoint(x: i, y: 0))
									path.addLine(to: CGPoint(x: i, y: 300))
								}
								for i in stride(from: 0, through: 300, by: gridSize) {
									path.move(to: CGPoint(x: 0, y: i))
									path.addLine(to: CGPoint(x: 450, y: i))
								}
							}
							.stroke(.gray.opacity(0.1), lineWidth: 0.5)
						)
					
					// Diagram elements
					VStack(spacing: 20) {
						HStack(spacing: 40) {
							DiagramNode(color: .blue, label: "Start")
							DiagramNode(color: .orange, label: "Process")
							DiagramNode(color: .green, label: "End")
						}
						
						Text("450 × 300 Flow Diagram")
							.font(.caption)
							.foregroundColor(.secondary)
							.padding(.horizontal, 12)
							.padding(.vertical, 4)
							.background(.gray.opacity(0.1))
							.clipShape(Capsule())
					}
					
					// Diagram border
					Rectangle()
						.strokeBorder(.gray.opacity(0.3), lineWidth: 1)
				}
			}
			.containerBorder()
		} metrics: {
			MetricsPanel(zoomState: zoomState)
		}
	}
}

struct DiagramNode: View {
	let color: Color
	let label: String
	
	var body: some View {
		VStack(spacing: 8) {
			Circle()
				.fill(color.gradient)
				.frame(width: 40, height: 40)
				.overlay(
					Circle()
						.strokeBorder(.white, lineWidth: 2)
				)
			
			Text(label)
				.font(.caption2)
				.fontWeight(.medium)
				.foregroundColor(.primary)
		}
	}
}

// MARK: - Supporting Views

struct DemoCard<Content: View, Metrics: View>: View {
	let title: String
	let subtitle: String
	let icon: String
	let iconColor: Color
	@ViewBuilder let content: Content
	@ViewBuilder let metrics: Metrics
	
	var body: some View {
		VStack(spacing: 0) {
			// Header
			VStack(spacing: 12) {
				HStack {
					Image(systemName: icon)
						.font(.title2)
						.foregroundColor(iconColor)
					
					VStack(alignment: .leading, spacing: 2) {
						Text(title)
							.font(.headline)
							.fontWeight(.semibold)
						Text(subtitle)
							.font(.caption)
							.foregroundColor(.secondary)
					}
					
					Spacer()
					
					HStack(spacing: 4) {
						Image(systemName: "hand.tap.fill")
							.font(.caption2)
						Text("Interactive")
							.font(.caption2)
					}
					.foregroundColor(.secondary)
				}
				
				// Demo area
				content
					.frame(height: 280)
					.background(.gray.opacity(0.05))
					.clipShape(RoundedRectangle(cornerRadius: 12))
			}
			.padding(20)
			
			// Metrics
			metrics
		}
		.background(.white)
		.clipShape(RoundedRectangle(cornerRadius: 16))
		.shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
		.padding(.horizontal)
	}
}

struct MetricsPanel: View {
	let zoomState: ZoomState?
	
	var body: some View {
		VStack(spacing: 0) {
			Rectangle()
				.fill(.gray.opacity(0.2))
				.frame(height: 1)
			
			if let zoomState = zoomState {
				HStack(spacing: 16) {
					MetricItem(
						title: "Scale",
						value: String(format: "%.2f×", zoomState.scale),
						color: .blue
					)
					
					MetricItem(
						title: "Mode",
						value: zoomState.mode == .fit ? "Fit" : "Fill",
						color: zoomState.mode == .fit ? .green : .purple
					)
					
					StatusBadge(
						title: "Zoom",
						isActive: zoomState.isZooming,
						color: .orange
					)
					
					StatusBadge(
						title: "Touch",
						isActive: zoomState.isUserInteracting,
						color: .red
					)
				}
				.padding(16)
			} else {
				HStack {
					Text("Waiting for interaction...")
						.font(.caption)
						.foregroundColor(.secondary)
					Spacer()
				}
				.padding(16)
			}
		}
	}
}

struct MetricItem: View {
	let title: String
	let value: String
	let color: Color
	
	var body: some View {
		VStack(spacing: 4) {
			Text(value)
				.font(.system(.subheadline, design: .monospaced))
				.fontWeight(.semibold)
				.foregroundColor(color)
			Text(title)
				.font(.caption2)
				.foregroundColor(.secondary)
		}
	}
}

struct StatusBadge: View {
	let title: String
	let isActive: Bool
	let color: Color
	
	var body: some View {
		HStack(spacing: 4) {
			Circle()
				.fill(isActive ? color : .gray.opacity(0.3))
				.frame(width: 6, height: 6)
			Text(title)
				.font(.caption2)
				.foregroundColor(isActive ? color : .secondary)
		}
		.padding(.horizontal, 8)
		.padding(.vertical, 4)
		.background(isActive ? color.opacity(0.1) : .gray.opacity(0.05))
		.clipShape(Capsule())
	}
}

extension View {
	func containerBorder() -> some View {
		self.overlay(
			RoundedRectangle(cornerRadius: 12)
				.strokeBorder(
					LinearGradient(
						colors: [.blue.opacity(0.6), .purple.opacity(0.6)],
						startPoint: .topLeading,
						endPoint: .bottomTrailing
					),
					lineWidth: 2
				)
		)
	}
}

// MARK: - Legacy Examples (for compatibility)

struct ZoomContainerGradientExample: View {
	@State private var zoomState: ZoomState?

	var body: some View {
		VStack {
			ZoomContainer(
				contentSize: CGSize(width: 300, height: 400),
				onZoomStateChanged: { state in
					zoomState = state
				}
			) {
				Rectangle()
					.fill(
						LinearGradient(
							colors: [.purple, .blue, .cyan, .green],
							startPoint: .topLeading,
							endPoint: .bottomTrailing
						)
					)
					.overlay(
						VStack {
							Text("300 × 400")
								.font(.title2)
								.fontWeight(.bold)
								.foregroundColor(.white)
							Text("Gradient Content")
								.font(.caption)
								.foregroundColor(.white.opacity(0.8))
						}
					)
			}
			.background(Color.black.opacity(0.05))

			ZoomStateDisplay(zoomState: zoomState)
		}
	}
}

struct ZoomContainerPhotoExample: View {
	@State private var zoomState: ZoomState?

	var body: some View {
		VStack {
			ZoomContainer(
				contentSize: CGSize(width: 400, height: 300),
				onZoomStateChanged: { state in
					zoomState = state
				},
			) {
				Rectangle()
					.fill(
						RadialGradient(
							colors: [.orange, .pink, .purple],
							center: .center,
							startRadius: 50,
							endRadius: 200,
						),
					)
					.overlay(
						VStack(spacing: 16) {
							Circle()
								.fill(.white.opacity(0.3))
								.frame(width: 80, height: 80)
								.overlay(
									Text("📸")
										.font(.largeTitle),
								)

							Text("400 × 300")
								.font(.title2)
								.fontWeight(.bold)
								.foregroundColor(.white)

							Text("Landscape Photo")
								.font(.caption)
								.foregroundColor(.white.opacity(0.8))
						},
					)
			}
			.background(Color.black.opacity(0.05))

			ZoomStateDisplay(zoomState: zoomState)
		}
	}
}

struct ZoomContainerSquareExample: View {
	@State private var zoomState: ZoomState?

	var body: some View {
		VStack {
			ZoomContainer(
				contentSize: CGSize(width: 350, height: 350),
				onZoomStateChanged: { state in
					zoomState = state
				},
			) {
				Rectangle()
					.fill(
						AngularGradient(
							colors: [.red, .orange, .yellow, .green, .blue, .purple, .red],
							center: .center,
						),
					)
					.overlay(
						VStack(spacing: 12) {
							Text("350 × 350")
								.font(.title2)
								.fontWeight(.bold)
								.foregroundColor(.white)

							Text("Square Content")
								.font(.caption)
								.foregroundColor(.white.opacity(0.8))

							HStack {
								ForEach(0 ..< 3) { _ in
									Circle()
										.fill(.white.opacity(0.3))
										.frame(width: 30, height: 30)
								}
							}
						},
					)
			}
			.background(Color.black.opacity(0.05))

			ZoomStateDisplay(zoomState: zoomState)
		}
	}
}

struct ZoomContainerDebugExample: View {
	@State private var zoomState: ZoomState?
	@State private var initialMode: ZoomMode = .fit
	@State private var contentWidth: Double = 300
	@State private var contentHeight: Double = 400
	@State private var showAdvanced = false

	var body: some View {
		NavigationView {
			ScrollView {
				VStack(spacing: 20) {
					// Configuration Panel
					VStack(spacing: 16) {
						HStack {
							Image(systemName: "gearshape.fill")
								.foregroundColor(.blue)
							Text("Configuration")
								.font(.title2)
								.fontWeight(.semibold)
							Spacer()
						}

						// Initial Mode Section
						VStack(alignment: .leading, spacing: 8) {
							HStack {
								Image(systemName: "viewfinder")
									.foregroundColor(.secondary)
								Text("Initial Mode")
									.font(.subheadline)
									.fontWeight(.medium)
							}
							Picker("Initial Mode", selection: $initialMode) {
								Label("Fit to Container", systemImage: "rectangle.and.arrow.up.right.and.arrow.down.left")
									.tag(ZoomMode.fit)
								Label("Fill Container", systemImage: "rectangle.fill.on.rectangle.fill")
									.tag(ZoomMode.fill)
							}
							.pickerStyle(SegmentedPickerStyle())
						}

						Divider()

						// Content Size Section
						VStack(alignment: .leading, spacing: 12) {
							HStack {
								Image(systemName: "ruler")
									.foregroundColor(.secondary)
								Text("Content Dimensions")
									.font(.subheadline)
									.fontWeight(.medium)
								Spacer()
								Text("\(Int(contentWidth)) × \(Int(contentHeight))")
									.font(.caption)
									.foregroundColor(.secondary)
									.padding(.horizontal, 8)
									.padding(.vertical, 4)
									.background(Color.gray.opacity(0.1))
									.cornerRadius(4)
							}

							VStack(spacing: 8) {
								HStack {
									Text("Width")
										.font(.caption)
										.foregroundColor(.secondary)
										.frame(width: 50, alignment: .leading)
									Slider(value: $contentWidth, in: 100 ... 500, step: 25) {
										Text("Width")
									} minimumValueLabel: {
										Text("100")
											.font(.caption2)
											.foregroundColor(.secondary)
									} maximumValueLabel: {
										Text("500")
											.font(.caption2)
											.foregroundColor(.secondary)
									}
									.accentColor(.blue)
								}

								HStack {
									Text("Height")
										.font(.caption)
										.foregroundColor(.secondary)
										.frame(width: 50, alignment: .leading)
									Slider(value: $contentHeight, in: 100 ... 500, step: 25) {
										Text("Height")
									} minimumValueLabel: {
										Text("100")
											.font(.caption2)
											.foregroundColor(.secondary)
									} maximumValueLabel: {
										Text("500")
											.font(.caption2)
											.foregroundColor(.secondary)
									}
									.accentColor(.blue)
								}
							}
						}
					}
					.padding(20)
					.background(Color(.systemBackground))
					.cornerRadius(16)
					.shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)

					// Preview Section
					VStack(alignment: .leading, spacing: 12) {
						HStack {
							Image(systemName: "eye.fill")
								.foregroundColor(.green)
							Text("Live Preview")
								.font(.title2)
								.fontWeight(.semibold)
							Spacer()
							Image(systemName: "hand.point.up.left.fill")
								.foregroundColor(.secondary)
								.font(.caption)
							Text("Interactive")
								.font(.caption)
								.foregroundColor(.secondary)
						}

						ZoomContainer(
							contentSize: CGSize(width: contentWidth, height: contentHeight),
							initialMode: initialMode,
							onZoomStateChanged: { state in
								zoomState = state
							},
						) {
							Rectangle()
								.fill(
									LinearGradient(
										colors: [.blue, .purple, .pink],
										startPoint: .topLeading,
										endPoint: .bottomTrailing,
									),
								)
								.overlay(
									VStack(spacing: 12) {
										Image(systemName: "viewfinder.circle.fill")
											.font(.largeTitle)
											.foregroundColor(.white.opacity(0.9))

										VStack(spacing: 4) {
											Text("\(Int(contentWidth)) × \(Int(contentHeight))")
												.font(.title2)
												.fontWeight(.bold)
												.foregroundColor(.white)
											Text("Mode: \(initialMode == .fit ? "Fit" : "Fill")")
												.font(.caption)
												.foregroundColor(.white.opacity(0.8))
												.padding(.horizontal, 8)
												.padding(.vertical, 2)
												.background(Color.black.opacity(0.2))
												.cornerRadius(4)
										}
									},
								)
								.overlay {
									Rectangle()
										.strokeBorder(Color.green, lineWidth: 1)
								}
						}
						.frame(height: 300)
						.background(Color(.systemGray6))
						.cornerRadius(12)
						.overlay(
							RoundedRectangle(cornerRadius: 12)
								.stroke(Color(.systemGray4), lineWidth: 1),
						)
						.overlay {
							Rectangle()
								.strokeBorder(Color.blue, lineWidth: 1)
						}
						.id("\(Int(contentWidth))-\(Int(contentHeight))-\(initialMode)")
					}
					.padding(20)
					.background(Color(.systemBackground))
					.cornerRadius(16)
					.shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)

					// Live Metrics
					ProfessionalZoomStateDisplay(zoomState: zoomState)
				}
				.padding(16)
			}
			.navigationTitle("Zoom Debug Console")
			.navigationBarTitleDisplayMode(.large)
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}
}

struct ZoomStateDisplay: View {
	let zoomState: ZoomState?

	var body: some View {
		if let zoomState = zoomState {
			VStack(alignment: .leading, spacing: 8) {
				Text("Zoom State")
					.font(.headline)
				Text("Scale: \(String(format: "%.2f", zoomState.scale))")
				Text("Offset: (\(String(format: "%.1f", zoomState.offset.x)), \(String(format: "%.1f", zoomState.offset.y)))")
				Text("Mode: \(zoomState.mode == .fit ? "Fit" : "Fill")")
				Text("Zooming: \(zoomState.isZooming ? "Yes" : "No")")
				Text("User Interacting: \(zoomState.isUserInteracting ? "Yes" : "No")")
			}
			.font(.caption)
			.padding()
			.background(Color.gray.opacity(0.1))
			.cornerRadius(8)
			.padding()
		}
	}
}

struct ProfessionalZoomStateDisplay: View {
	let zoomState: ZoomState?

	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			HStack {
				Image(systemName: "chart.line.uptrend.xyaxis")
					.foregroundColor(.orange)
				Text("Live Metrics")
					.font(.title2)
					.fontWeight(.semibold)
				Spacer()
				if let zoomState = zoomState {
					HStack(spacing: 8) {
						StatusIndicator(
							isActive: zoomState.isZooming,
							activeColor: .red,
							inactiveColor: .gray,
							label: "ZOOM",
						)
						StatusIndicator(
							isActive: zoomState.isUserInteracting,
							activeColor: .blue,
							inactiveColor: .gray,
							label: "TOUCH",
						)
					}
				}
			}

			if let zoomState = zoomState {
				LazyVGrid(columns: [
					GridItem(.flexible()),
					GridItem(.flexible()),
				], spacing: 12) {
					MetricCard(
						title: "Scale Factor",
						value: String(format: "%.3f", zoomState.scale),
						icon: "magnifyingglass",
						color: .blue,
					)

					MetricCard(
						title: "Current Mode",
						value: zoomState.mode == .fit ? "Fit" : "Fill",
						icon: zoomState
							.mode == .fit ? "rectangle.and.arrow.up.right.and.arrow.down.left" : "rectangle.fill.on.rectangle.fill",
						color: zoomState.mode == .fit ? .green : .purple,
					)

					MetricCard(
						title: "X Offset",
						value: String(format: "%.1f", zoomState.offset.x),
						icon: "arrow.left.and.right",
						color: .orange,
					)

					MetricCard(
						title: "Y Offset",
						value: String(format: "%.1f", zoomState.offset.y),
						icon: "arrow.up.and.down",
						color: .orange,
					)
				}
			} else {
				HStack {
					Spacer()
					VStack(spacing: 8) {
						Image(systemName: "exclamationmark.triangle")
							.font(.title2)
							.foregroundColor(.secondary)
						Text("No zoom state available")
							.font(.caption)
							.foregroundColor(.secondary)
					}
					Spacer()
				}
				.padding(20)
			}
		}
		.padding(20)
		.background(Color(.systemBackground))
		.cornerRadius(16)
		.shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
	}
}

struct StatusIndicator: View {
	let isActive: Bool
	let activeColor: Color
	let inactiveColor: Color
	let label: String

	var body: some View {
		HStack(spacing: 4) {
			Circle()
				.fill(isActive ? activeColor : inactiveColor.opacity(0.3))
				.frame(width: 8, height: 8)
				.overlay(
					Circle()
						.stroke(isActive ? activeColor : inactiveColor, lineWidth: 1),
				)
			Text(label)
				.font(.caption2)
				.fontWeight(.medium)
				.foregroundColor(isActive ? activeColor : inactiveColor)
		}
		.padding(.horizontal, 8)
		.padding(.vertical, 4)
		.background(
			(isActive ? activeColor : inactiveColor)
				.opacity(0.1),
		)
		.cornerRadius(8)
	}
}

struct MetricCard: View {
	let title: String
	let value: String
	let icon: String
	let color: Color

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Image(systemName: icon)
					.foregroundColor(color)
					.font(.caption)
				Text(title)
					.font(.caption)
					.foregroundColor(.secondary)
				Spacer()
			}

			Text(value)
				.font(.title3)
				.fontWeight(.semibold)
				.foregroundColor(.primary)
		}
		.padding(12)
		.background(Color(.systemGray6))
		.cornerRadius(8)
		.overlay(
			RoundedRectangle(cornerRadius: 8)
				.stroke(color.opacity(0.2), lineWidth: 1),
		)
	}
}

#Preview("🎯 Professional Showcase") {
	ZoomContainerShowcase()
}

#Preview("📷 Photo Viewer") {
	PhotoViewerDemo()
}

#Preview("📄 Document Viewer") {
	DocumentViewerDemo()
}

#Preview("🎨 Artwork Viewer") {
	ArtworkViewerDemo()
}

#Preview("📊 Diagram Viewer") {
	DiagramViewerDemo()
}

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
