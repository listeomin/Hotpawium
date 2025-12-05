import SwiftUI

struct CategoryButton: View {
    let emoji: String
    let title: String
    @State private var isHovered = false
    
    var body: some View {
        Button(action: {
            // Действие при нажатии
            print("Button tapped: \(title)")
        }) {
            HStack(spacing: 12) {
                Text(emoji)
                    .font(.system(size: 32))
                
                Text(title)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isHovered ? .black : Color(hex: "E5E5EA"))
            }
            .frame(width: 200, height: 80)
            .background(
                ZStack {
                    // Фон
                    RoundedRectangle(cornerRadius: 40)
                        .fill(isHovered ? Color(hex: "FFDD00").opacity(0.95) : Color(hex: "1E1E28"))
                    
                    // Обводка
                    RoundedRectangle(cornerRadius: 40)
                        .strokeBorder(
                            LinearGradient(
                                colors: isHovered ? 
                                    [Color(hex: "FEDB31"), Color(hex: "FEDB31")] :
                                    [Color(hex: "4B4B52"), Color(hex: "4B4B53")],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 3
                        )
                }
            )
            .shadow(
                color: isHovered ? Color(hex: "FFDD00").opacity(0.5) : .clear,
                radius: 25,
                x: 0,
                y: 0
            )
            .scaleEffect(isHovered ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isHovered)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            isHovered = hovering
            if hovering {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        }
    }
}

// Helper для работы с hex цветами
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Preview
struct CategoryButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            CategoryButton(emoji: "🐾", title: "GIT")
        }
    }
}
