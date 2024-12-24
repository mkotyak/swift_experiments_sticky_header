import SwiftUI

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}

struct ContentView: View {
    @State private var stickyViewFrame: CGRect = .zero

    let coordinateSpaceName = "ScrollableContainer"

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    imageView
                        .padding(.vertical, 8)

                    Group {
                        stickyHeaderView
                            .position(
                                x: stickyViewFrame.midX,
                                y: stickyViewFrame.origin.y < 0
                                    ? -stickyViewFrame.origin.y + stickyViewFrame.size.height / 2
                                    : stickyViewFrame.size.height / 2
                            )
                            .zIndex(1)
                    }
                    .background(GeometryReader { geo in
                        Color.clear
                            .preference(
                                key: FramePreferenceKey.self,
                                value: geo.frame(in: .named(coordinateSpaceName))
                            )
                    })
                    .onPreferenceChange(FramePreferenceKey.self) { value in
                        stickyViewFrame = value
                    }

                    ForEach(0 ..< 30, id: \.self) { index in
                        itemView(for: index)
                    }
                }
            }
            .coordinateSpace(name: coordinateSpaceName)
            .navigationTitle("Sticky Header Example")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var imageView: some View {
        Image(systemName: "photo.artframe.circle")
            .resizable()
            .frame(width: 100, height: 100)
    }

    private var stickyHeaderView: some View {
        Text("Sticky Header")
            .font(.largeTitle)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .foregroundColor(.white)
            .background(Color.gray)
    }

    private func itemView(for index: Int) -> some View {
        Text("Item \(index)")
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.gray.opacity(0.2))
            .border(Color.black, width: 1)
    }
}
