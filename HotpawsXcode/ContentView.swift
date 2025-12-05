import SwiftUI
import AppKit

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
    // сюда можно привязывать свойства из настроек
    var darkness: Double = 0.25
    var material: NSVisualEffectView.Material = .fullScreenUI
    
    var body: some View {
        ZStack {
            LiveBlurView(material: material)
                .ignoresSafeArea()
            
            Color.black.opacity(darkness)
                .ignoresSafeArea()
        }
    }
}

// 3) Пример использования в том же файле, если хочешь сразу тестировать
struct PreviewWrapper: View {
    @State var darkness: Double = 1

    var body: some View {
        ZStack {
            // твой фон / видео / любая вьюха
            Color.blue.ignoresSafeArea()  // пример динамического контента
            
            // overlay
            FullscreenOverlayView(darkness: darkness)
        }
    }
}

struct PreviewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
}
