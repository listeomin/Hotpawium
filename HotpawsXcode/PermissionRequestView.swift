import SwiftUI

struct PermissionRequestView: View {
    let onOpenSettings: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "hand.raised.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Требуется разрешение")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 10) {
                Text("Для работы горячих клавиш приложению нужен доступ к функциям универсального доступа")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                Text("После выдачи разрешения окно закроется автоматически")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            HStack(spacing: 15) {
                Button("Отмена") {
                    onCancel()
                }
                .keyboardShortcut(.escape, modifiers: [])
                
                Button("Открыть настройки") {
                    onOpenSettings()
                }
                .keyboardShortcut(.return, modifiers: [])
                .buttonStyle(.borderedProminent)
            }
            .padding(.top, 10)
        }
        .frame(width: 450, height: 280)
        .padding()
    }
}
