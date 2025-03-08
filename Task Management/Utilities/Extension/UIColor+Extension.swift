//
//  UIColor+Extension.swift
//  Task Management
//
//  Created by MAC on 05/03/25.
//

import UIKit

extension UIColor{

    static var BackgroundColor: UIColor { return .systemBackground }
    static var PrimaryColor: UIColor{ return UIColor(hex: "#EB1B70") }
    
    static var Text_SecondaryColor: UIColor{ return UIColor(hex: "#3D3D3D") }
    static var surface_SecondaryColor: UIColor{ return UIColor(hex: "#F5F5F5") }
    
    static var quaternaryLight: UIColor{ return UIColor(hex: "#DEDEDE") | UIColor(hex: "#FFFFFF") }
    
    static var PrimaryDarkColor_Only: UIColor{ return UIColor(hex: "#161616") } // PrimaryTextColor
    static var PrimaryDarkColor: UIColor{ return UIColor(hex: "#161616") | .label } // PrimaryTextColor
    static var TextColor: UIColor{ return .label }
    static var TextColor_Black: UIColor{ return UIColor(hex: "#FFFFFF") | .black }
    
    static var ButtonTextColor: UIColor{ return UIColor(hex: "#FFFFFF") }
    static var ButtonColor: UIColor{ return UIColor(hex: "#EB1B70") }
    
    static var TextPlumColor: UIColor{ return UIColor(hex: "#292365") }
    
    static var TextPrimaryColor: UIColor{ return UIColor(hex: "#161616") | .label }
    static var TextTeritaryColor: UIColor{ return UIColor(hex: "#888888") }
    
    static var iconSecondaryColor: UIColor{ return UIColor(hex: "#5F5F5F") | .label }
    
    static var Text_NegativeColor: UIColor{ return UIColor(hex: "#DA3333") }
    
    static var borderColor: UIColor{ return UIColor(hex: "#CACACA") } // PlaceHolderColor
    
    static var focus_borderColor: UIColor{ return UIColor(hex: "#E1DEFF") }
    
    static var disableButtonColor: UIColor{ return UIColor(hex: "#EEEEEE") | UIColor(hex: "#EEEEEE") }
    static var disableTextColor: UIColor{ return UIColor(hex: "#B0B0B0") }
    
    static var surfaceButtonColor: UIColor{ return UIColor(hex: "#8D1043") }
    static var surfaceColor: UIColor{ return UIColor(hex: "#2923651A") }
    
    static var brandColor: UIColor{ return UIColor(hex: "#494194") }
    
    static var TextRegularColor: UIColor{ return UIColor(hex: "#000000") }
    
    static var whiteAlpla_0_3: UIColor{
        return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
    }
    
}
extension UIColor{
    static var random: UIColor{
        return UIColor(red: .random(in: 0.4...1), green: .random(in: 0.4...1), blue: .random(in: 0.4...1), alpha: 1)
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        let hexLength = hexString.count

        guard (hexLength == 6 || (hexLength == 7 && hexString.hasPrefix("#"))) else {
            self.init(white: 0.0, alpha: 0.0) // Return clear color for invalid hex string
            return
        }

        var rgbValue: UInt64 = 0
        let scanner = Scanner(string: hexString)

        if hexString.hasPrefix("#") {
            scanner.currentIndex = hexString.index(after: hexString.startIndex)
        }

        scanner.scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

infix operator |: AdditionPrecedence

public extension UIColor {
    
    // MARK: - Utility Functions
    static func | (lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return lightMode }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
    
    // New function for three modes
    static func color(lightMode: UIColor, darkMode: UIColor, customMode: UIColor = .clear) -> UIColor {
        guard #available(iOS 13.0, *) else { return lightMode }
        return UIColor { (traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return lightMode
            case .dark:
                return darkMode
            default:
                return customMode
            }
        }
    }
}
