import UIKit

extension UIView {
    func withConstraints(_ with: Bool = true) -> Self {
        translatesAutoresizingMaskIntoConstraints = !with
        return self
    }
}
