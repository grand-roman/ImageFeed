import UIKit

extension UIFont {
    static func ysRegular(_ size: CGFloat) -> UIFont {
        UIFont(name: "YandexSansDisplay-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func ysBold(_ size: CGFloat) -> UIFont {
        UIFont(name: "YandexSansDisplay-Bold", size: size) ?? .boldSystemFont(ofSize: size)
    }
}
