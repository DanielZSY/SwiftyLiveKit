
import UIKit
import SwiftBasicKit

class ZUserFollowNodataView: UIView {

    var z_datacount: Int = 0 {
        didSet {
            z_viewai.stopAnimating()
            z_viewcontent.isHidden = z_datacount > 0
        }
    }
    var z_onbuttonclick: (() -> Void)?
    private lazy var z_viewai: UIActivityIndicatorView = {
        let z_temp = UIActivityIndicatorView.init(style: .white)
        z_temp.frame = CGRect.init(origin: self.center, size: CGSize.init(width: 30, height: 30))
        return z_temp
    }()
    private lazy var z_viewcontent: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(0, 0, self.width, self.height))
        z_temp.isHidden = true
        return z_temp
    }()
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, 120, self.width, 25))
        z_temp.textAlignment = .center
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 18
        z_temp.text = ZString.lbNoFollow.text
        return z_temp
    }()
    private lazy var z_lbdesc: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(self.width/2 - 240.scale/2, z_lbtitle.y + z_lbtitle.height + 40, 240.scale, 60))
        z_temp.textAlignment = .center
        z_temp.textColor = "#56565C".color
        z_temp.boldSize = 18
        z_temp.numberOfLines = 0
        z_temp.text = ZString.lbNoFollowDesc.text
        return z_temp
    }()
    private lazy var z_btncontinue: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(self.width/2 - 320.scale/2, z_lbdesc.y + z_lbdesc.height + 70, 320.scale, 50.scale))
        z_temp.backgroundColor = "#7037E9".color
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.titleLabel?.boldSize = 15
        z_temp.setTitle(ZString.btnContinue.text, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .normal)
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_viewcontent)
        self.addSubview(z_viewai)
        
        z_viewcontent.addSubview(z_lbtitle)
        z_viewcontent.addSubview(z_lbdesc)
        z_viewcontent.addSubview(z_btncontinue)
        
        z_btncontinue.addTarget(self, action: "func_btncontinueclick", for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    @objc private func func_btncontinueclick() {
        self.z_onbuttonclick?()
    }
    final func startAnimating() {
        self.z_viewai.startAnimating()
    }
}
