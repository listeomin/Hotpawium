import SwiftUI

struct OnboardingViewV2: View {
    let onContinue: () -> Void
    @State private var showOnStartup = true
    @State private var isButtonHovered = false
    
    var body: some View {
        ZStack {
            // Фон с иллюстрацией (слой под UI)
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: 420)
                
                // Правая часть с иллюстрацией на фоне
                ZStack {
                    // Фоновая область
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "FFF5E6"),
                                    Color(hex: "FFEDC9")
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Иллюстрация (парень с цветами)
                    if let image = NSImage(named: "man") {
                        Image(nsImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 450)
                            .offset(x: 0, y: -15)
                    }
                }
                .frame(width: 350)
            }
            
            // UI элементы поверх фона
        HStack(spacing: 0) {
            // Левая часть с контентом
            VStack(alignment: .leading, spacing: 24) {
                // Заголовок
                VStack(alignment: .leading, spacing: 8) {
                    Text("Hotpaws")
                        .font(.system(size: 56, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Добро пожаловать!")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(.secondary)
                }
                
                // Карточка с замком (пока заглушка - забронировали место)
                Button(action: {
                    // TODO: Действие открытия настроек
                }) {
                    VStack(spacing: 12) {
                        Text("🔐")
                            .font(.system(size: 40))
                        
                        VStack(spacing: 4) {
                            Text("Разрешите доступ")
                                .font(.system(size: 16, weight: .medium))
                            Text("к горячим клавишам")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(Color(hex: "FF8C42"))
                    }
                    .frame(width: 280, height: 140)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(NSColor.controlBackgroundColor).opacity(0.95))
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                // Чекбокс и кнопка продолжить
                VStack(spacing: 20) {
                    Toggle(isOn: $showOnStartup) {
                        HStack(spacing: 8) {
                            Text("✔️")
                                .font(.system(size: 16))
                            Text("Показывать при запуске")
                                .font(.system(size: 14))
                                .foregroundColor(.primary)
                        }
                    }
                    .toggleStyle(.checkbox)
                    
                    HStack {
                        Spacer()
                        
                        // Кнопка в стиле CategoryButton
                        Button(action: {
                            UserDefaults.standard.set(showOnStartup, forKey: "showOnboardingOnStartup")
                            onContinue()
                        }) {
                            Text("Продолжить")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(
                                    isButtonHovered ? .black : Color(hex: "E5E5EA")
                                )
                                .frame(width: 160, height: 50)
                                .background(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(
                                                isButtonHovered ? 
                                                    Color(hex: "FFDD00").opacity(0.95) :
                                                    Color(hex: "2B3356")
                                            )
                                        
                                        RoundedRectangle(cornerRadius: 25)
                                            .strokeBorder(
                                                LinearGradient(
                                                    colors: isButtonHovered ?
                                                        [Color(hex: "FEDB31"), Color(hex: "FEDB31")] :
                                                        [Color(hex: "3D4466"), Color(hex: "2B3356")],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                ),
                                                lineWidth: 2
                                            )
                                    }
                                )
                                .shadow(
                                    color: isButtonHovered ? Color(hex: "FFDD00").opacity(0.5) : .clear,
                                    radius: 20,
                                    x: 0,
                                    y: 0
                                )
                                .scaleEffect(isButtonHovered ? 1.05 : 1.0)
                                .animation(.easeInOut(duration: 0.2), value: isButtonHovered)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onHover { hovering in
                            isButtonHovered = hovering
                            if hovering {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }
                    }
                }
            }
            .frame(width: 420)
            .padding(.leading, 50)
            .padding(.trailing, 30)
            .padding(.vertical, 40)
            
            // Правая часть - пустое пространство (фон уже снизу)
            Spacer()
                .frame(width: 350)
        }
        }
        .frame(width: 770, height: 480)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

// Preview
struct OnboardingViewV2_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingViewV2(onContinue: {})
    }
}
