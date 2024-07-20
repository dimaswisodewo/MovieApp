//
//  FontUtils.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 20/07/24.
//

import UIKit

enum CustomFont: String {
    case Poppins = "Poppins"
}

class FontUtils {
    static let shared = FontUtils()
    
    private init() {}
    
    func getFont(font: CustomFont, weight: UIFont.Weight, size: CGFloat) -> UIFont {
        var fontName = font.rawValue
        switch weight {
        case .black:
            fontName += "-Black"
            break
        case .bold:
            fontName += "-Bold"
            break
        case .semibold:
            fontName += "-SemiBold"
            break
        case .light:
            fontName += "-Light"
            break
        case .medium:
            fontName += "-Medium"
            break
        case .regular:
            fontName += "-Regular"
            break
        default:
            break
        }
        guard let font = UIFont(name: fontName, size: size) else {
#if DEBUG
            print("Failed to get font: \(fontName)")
#endif
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}
