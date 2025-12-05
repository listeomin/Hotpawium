import SwiftUI

struct CommandButton: View {
    let title: String
    let description: String
    @State private var isHovered = false
    
    var body: some View {
        Button(action: {
            // Действие при нажатии
            print("Command tapped: \(title)")
        }) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isHovered ? .black : Color(hex: "D2D2D4"))
                
                Text(description)
                    .font(.system(size: 11))
                    .foregroundColor(isHovered ? Color(hex: "595959") : Color(hex: "69697C"))
                    .lineLimit(2)
            }
            .frame(width: 340, height: 115, alignment: .leading)
            .padding(.leading, 24)
            .background(
                ZStack {
                    // Фон
                    RoundedRectangle(cornerRadius: 24)
                        .fill(isHovered ? Color(hex: "FFDD00").opacity(0.95) : Color(hex: "1E1E28"))
                    
                    // Обводка
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(
                            LinearGradient(
                                colors: isHovered ?
                                    [Color(hex: "FEDB31"), Color(hex: "FEDB31")] :
                                    [Color(hex: "4B4B52"), Color(hex: "4B4B53")],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 2
                        )
                }
            )
            .shadow(
                color: isHovered ? Color(hex: "FFDD00").opacity(0.5) : .clear,
                radius: 25,
                x: 0,
                y: 0
            )
            .scaleEffect(isHovered ? 1.02 : 1.0)
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

// Preview
struct CommandButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            CommandButton(
                title: "git status",
                description: "Показать состояние рабочей копии репозитория"
            )
        }
    }
}
