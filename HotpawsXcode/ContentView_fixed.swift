import SwiftUI
import AppKit

// ObservableObject для управления настройками оверлея
class OverlaySettings: ObservableObject {
    @Published var darkness: Double = 0.48  // 48% прозрачности по умолчанию
    @Published var blurOpacity: Double = 0.24  // 24% размытия по умолчанию
    @Published var selectedTerminal: TerminalApp = .iterm
    
    enum TerminalApp: String {
        case terminal = "Terminal"
        case iterm = "iTerm"
    }
    
    func updateDarkness(from sliderValue: Double) {
        darkness = sliderValue / 100.0
    }
    
    func updateBlur(from sliderValue: Double) {
        blurOpacity = sliderValue / 100.0
    }
    
    // Функция для выполнения команды в терминале
    func executeCommandInTerminal(_ command: String) {
        // Выполняем в фоновом потоке
        DispatchQueue.global(qos: .userInitiated).async {
            let script: String
            
            switch self.selectedTerminal {
            case .iterm:
                // Простой скрипт для iTerm - activate запустит приложение если нужно
                script = """
                tell application "iTerm"
                    activate
                    delay 1.5
                    
                    if (count of windows) = 0 then
                        set newWindow to (create window with default profile)
                        tell current session of newWindow
                            write text "\(command)"
                        end tell
                    else
                        tell current window
                            tell current session
                                write text "\(command)"
                            end tell
                        end tell
                    end if
                end tell
                """
                
            case .terminal:
                script = """
                tell application "Terminal"
                    activate
                    delay 0.5
                    
                    if (count of windows) = 0 then
                        do script "\(command)"
                    else
                        tell front window
                            do script "\(command)" in selected tab
                        end tell
                    end if
                end tell
                """
            }
            
            var error: NSDictionary?
            if let scriptObject = NSAppleScript(source: script) {
                scriptObject.executeAndReturnError(&error)
                if let error = error {
                    print("AppleScript error: \(error)")
                }
            }
        }
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
    @State private var selectedCategoryIndex = 0
    
    var body: some View {
        ZStack {
            // Фоновый слой для обработки кликов на пустом месте
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    // Скрыть приложение при клике на пустое место
                    NSApplication.shared.hide(nil)
                }
                .ignoresSafeArea()
            
            LiveBlurView(material: .fullScreenUI)
                .opacity(settings.blurOpacity)
                .ignoresSafeArea()
                .allowsHitTesting(false)
            
            Color.black.opacity(settings.darkness)
                .ignoresSafeArea()
                .allowsHitTesting(false)
            
            VStack {
                // Кнопки категорий
                HStack(spacing: 48) {
                    ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                        CategoryButton(
                            icon: category.icon, // Передаём Phosphor иконку
                            title: category.title,
                            action: {
                                selectedCategoryIndex = index
                            },
                            isSelected: selectedCategoryIndex == index
                        )
                    }
                }
                .padding(.top, 128)
                
                Spacer()
            }
            
            // Группы команд для выбранной категории
            HStack(spacing: 120) {
                ForEach(categories[selectedCategoryIndex].groups) { group in
                    VStack(alignment: .leading, spacing: 24) {
                        Text(group.title)
                            .font(.custom("UbuntuMono-Regular", size: 24))
                            .foregroundColor(Color(hex: "6F6F73"))
                            .kerning(2)
                        
                        VStack(spacing: 16) {
                            ForEach(group.commands) { command in
                                CommandButton(
                                    title: command.title,
                                    description: command.description,
                                    settings: settings
                                )
                            }
                        }
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
