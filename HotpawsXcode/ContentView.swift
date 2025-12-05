import SwiftUI
import AppKit

// ObservableObject для управления настройками оверлея
class OverlaySettings: ObservableObject {
    @Published var darkness: Double = 0.48  // 48% прозрачности по умолчанию
    @Published var blurOpacity: Double = 0.24  // 24% размытия по умолчанию
    
    func updateDarkness(from sliderValue: Double) {
        darkness = sliderValue / 100.0
    }
    
    func updateBlur(from sliderValue: Double) {
        blurOpacity = sliderValue / 100.0
    }
}

// 1) blur слой
struct LiveBlurView: NSViewRepresentable {
    var material: NSVisualEffectView.Material = .fullScreenUI
    var blendingMode: NSVisualEffectView.BlendingMode = .behindWindow
    var state: NSVisualEffectView.State = .active

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = state
        view.wantsLayer = true
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
        nsView.state = state
    }
}

// 2) overlay с blur + черный слой
struct FullscreenOverlayView: View {
    @ObservedObject var settings: OverlaySettings
    
    var body: some View {
        ZStack {
            LiveBlurView(material: .fullScreenUI)
                .opacity(settings.blurOpacity)
                .ignoresSafeArea()
            
            Color.black.opacity(settings.darkness)
                .ignoresSafeArea()
            
            // Кнопки категорий
            VStack {
                HStack(spacing: 48) {
                    CategoryButton(emoji: "🐾", title: "GIT")
                    CategoryButton(emoji: "📦", title: "NPM")
                    CategoryButton(emoji: "📁", title: "Files")
                    CategoryButton(emoji: "🌐", title: "Network")
                    CategoryButton(emoji: "⚙️", title: "System")
                }
                .padding(.top, 128)
                
                Spacer()
            }
        }
    }
}

// 3) Пример использования в том же файле, если хочешь сразу тестировать
struct PreviewWrapper: View {
    @StateObject var settings = OverlaySettings()

    var body: some View {
        ZStack {
            // твой фон / видео / любая вьюха
            Color.blue.ignoresSafeArea()  // пример динамического контента
            
            // overlay
            FullscreenOverlayView(settings: settings)
        }
    }
}

struct PreviewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
}
