import SwiftUI

struct ThemeColors {
    let primary: Color
    let secondary: Color
    let background: Color
    let text: Color
    let accent: Color
    let success: Color
    let error: Color
    let disabled: Color
    let selected: Color
    let button: Color
}

struct ThemeFonts {
    let small: Font
    let regular: Font
    let bold: Font
    let large: Font
    let xlarge: Font
    let xxlarge: Font
    let caption: Font  // Added caption font
}

class Theme: ObservableObject {
    @Published var colors: ThemeColors
    let fonts: ThemeFonts
    
    static let theme1 = Theme(
        colors: ThemeColors(
            primary: Color("Theme1Primary"),
            secondary: Color("Theme1Secondary"),
            background: Color("Theme1Background"), // #FFF9C4
            text: Color("Theme1Primary"),
            accent: Color("Theme1Accent"),
            success: Color("Theme1Accent"),
            error: Color.red.opacity(0.7),
            disabled: Color.gray,
            selected: Color("Theme1Accent"),
            button: Color("Theme1Accent")
        ),
        fonts: ThemeFonts(
            small: Font.custom("ComicSansMS", size: 12),
            regular: Font.custom("ComicSansMS", size: 16),
            bold: Font.custom("ComicSansMS-Bold", size: 16),
            large: Font.custom("ComicSansMS-Bold", size: 24),
            xlarge: Font.custom("ComicSansMS-Bold", size: 40),
            xxlarge: Font.custom("ComicSansMS-Bold", size: 60),
            caption: Font.custom("ComicSansMS", size: 10)  // Added caption font
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
            error: Color.red.opacity(0.7),
            disabled: Color.gray,
            selected: Color("Theme1Accent"),
            button: Color("Theme1Accent")
        ),
        fonts: ThemeFonts(
            small: Font.custom("Papyrus", size: 12),
            regular: Font.custom("Papyrus", size: 16),
            bold: Font.custom("Papyrus-Bold", size: 16),
            large: Font.custom("Papyrus-Bold", size: 24),
            xlarge: Font.custom("Papyrus-Bold", size: 40),
            xxlarge: Font.custom("Papyrus-Bold", size: 84),
            caption: Font.custom("Papyrus", size: 10)  // Added caption font
        )
    )
    
    
        static let theme4 = Theme(
            colors: ThemeColors(
                primary: Color.init(hex: 0xe977ce),
                secondary: Color.init(hex: 0xf3bac8),
                background: Color.init(hex: 0xFAFAFA),
                text: Color.init(hex: 0x607D8B),
                accent: Color.init(hex: 0xa96ee7),
                success: Color.init(hex: 0x66BB6A),
                error: Color.init(hex: 0xF44336),
                disabled: Color.gray.opacity(0.5),
                selected: Color.init(hex: 0xFFD275),
                button: Color.init(hex: 0xD1495B)
            ),
            fonts: ThemeFonts(
                small: Font.footnote,
                regular: Font.body,
                bold: Font.headline,
                large: Font.title,
                xlarge: Font.largeTitle,
                xxlarge: Font.custom("ComicSansMS-Bold", size: 60),
                caption: Font.caption
            )
        )
    
    static let theme5 = Theme(
        colors: ThemeColors(
            primary: Color.init(hex: 0x5cb2af),
            secondary: Color.init(hex: 0x7dd8c3),
            background: Color.init(hex: 0xfafafa),
            text: Color.init(hex: 0x3b7e9b),
//            accent: Color.init(hex: 0xf76e6e),
            accent: Color.init(hex: 0xFF6F61),
            success: Color.init(hex: 0x66BB6A),
            error: Color.init(hex: 0xF44336),
            disabled: Color.gray.opacity(0.5),
            selected: Color.init(hex: 0xFFD275),
            button: Color.init(hex: 0xD1495B)
        ),
        fonts: ThemeFonts(
            small: Font.footnote,
            regular: Font.body,
            bold: Font.headline,
            large: Font.title,
            xlarge: Font.largeTitle,
            xxlarge: Font.custom("ComicSansMS-Bold", size: 60),
            caption: Font.caption
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
