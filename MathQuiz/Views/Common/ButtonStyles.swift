import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @EnvironmentObject var theme: Theme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.fonts.large)
            .fontWeight(.bold)
//            .foregroundColor(theme.colors.text)
            .foregroundColor(.white)

            .padding(.horizontal, 40)
            .padding(.vertical, 15)
            .background(theme.colors.accent)
            .cornerRadius(10)
            .shadow(color: theme.colors.primary.opacity(0.3), radius: 5, x: 0, y: 3)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    @EnvironmentObject var theme: Theme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.fonts.bold)
            .foregroundColor(theme.colors.primary)
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(theme.colors.primary, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct StandardButton<Style: ButtonStyle>: View {
    let title: String
    let action: () -> Void
    let style: Style
    
    init(title: String, action: @escaping () -> Void, style: Style = PrimaryButtonStyle()) {
        self.title = title
        self.action = action
        self.style = style
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(style)
    }
}
