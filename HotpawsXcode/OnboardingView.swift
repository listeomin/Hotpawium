import SwiftUI

struct OnboardingView: View {
    let onContinue: () -> Void
    @State private var showOnStartup = true
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Hotpaws")
                .font(.system(size: 48, weight: .bold))
            
            Toggle("Показывать окно при запуске", isOn: $showOnStartup)
                .padding(.horizontal, 40)
            
            Button("Приступим!") {
                // Сохраняем настройку
                UserDefaults.standard.set(showOnStartup, forKey: "showOnboardingOnStartup")
                onContinue()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .frame(width: 400, height: 300)
        .background(Color(NSColor.windowBackgroundColor))
    }
}
