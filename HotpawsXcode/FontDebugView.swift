import SwiftUI

struct FontDebugView: View {
    init() {
        // Выводим все шрифты Ubuntu в консоль при инициализации
        print("========== ДОСТУПНЫЕ UBUNTU ШРИФТЫ ==========")
        let allFonts = NSFontManager.shared.availableFontFamilies
        for family in allFonts where family.contains("Ubuntu") {
            print("Family: \(family)")
            if let members = NSFontManager.shared.availableMembers(ofFontFamily: family) {
                for member in members {
                    if let fontName = member[0] as? String,
                       let weight = member[2] as? Int {
                        print("  → PostScript Name: \(fontName), Weight: \(weight)")
                    }
                }
            }
        }
        print("=============================================")
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Проверка шрифтов")
                .font(.headline)
            
            Text("git status")
                .font(.custom("Ubuntu Mono", size: 24))
            
            Text("Описание команды на русском")
                .font(.custom("Ubuntu", size: 16))
            
            Text("Смотри в консоль Xcode для списка доступных шрифтов!")
                .foregroundColor(.gray)
                .padding()
        }
        .padding()
    }
}

#Preview {
    FontDebugView()
}
