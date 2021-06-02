
import UIKit
import SwiftBasicKit

/// 免费礼包
class ZFreePackageViewController: ZZBaseViewController {
 
    var z_coins: Int = 0
    
    private lazy var z_viewmain: UIView = {
        let z_temp = UIView.init(frame: CGRect.main())
        z_temp.alpha = 0.77
        z_temp.backgroundColor = "#000000".color
        return z_temp
    }()
    private lazy var z_viewcontent: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(kScreenWidth/2 - 256.scale/2, -400.scale, 256.scale, 348.scale))
        z_temp.alpha = 0
        z_temp.backgroundColor = "#1E1925".color
        z_temp.border(color: .clear, radius: 15, width: 0)
        return z_temp
    }()
    private lazy var z_btnclose: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_viewcontent.width - 50, 0, 45, 45))
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.btnCloseW.image.withRenderingMode(.alwaysTemplate), for: .normal)
        z_temp.imageView?.tintColor = "#493443".color
        return z_temp
    }()
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, 38.scale, z_viewcontent.width, 25))
        z_temp.textAlignment = .center
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 24
        z_temp.text = ZString.lbFreeTitle.text
        return z_temp
    }()
    private lazy var z_lbdesc: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, z_lbtitle.y + z_lbtitle.height + 12, z_viewcontent.width, 22))
        z_temp.textAlignment = .center
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 15
        z_temp.text = ZString.lbFreeDesc.text
        return z_temp
    }()
    private lazy var z_imagemoney: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(75.scale, 142.scale, 106.scale, 62.scale))
        z_temp.image = Asset.comMoney.image
        return z_temp
    }()
    private lazy var z_lbcoins: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_imagemoney.x, z_imagemoney.y + z_imagemoney.height + 15.scale, 56, 21))
        z_temp.textAlignment = .right
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 24
        z_temp.text = ZString.lbFreeDesc.text
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_imagecoins: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_imagemoney.x + 61.scale, z_imagemoney.y + z_imagemoney.height + 18.scale, 13, 15))
        z_temp.image = Asset.iconDiamond1.image
        return z_temp
    }()
    private lazy var z_btnclaim: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(18.scale, z_viewcontent.height - 70.scale, 220.scale, 50.scale))
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.btnClaim.text, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .normal)
        z_temp.titleLabel?.boldSize = 15
        z_temp.backgroundColor = "#7037E9".color
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        return z_temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showType = 2
        self.view.backgroundColor = .clear
        self.view.addSubview(self.z_viewmain)
        self.view.addSubview(self.z_viewcontent)
        self.view.sendSubviewToBack(self.z_viewmain)
        
        self.z_viewcontent.addSubview(z_btnclose)
        self.z_viewcontent.addSubview(z_btnclaim)
        self.z_viewcontent.addSubview(z_lbtitle)
        self.z_viewcontent.addSubview(z_lbdesc)
        self.z_viewcontent.addSubview(z_lbcoins)
        self.z_viewcontent.addSubview(z_imagemoney)
        self.z_viewcontent.addSubview(z_imagecoins)
        
        z_lbcoins.text = z_coins <= 0 ? "65" : z_coins.str
        z_btnclose.addTarget(self, action: "func_btncloseclick", for: .touchUpInside)
        z_btnclaim.addTarget(self, action: "func_btnclaimclick", for: .touchUpInside)
        self.z_viewmain.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "func_viewmaintapclick:"))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.z_viewmain.alpha = 0.77
            self.z_viewcontent.alpha = 1
            self.z_viewcontent.y = kScreenHeight/2 - self.z_viewcontent.height/2
        })
    }
    @objc private func func_viewmaintapclick(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended: self.func_btncloseclick()
        default: break
        }
    }
    @objc private func func_btncloseclick() {
        UIView.animate(withDuration: 0.25, animations: {
            self.z_viewcontent.alpha = 0
            self.z_viewmain.alpha = 0
        }, completion: { _ in
            ZRouterKit.dismiss(fromVC: self, animated: false, completion: nil)
        })
    }
    @objc private func func_btnclaimclick() {
        ZProgressHUD.show(vc: self)
        var param = [String: Any]()
        param["activity_name"] = "new_user_draw_token"
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiactivityapply.api, param), responseBlock: { [weak self] result in
            ZProgressHUD.dismiss()
            guard let `self` = self else { return }
            if result.success {
                UIView.animate(withDuration: 0.25, animations: {
                    self.z_viewcontent.alpha = 0
                    self.z_viewmain.alpha = 0
                }, completion: { _ in
                    ZRouterKit.dismiss(fromVC: self, animated: false, completion: nil)
                })
            } else {
                ZProgressHUD.showMessage(vc: self, text: result.message)
            }
        })
    }
}
