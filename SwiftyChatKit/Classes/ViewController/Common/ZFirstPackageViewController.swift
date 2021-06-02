
import UIKit
import SwiftBasicKit

/// 首次礼包
class ZFirstPackageViewController: ZZBaseViewController {

    var z_modelr: ZModelRecharge?
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
    private lazy var z_imagediscount: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(0, 18.scale, 118.scale, 28.scale))
        z_temp.image = Asset.comTag.image
        return z_temp
    }()
    private lazy var z_lbdiscount: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(8.scale, 3.scale, z_imagediscount.width - 10.scale, 22.scale))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 14
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_imagemoney: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(40.scale, 106.scale, 170.scale, 139.scale))
        z_temp.image = Asset.comTreasureChest.image
        return z_temp
    }()
    private lazy var z_lboldmoney: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(180.scale, 225.scale, 58.scale, 20))
        z_temp.textAlignment = .right
        z_temp.textColor = "#493443".color
        z_temp.boldSize = 12
        z_temp.text = "$2.99"
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_lbmoney: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(181.scale, 247.scale, 58.scale, 20))
        z_temp.textAlignment = .center
        z_temp.textColor = "#C12070".color
        z_temp.boldSize = 12
        z_temp.text = "$0.99"
        z_temp.backgroundColor = "#FFFFFF".color
        z_temp.border(color: .clear, radius: 5, width: 0)
        return z_temp
    }()
    private lazy var z_lbcoins: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, 80.scale, 130.scale, 24))
        z_temp.textAlignment = .right
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 24
        z_temp.text = "400"
        return z_temp
    }()
    private lazy var z_imagecoins: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(135.scale, 85.scale, 13, 15))
        z_temp.image = Asset.iconDiamond1.image
        return z_temp
    }()
    private lazy var z_btncontinue: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(18.scale, z_viewcontent.height - 70.scale, 220.scale, 50.scale))
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.btnContinue.text, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .normal)
        z_temp.titleLabel?.boldSize = 15
        z_temp.backgroundColor = "#7037E9".color
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        return z_temp
    }()
    private let viewmodel: ZRechargeViewModel = ZRechargeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showType = 2
        self.viewmodel.delegate = self
        self.view.backgroundColor = .clear
        self.view.addSubview(self.z_viewmain)
        self.view.addSubview(self.z_viewcontent)
        self.view.sendSubviewToBack(self.z_viewmain)
        
        self.z_viewcontent.addSubview(z_btnclose)
        self.z_viewcontent.addSubview(z_btncontinue)
        self.z_viewcontent.addSubview(z_imagediscount)
        self.z_imagediscount.addSubview(z_lbdiscount)
        self.z_viewcontent.addSubview(z_lbmoney)
        self.z_viewcontent.addSubview(z_lbcoins)
        self.z_viewcontent.addSubview(z_lboldmoney)
        self.z_viewcontent.addSubview(z_imagemoney)
        self.z_viewcontent.addSubview(z_imagecoins)
        
        if let model = self.z_modelr {
            self.z_lbcoins.text = model.token_amount.str
            self.z_lbmoney.text = "$" + model.price.strDouble
            let discount = ((model.original_price-model.price)/model.original_price*100).str
            self.z_lbdiscount.text = discount + "% " + ZString.lbFirstDiscount.text
            let text = "$" + model.original_price.strDouble
            self.z_lboldmoney.text = text
            let attr = NSMutableAttributedString.init(string: text)
            attr.addAttributes([NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                    NSAttributedString.Key.strikethroughColor: "#493443".color], range: NSRange.init(location: 0, length: text.count))
            self.z_lboldmoney.attributedText = attr
        }
        z_btnclose.addTarget(self, action: "func_btncloseclick", for: .touchUpInside)
        z_btncontinue.addTarget(self, action: "func_btncontinueclick", for: .touchUpInside)
        self.z_viewmain.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "func_viewmaintapclick:"))
        NotificationCenter.default.addObserver(self, selector: "func_PayRechargeSuccess:", name: NSNotification.Name.init(rawValue: "PayRechargeSuccess"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.z_viewmain.alpha = 0.77
            self.z_viewcontent.alpha = 1
            self.z_viewcontent.y = kScreenHeight/2 - self.z_viewcontent.height/2
        })
    }
    deinit {
        self.viewmodel.delegate = nil
    }
    override func func_PayRechargeSuccess(_ sender: Notification) {
        
        self.func_btncloseclick()
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
    @objc private func func_btncontinueclick() {
        guard let model = self.z_modelr else { return }
        switch model.gid {
        case .apa:
            self.viewmodel.func_requestapplerecharge(model: model)
        case .ppa:
            self.viewmodel.func_requestpparecharge(model: model)
        default: break
        }
    }
}
extension ZFirstPackageViewController: ZRechargeViewModelDeletegate {
    func func_requestsupportsuccess(model: ZModelUserInfo?) {
        
    }
    func func_requestppasuccess(dic: [String : Any]) {
        NotificationCenter.default.post(name: Notification.Names.ShowRechargeVC, object: dic)
    }
    func func_reloadarrayfaild() {
        
    }
    func func_reloadarraysuccess(models: [ZModelPurchase]?) {
        
    }
}
