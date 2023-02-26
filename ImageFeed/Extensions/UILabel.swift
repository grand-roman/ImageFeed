import UIKit

extension UILabel {
    convenience init(text: String? = nil,
                     textColor: UIColor = .ypWhite,
                     font: UIFont = .ysRegular(13),
                     withConstraints: Bool = true) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        translatesAutoresizingMaskIntoConstraints = !withConstraints
    }
}
