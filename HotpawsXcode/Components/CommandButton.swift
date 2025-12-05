import SwiftUI
import AppKit

// NSView для обработки правого клика
class RightClickView: NSView {
    var onRightClick: (() -> Void)?
    
    override func rightMouseDown(with event: NSEvent) {
        onRightClick?()
    }
}

struct RightClickViewRepresentable: NSViewRepresentable {
    let onRightClick: () -> Void
    
    func makeNSView(context: Context) -> RightClickView {
        let view = RightClickView()
        view.onRightClick = onRightClick
        return view
    }
    
    func updateNSView(_ nsView: RightClickView, context: Context) {
        nsView.onRightClick = onRightClick
    }
}

struct CommandButton: View {
    let title: String
    let description: String
    @State private var isHovered = false
    @State private var isPressed = false
    @State private var showCopiedTooltip = false
    @ObservedObject var settings: OverlaySettings
    
    var body: some View {
        Button(action: {
            // Копирование команды в буфер обмена
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(title, forType: .string)
            
            // Показать подсказку
            showCopiedTooltip = true
            
            // Скрыть подсказку через 1 секунду
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showCopiedTooltip = false
            }
        }) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.custom("UbuntuMono-Regular", size: 22))
                    .foregroundColor(
                        isPressed ? Color(hex: "E5E5EA") :
                        isHovered ? .black : Color(hex: "D2D2D4")
                    )
                
                Text(description)
                    .font(.custom("Ubuntu-Regular", size: 16))
                    .foregroundColor(
                        isPressed ? Color(hex: "69697C") :
                        isHovered ? Color(hex: "595959") : Color(hex: "69697C")
                    )
                    .lineLimit(2)
            }
            .frame(width: 340, height: 115, alignment: .leading)
            .padding(.leading, 24)
            .background(
                ZStack {
                    // Фон
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            isPressed ? Color(hex: "202643") :
                            isHovered ? Color(hex: "FFDD00").opacity(0.95) :
                            Color(hex: "1E1E28")
                        )
                    
                    // Обводка
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(
                            LinearGradient(
                                colors: isPressed ?
                                    [Color(hex: "2B2B4C"), Color(hex: "181B25")] :
                                isHovered ?
                                    [Color(hex: "FEDB31"), Color(hex: "FEDB31")] :
                                    [Color(hex: "2D2D44"), Color(hex: "333353")],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: isPressed ? 3 : 2
                        )
                }
            )
            .shadow(
                color: (isHovered && !isPressed) ? Color(hex: "FFDD00").opacity(0.5) : .clear,
                radius: 25,
                x: 0,
                y: 0
            )
            .scaleEffect((isHovered && !isPressed) ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isHovered)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .overlay(
                // Подсказка "скопировано"
                Group {
                    if showCopiedTooltip {
                        Text("Скопировано")
                            .font(.custom("Ubuntu-Regular", size: 12))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.8))
                            )
                            .offset(y: -70)
                            .transition(.opacity.combined(with: .scale(scale: 0.9)))
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: showCopiedTooltip)
            )
            .overlay(
                // Невидимый слой для обработки правого клика
                RightClickViewRepresentable(onRightClick: handleRightClick)
                    .allowsHitTesting(true)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
        .onHover { hovering in
            isHovered = hovering
            if hovering {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        }
    }
    
    private func handleRightClick() {
        // Выполнить команду в терминале
        settings.executeCommandInTerminal(title)
        
        // Скрыть приложение
        NSApplication.shared.hide(nil)
    }
}

// Preview
struct CommandButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            CommandButton(
                title: "git status",
                description: "Показать состояние рабочей копии репозитория",
                settings: OverlaySettings()
            )
        }
    }
}
