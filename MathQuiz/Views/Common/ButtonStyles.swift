import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @EnvironmentObject var theme: Theme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.fonts.regular)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(theme.colors.primary)
            .cornerRadius(8)
            .shadow(color: theme.colors.primary.opacity(0.2), radius: 5, x: 0, y: 3)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct PrimaryButtonStyleDarkMode: ButtonStyle {
    @EnvironmentObject var theme: Theme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.fonts.regular)
            .foregroundColor(theme.colors.accent)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(theme.colors.primary.opacity(0.4))
            .cornerRadius(8)
            .shadow(color: theme.colors.primary.opacity(0.2), radius: 5, x: 0, y: 3)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    @EnvironmentObject var theme: Theme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.fonts.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
//            .background(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(theme.colors.accent, lineWidth: 2)
//            )
            .background(theme.colors.secondary)
            .cornerRadius(8)
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

struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(spacing: 20) {
                StandardButton(title: "Primary Button", action: {})
                    .buttonStyle(PrimaryButtonStyle())
                
                StandardButton(title: "Secondary Button", action: {})
                    .buttonStyle(SecondaryButtonStyle())
                
                StandardButton(title: "Default Primary", action: {})
                
                StandardButton(title: "Custom Secondary", action: {}, style: SecondaryButtonStyle())
            }
            .padding()
            .environmentObject(Theme.theme4)
            .previewDisplayName("Light Mode")
            
            VStack(spacing: 20) {
                StandardButton(title: "Primary Button", action: {})
                    .buttonStyle(PrimaryButtonStyle())
                
                StandardButton(title: "Secondary Button", action: {})
                    .buttonStyle(PrimaryButtonStyleDarkMode())
                
                StandardButton(title: "Default Primary", action: {})
                
                StandardButton(title: "Custom Secondary", action: {}, style: PrimaryButtonStyleDarkMode())
            }
            .padding()
            .environmentObject(Theme.theme1)
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
