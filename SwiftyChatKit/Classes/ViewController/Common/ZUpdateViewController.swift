
import UIKit
import SwiftBasicKit

/// update app
class ZUpdateViewController: ZZBaseViewController {
    
    var z_model: ZModelUpdate?
    
    private lazy var z_viewmain: UIView = {
        let z_temp = UIView.init(frame: CGRect.main())
        z_temp.alpha = 0
        z_temp.backgroundColor = "#000000".color
        return z_temp
    }()
    private lazy var z_viewcontent: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(kScreenWidth/2 - 256.scale/2, kScreenHeight/2 - 348.scale/2, 256.scale, 348.scale))
        z_temp.alpha = 0
        z_temp.image = Asset.comDownloadBG.image
        z_temp.border(color: .clear, radius: 15, width: 0)
        z_temp.isUserInteractionEnabled = true
        return z_temp
    }()
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(16.scale, 75.scale, 225.scale, 50.scale))
        z_temp.text = ZString.lbDownloadTips.text
        z_temp.boldSize = 18
        z_temp.textColor = "#FFFFFF".color
        z_temp.textAlignment = .center
        z_temp.numberOfLines = 0
        return z_temp
    }()
    private lazy var z_lbdesc: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(35.scale, z_btndownload.y + z_btndownload.height + 14.scale, 190.scale, 40.scale))
        z_temp.boldSize = 15
        z_temp.textColor = "#4E4E55".color
        z_temp.textAlignment = .center
        z_temp.numberOfLines = 0
        return z_temp
    }()
    private lazy var z_btndownload: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(18.scale, z_viewcontent.height - 65.scale - 50.scale, 220.scale, 50.scale))
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.btnDownload.text, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .normal)
        z_temp.titleLabel?.boldSize = 15
        z_temp.backgroundColor = "#7037E9".color
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        return z_temp
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showType = 2
        self.view.addSubview(self.z_viewmain)
        self.view.addSubview(self.z_viewcontent)
        self.view.sendSubviewToBack(self.z_viewmain)
        self.z_viewcontent.addSubview(z_lbtitle)
        self.z_viewcontent.addSubview(z_lbdesc)
        self.z_viewcontent.addSubview(z_btndownload)
        if let user = self.z_model {
            self.z_lbdesc.text = user.title
        }
        self.z_btndownload.addTarget(self, action: "func_btndownloadclick", for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.z_viewmain.alpha == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.z_viewmain.alpha = 0.77
                self.z_viewcontent.alpha = 1
            })
        }
    }
    @objc private func func_btndownloadclick() {
        if let user = self.z_model {
            URL.openURL(user.link)
        }
        abort()
    }
}
