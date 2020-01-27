import UIKit

// https://github.com/noppefoxwolf/ColorSupport

extension UIColor {
    
    enum AppearanceMode {
        case light
        case dark
    }
    
    static var systemRed: UIColor {
        return _systemRed()
    }
    
    static func _systemRed(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 1, green: 0.231373, blue: 0.188235, alpha: 1)
        case .dark:
            return .init(displayP3Red: 1, green: 0.270588, blue: 0.227451, alpha: 1)
        }
    }
    
    static var systemGreen: UIColor {
        return _systemGreen()
    }
    
    static func _systemGreen(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.203922, green: 0.780392, blue: 0.34902, alpha: 1)
        case .dark:
            return .init(displayP3Red: 0.188235, green: 0.819608, blue: 0.345098, alpha: 1)
        }
    }
    
    static var systemBlue: UIColor {
        return _systemBlue()
    }
    
    static func _systemBlue(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0, green: 0.478431, blue: 1, alpha: 1)
        case .dark:
            return .init(displayP3Red: 0.0392157, green: 0.517647, blue: 1, alpha: 1)
        }
    }
    
    static var systemOrange: UIColor {
        return _systemOrange()
    }
    
    static func _systemOrange(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 1, green: 0.584314, blue: 0, alpha: 1)
        case .dark:
            return .init(displayP3Red: 1, green: 0.623529, blue: 0.0392157, alpha: 1)
        }
    }
    
    static var systemYellow: UIColor {
        return _systemYellow()
    }
    
    static func _systemYellow(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 1, green: 0.8, blue: 0, alpha: 1)
        case .dark:
            return .init(displayP3Red: 1, green: 0.839216, blue: 0.0392157, alpha: 1)
        }
    }
    
    static var systemPink: UIColor {
        return _systemPink()
    }
    
    static func _systemPink(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 1, green: 0.176471, blue: 0.333333, alpha: 1)
        case .dark:
            return .init(displayP3Red: 1, green: 0.215686, blue: 0.372549, alpha: 1)
        }
    }
    
    static var systemPurple: UIColor {
        return _systemPurple()
    }
    
    static func _systemPurple(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.686275, green: 0.321569, blue: 0.870588, alpha: 1)
        case .dark:
            return .init(displayP3Red: 0.74902, green: 0.352941, blue: 0.94902, alpha: 1)
        }
    }
    
    static var systemBrown: UIColor {
        return _systemBrown()
    }
    
    static func _systemBrown(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.635294, green: 0.517647, blue: 0.368627, alpha: 1)
        case .dark:
            return .init(displayP3Red: 0.67451, green: 0.556863, blue: 0.407843, alpha: 1)
        }
    }
    
    static var systemTeal: UIColor {
        return _systemTeal()
    }
    
    static func _systemTeal(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.352941, green: 0.784314, blue: 0.980392, alpha: 1)
        case .dark:
            return .init(displayP3Red: 0.352941, green: 0.784314, blue: 0.980392, alpha: 1)
        }
    }
    
    static var systemIndigo: UIColor {
        return _systemIndigo()
    }
    
    static func _systemIndigo(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.345098, green: 0.337255, blue: 0.839216, alpha: 1)
        case .dark:
            return .init(displayP3Red: 0.345098, green: 0.337255, blue: 0.839216, alpha: 1)
        }
    }
    
    static var systemGray: UIColor {
        return _systemGray()
    }
    
    static func _systemGray(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.556863, green: 0.556863, blue: 0.576471, alpha: 1)
        case .dark:
            return .init(displayP3Red: 0.556863, green: 0.556863, blue: 0.576471, alpha: 1)
        }
    }
    
    static var systemGray2: UIColor {
        return _systemGray2()
    }
    
    static func _systemGray2(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.682353, green: 0.682353, blue: 0.698039, alpha: 1)
        case .dark:
            return .init(displayP3Red: 0.388235, green: 0.388235, blue: 0.4, alpha: 1)
        }
    }
    
    static var systemGray3: UIColor {
        return _systemGray3()
    }
    
    static func _systemGray3(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.780392, green: 0.780392, blue: 0.8, alpha: 1)
        case .dark:
            return .init(displayP3Red: 0.282353, green: 0.282353, blue: 0.290196, alpha: 1)
        }
    }
    
    static var systemGray4: UIColor {
        return _systemGray4()
    }
    
    static func _systemGray4(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.819608, green: 0.819608, blue: 0.839216, alpha: 1)
        case .dark:
            return .init(displayP3Red: 0.227451, green: 0.227451, blue: 0.235294, alpha: 1)
        }
    }
    
    static var systemGray5: UIColor {
        return _systemGray5()
    }
    
    static func _systemGray5(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.898039, green: 0.898039, blue: 0.917647, alpha: 1)
        case .dark:
            return .init(displayP3Red: 0.172549, green: 0.172549, blue: 0.180392, alpha: 1)
        }
    }
    
    static var systemGray6: UIColor {
        return _systemGray6()
    }
    
    static func _systemGray6(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.94902, green: 0.94902, blue: 0.968627, alpha: 1)
        case .dark:
            return .init(displayP3Red: 0.109804, green: 0.109804, blue: 0.117647, alpha: 1)
        }
    }
    
    static var label: UIColor {
        return _label()
    }
    
    static func _label(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(white: 0, alpha: 1)
        case .dark:
            return .init(white: 1, alpha: 1)
        }
    }
    
    static var secondaryLabel: UIColor {
        return _secondaryLabel()
    }
    
    static func _secondaryLabel(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.235294, green: 0.235294, blue: 0.262745, alpha: 0.6)
        case .dark:
            return .init(displayP3Red: 0.921569, green: 0.921569, blue: 0.960784, alpha: 0.6)
        }
    }
    
    static var tertiaryLabel: UIColor {
        return _tertiaryLabel()
    }
    
    static func _tertiaryLabel(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.235294, green: 0.235294, blue: 0.262745, alpha: 0.3)
        case .dark:
            return .init(displayP3Red: 0.921569, green: 0.921569, blue: 0.960784, alpha: 0.3)
        }
    }
    
    static var quaternaryLabel: UIColor {
        return _quaternaryLabel()
    }
    
    static func _quaternaryLabel(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.235294, green: 0.235294, blue: 0.262745, alpha: 0.18)
        case .dark:
            return .init(displayP3Red: 0.921569, green: 0.921569, blue: 0.960784, alpha: 0.16)
        }
    }
    
    static var link: UIColor {
        return _link()
    }
    
    static func _link(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0, green: 0.478431, blue: 1, alpha: 1)
        case .dark:
            return .init(displayP3Red: 0.0352941, green: 0.517647, blue: 1, alpha: 1)
        }
    }
    
    static var placeholderText: UIColor {
        return _placeholderText()
    }
    
    static func _placeholderText(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.235294, green: 0.235294, blue: 0.262745, alpha: 0.3)
        case .dark:
            return .init(displayP3Red: 0.921569, green: 0.921569, blue: 0.960784, alpha: 0.3)
        }
    }
    
    static var separator: UIColor {
        return _separator()
    }
    
    static func _separator(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.235294, green: 0.235294, blue: 0.262745, alpha: 0.29)
        case .dark:
            return .init(displayP3Red: 0.329412, green: 0.329412, blue: 0.345098, alpha: 0.6)
        }
    }
    
    static var opaqueSeparator: UIColor {
        return _opaqueSeparator()
    }
    
    static func _opaqueSeparator(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.776471, green: 0.776471, blue: 0.784314, alpha: 1)
        case .dark:
            return .init(displayP3Red: 0.219608, green: 0.219608, blue: 0.227451, alpha: 1)
        }
    }
    
    static var systemBackground: UIColor {
        return _systemBackground()
    }
    
    static func _systemBackground(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(white: 1, alpha: 1)
        case .dark:
            return .init(white: 0, alpha: 1)
        }
    }
    
    static var secondarySystemBackground: UIColor {
        return _secondarySystemBackground()
    }
    
    static func _secondarySystemBackground(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.94902, green: 0.94902, blue: 0.968627, alpha: 1)
        case .dark:
            return .init(displayP3Red: 0.109804, green: 0.109804, blue: 0.117647, alpha: 1)
        }
    }
    
    static var tertiarySystemBackground: UIColor {
        return _tertiarySystemBackground()
    }
    
    static func _tertiarySystemBackground(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(white: 1, alpha: 1)
        case .dark:
            return .init(displayP3Red: 0.172549, green: 0.172549, blue: 0.180392, alpha: 1)
        }
    }
    
    static var systemGroupedBackground: UIColor {
        return _systemGroupedBackground()
    }
    
    static func _systemGroupedBackground(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.94902, green: 0.94902, blue: 0.968627, alpha: 1)
        case .dark:
            return .init(white: 0, alpha: 1)
        }
    }
    
    static var secondarySystemGroupedBackground: UIColor {
        return _secondarySystemGroupedBackground()
    }
    
    static func _secondarySystemGroupedBackground(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(white: 1, alpha: 1)
        case .dark:
            return .init(displayP3Red: 0.109804, green: 0.109804, blue: 0.117647, alpha: 1)
        }
    }
    
    static var tertiarySystemGroupedBackground: UIColor {
        return _tertiarySystemGroupedBackground()
    }
    
    static func _tertiarySystemGroupedBackground(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.94902, green: 0.94902, blue: 0.968627, alpha: 1)
        case .dark:
            return .init(displayP3Red: 0.172549, green: 0.172549, blue: 0.180392, alpha: 1)
        }
    }
    
    static var systemFill: UIColor {
        return _systemFill()
    }
    
    static func _systemFill(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.470588, green: 0.470588, blue: 0.501961, alpha: 0.2)
        case .dark:
            return .init(displayP3Red: 0.470588, green: 0.470588, blue: 0.501961, alpha: 0.36)
        }
    }
    
    static var secondarySystemFill: UIColor {
        return _secondarySystemFill()
    }
    
    static func _secondarySystemFill(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.470588, green: 0.470588, blue: 0.501961, alpha: 0.16)
        case .dark:
            return .init(displayP3Red: 0.470588, green: 0.470588, blue: 0.501961, alpha: 0.32)
        }
    }
    
    static var tertiarySystemFill: UIColor {
        return _tertiarySystemFill()
    }
    
    static func _tertiarySystemFill(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.462745, green: 0.462745, blue: 0.501961, alpha: 0.12)
        case .dark:
            return .init(displayP3Red: 0.462745, green: 0.462745, blue: 0.501961, alpha: 0.24)
        }
    }
    
    static var quaternarySystemFill: UIColor {
        return _quaternarySystemFill()
    }
    
    static func _quaternarySystemFill(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.454902, green: 0.454902, blue: 0.501961, alpha: 0.08)
        case .dark:
            return .init(displayP3Red: 0.462745, green: 0.462745, blue: 0.501961, alpha: 0.18)
        }
    }
    
    static var lightText: UIColor {
        return _lightText()
    }
    
    static func _lightText(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(white: 1, alpha: 0.6)
        case .dark:
            return .init(white: 1, alpha: 0.6)
        }
    }
    
    static var darkText: UIColor {
        return _darkText()
    }
    
    static func _darkText(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(white: 0, alpha: 1)
        case .dark:
            return .init(white: 0, alpha: 1)
        }
    }
    
    static var groupTableViewBackground: UIColor {
        return _groupTableViewBackground()
    }
    
    static func _groupTableViewBackground(_ mode: AppearanceMode = .light) -> UIColor {
        switch mode {
        case .light:
            return .init(displayP3Red: 0.94902, green: 0.94902, blue: 0.968627, alpha: 1)
        case .dark:
            return .init(white: 0, alpha: 1)
        }
    }
    
    var pixelImage: UIImage {
        let rect = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
