import SwiftUI

// Временный view для проверки доступных шрифтов
struct FontTester: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Доступные шрифты в приложении:")
                .font(.headline)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(NSFontManager.shared.availableFontFamilies, id: \.self) { family in
                        if family.contains("Ubuntu") {
                            Text("\(family)")
                                .font(.system(size: 12))
                            
                            ForEach(NSFontManager.shared.availableMembers(ofFontFamily: family) ?? [], id: \.self) { member in
                                if let fontName = member[0] as? String {
                                    Text("  → \(fontName)")
                                        .font(.system(size: 10))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .frame(width: 500, height: 600)
    }
}

#Preview {
    FontTester()
}
