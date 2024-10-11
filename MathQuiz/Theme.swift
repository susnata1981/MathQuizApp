import SwiftUI

struct ThemeColors {
    let primary: Color
    let secondary: Color
    let background: Color
    let text: Color
    let accent: Color
    let success: Color
    let error: Color
}

struct ThemeFonts {
    let small: Font
    let regular: Font
    let bold: Font
    let large: Font
    let xlarge: Font
}

class Theme: ObservableObject {
    @Published var colors: ThemeColors
    let fonts: ThemeFonts
    
    static let theme1 = Theme(
        colors: ThemeColors(
            primary: Color("Theme1Primary"),
            secondary: Color("Theme1Secondary"),
            background: Color("Theme1Background"),
            text: Color("Theme1Text"),
            accent: Color("Theme1Accent"),
            success: Color("Theme1Accent"),
            error: Color.red
        ),
        fonts: ThemeFonts(
            small: Font.custom("ComicSansMS", size: 12),
            regular: Font.custom("ComicSansMS", size: 16),
            bold: Font.custom("ComicSansMS-Bold", size: 16),
            large: Font.custom("ComicSansMS-Bold", size: 24),
            xlarge: Font.custom("ComicSansMS-Bold", size: 48)
        )
    )
    
    static let theme2 = Theme(
        colors: ThemeColors(
            primary: Color("Theme2Primary"),
            secondary: Color("Theme2Secondary"),
            background: Color("Theme2Background"),
            text: Color("Theme2Text"),
            accent: Color("Theme2Accent"),
            success: Color("Theme2Accent"),
            error: Color.red
        ),
        fonts: ThemeFonts(
            small: Font.custom("Papyrus", size: 12),
            regular: Font.custom("Papyrus", size: 16),
            bold: Font.custom("Papyrus-Bold", size: 16),
            large: Font.custom("Papyrus-Bold", size: 24),
            xlarge: Font.custom("Papyrus-Bold", size: 48)
        )
    )
    
    init(colors: ThemeColors, fonts: ThemeFonts) {
        self.colors = colors
        self.fonts = fonts
    }
    
    func switchToTheme1() {
        self.colors = Theme.theme1.colors
    }
    
    func switchToTheme2() {
        self.colors = Theme.theme2.colors
    }
}
