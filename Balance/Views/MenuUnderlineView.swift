import UIKit
import SnapKit

class MenuUnderlineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(hexString: "#007AFF")
        lineView.layer.cornerRadius = 4
        addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(8)
            make.top.equalTo(self.snp.bottom).offset(-4)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("unimplemented")
    }
}
