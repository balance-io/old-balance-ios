import UIKit

class ExpandableTableViewCell: UITableViewCell {
    struct Notifications {
        static let expanded = Notification.Name(rawValue: "ExpandableTableViewCell.expanded")
        static let collapsed = Notification.Name(rawValue: "ExpandableTableViewCell.collapsed")
        
        struct Keys {
            static let indexPath = "indexPath"
            static let reuseIdentifier = "reuseIdentifier"
        }
    }
    
    var isExpandable = true
    
    var indexPath: IndexPath
    var isExpanded: Bool
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, isExpanded: Bool, indexPath: IndexPath) {
        self.isExpanded = isExpanded
        self.indexPath = indexPath
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("undefined")
    }
    
    func calculatedHeight() -> CGFloat {
        fatalError("you must subclass calculatedHeight()")
    }
    
    @objc func tapAction() {
        guard isExpandable else {
            return
        }
        
        let userInfo: [String: Any] = [Notifications.Keys.indexPath: indexPath,
                                       Notifications.Keys.reuseIdentifier: reuseIdentifier ?? ""]
        
        if isExpanded {
            isExpanded = false
            NotificationCenter.default.post(name: Notifications.collapsed, object: nil, userInfo: userInfo)
        } else {
            isExpanded = true
            NotificationCenter.default.post(name: Notifications.expanded, object: nil, userInfo: userInfo)
        }
    }
}
