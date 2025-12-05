import SwiftUI

struct CategoryButton: View {
    let emoji: String
    let title: String
    let action: () -> Void
    let isSelected: Bool
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(emoji)
                    .font(.system(size: 32))
                
                Text(title)
                    .font(.custom("UbuntuMono-Regular", size: 20))
                    .foregroundColor(
                        isSelected ? Color(hex: "E5E5EA") :
                        isHovered ? .black : Color(hex: "E5E5EA")
                    )
            }
            .frame(width: 200, height: 80)
            .background(
                ZStack {
                    // Фон
                    RoundedRectangle(cornerRadius: 40)
                        .fill(
                            isSelected ? Color(hex: "202643") :
                            isHovered ? Color(hex: "FFDD00").opacity(0.95) :
                            Color(hex: "1E1E28")
                        )
                    
                    // Обводка
                    RoundedRectangle(cornerRadius: 40)
                        .strokeBorder(
                            LinearGradient(
                                colors: isSelected ?
                                    [Color(hex: "2B2B4C"), Color(hex: "181B25")] :
                                isHovered ?
                                    [Color(hex: "FEDB31"), Color(hex: "FEDB31")] :
                                    [Color(hex: "2D2D44"), Color(hex: "333353")],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: isSelected ? 3 : (isHovered ? 3 : 2)
                        )
                }
            )
            .shadow(
                color: (isHovered && !isSelected) ? Color(hex: "FFDD00").opacity(0.5) : .clear,
                radius: 25,
                x: 0,
                y: 0
            )
            .scaleEffect((isHovered && !isSelected) ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isHovered)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
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
            
            CategoryButton(emoji: "🐾", title: "GIT", action: {}, isSelected: false)
        }
    }
}
