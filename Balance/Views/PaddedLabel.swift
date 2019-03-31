import UIKit

class PaddedLabel: UILabel {
    public var padding: UIEdgeInsets?

    open override func draw(_ rect: CGRect) {
        if let insets = padding {
            drawText(in: rect.inset(by: insets))
        } else {
            drawText(in: rect)
        }
    }

    open override var intrinsicContentSize: CGSize {
        guard let text = self.text else {
            return super.intrinsicContentSize
        }

        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        var insetsWidth: CGFloat = 0.0

        if let insets = padding {
            insetsWidth += insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
            textWidth -= insetsWidth
        }

        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSAttributedString.Key.font: self.font], context: nil)

        contentSize.height = ceil(newSize.size.height) + insetsHeight
        contentSize.width = ceil(newSize.size.width) + insetsWidth

        return contentSize
    }
}
