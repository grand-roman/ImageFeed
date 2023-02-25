import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var windows: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        windows?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        windows?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}

