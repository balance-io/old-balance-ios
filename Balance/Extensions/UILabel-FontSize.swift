import UIKit

extension UILabel {
    var fontSize: CGFloat {
        get {
            return self.font.pointSize
        }
        set {
            if let font = UIFont(name: self.font.fontName, size: newValue) {
                self.font = font
                self.sizeToFit()
            }
        }
    }
}
