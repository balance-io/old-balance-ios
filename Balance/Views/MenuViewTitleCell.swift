import PagingKit

// NOTE: This is basically the TitleLabelMenuViewCell class from PagingKit with the small addition
//       of changing the font size when not in focus. I would have LOVED to subclass instead of
//       copy/pasting the whole class, but the framework author didn't mark it "open" (yay Swift 3+...)
public class MenuViewTitleCell: PagingMenuViewCell {
    ///  The text color when selected
    public var focusColor = UIColor(hexString: "#2A2A2A")! {
        didSet {
            if isSelected {
                titleLabel.textColor = focusColor
            }
        }
    }

    /// The normal text color.
    public var normalColor = UIColor(white: 0, alpha: 0.6) {
        didSet {
            if !isSelected {
                titleLabel.textColor = normalColor
            }
        }
    }

    public var focusFont = UIFont.systemFont(ofSize: 17) {
        didSet {
            if isSelected {
                titleLabel.font = focusFont
            }
        }
    }

    public var normalFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            if !isSelected {
                titleLabel.font = normalFont
            }
        }
    }

    public let titleLabel = { () -> UILabel in
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            anchorLabel(from: titleLabel, to: self, attribute: .top),
            anchorLabel(from: titleLabel, to: self, attribute: .leading),
            anchorLabel(from: self, to: titleLabel, attribute: .trailing),
            anchorLabel(from: self, to: titleLabel, attribute: .bottom),
        ])
    }

    public override var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel.textColor = focusColor
                titleLabel.font = focusFont
            } else {
                titleLabel.textColor = normalColor
                titleLabel.font = normalFont
            }
        }
    }

    /// syntax sugar of NSLayoutConstraint for titleLabel (Because this library supports iOS8, it cannnot use NSLayoutAnchor.)
    private func anchorLabel(from fromItem: Any, to toItem: Any, attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint {
        return NSLayoutConstraint(
            item: fromItem,
            attribute: attribute,
            relatedBy: .equal,
            toItem: toItem,
            attribute: attribute,
            multiplier: 1,
            constant: 8
        )
    }
}
