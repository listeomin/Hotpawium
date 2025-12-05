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
            
            VStack {
                // Кнопки категорий
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
            
            // Группы с командами в центре
            HStack(spacing: 120) {
                // БАЗОВОЕ
                VStack(alignment: .leading, spacing: 24) {
                    Text("БАЗОВОЕ")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(Color(hex: "6F6F73"))
                        .kerning(2)
                    
                    VStack(spacing: 16) {
                        CommandButton(
                            title: "git status",
                            description: "Показать состояние рабочей копии репозитория"
                        )
                        CommandButton(
                            title: "git add .",
                            description: "Добавить все изменения в индекс"
                        )
                        CommandButton(
                            title: "git commit -m",
                            description: "Создать коммит с сообщением"
                        )
                        CommandButton(
                            title: "git push",
                            description: "Отправить изменения в удаленный репозиторий"
                        )
                        CommandButton(
                            title: "git pull",
                            description: "Получить изменения из удаленного репозитория"
                        )
                    }
                }
                
                // ВЕТКИ
                VStack(alignment: .leading, spacing: 24) {
                    Text("ВЕТКИ")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(Color(hex: "6F6F73"))
                        .kerning(2)
                    
                    VStack(spacing: 16) {
                        CommandButton(
                            title: "git branch",
                            description: "Показать список веток"
                        )
                        CommandButton(
                            title: "git checkout -b",
                            description: "Создать и переключиться на новую ветку"
                        )
                        CommandButton(
                            title: "git checkout",
                            description: "Переключиться на другую ветку"
                        )
                        CommandButton(
                            title: "git merge",
                            description: "Объединить ветку с текущей"
                        )
                        CommandButton(
                            title: "git branch -d",
                            description: "Удалить локальную ветку"
                        )
                    }
                }
                
                // ИСТОРИЯ
                VStack(alignment: .leading, spacing: 24) {
                    Text("ИСТОРИЯ")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(Color(hex: "6F6F73"))
                        .kerning(2)
                    
                    VStack(spacing: 16) {
                        CommandButton(
                            title: "git log",
                            description: "Показать историю коммитов"
                        )
                        CommandButton(
                            title: "git log --oneline",
                            description: "Показать краткую историю коммитов"
                        )
                        CommandButton(
                            title: "git diff",
                            description: "Показать изменения в файлах"
                        )
                        CommandButton(
                            title: "git show",
                            description: "Показать информацию о коммите"
                        )
                        CommandButton(
                            title: "git reset --hard",
                            description: "Сбросить изменения до указанного коммита"
                        )
                    }
                }
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
