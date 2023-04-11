import Foundation
import UIKit

extension UIFont {

    public enum CeraProType: String {
        case Italic = "Italic"
        case Light = "Light"
        case Medium = "Medium"
        case Bold = "Bold"
        case Black = "Black"
        case BlackItallic = "BlackItalic"
    }

    static func CeraPro(_ type: CeraProType = .Light, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "CeraPro-\(type.rawValue)", size: size)!
    }
    
    static func FontString(_ type: CeraProType = .Light) -> String{
        return "CeraPro-\(type.rawValue)"
    }

    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }

    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
}
