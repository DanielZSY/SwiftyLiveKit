
import UIKit
import SwiftBasicKit

class ZRechargeAlertViewController: ZZBaseViewController {
    
    private let kCellSpaceId = "kCellSpaceId"
    private var z_arrayType: [ZModelPurchase] = [ZModelPurchase]()
    private var z_apayModel: ZModelPurchase?
    private var z_ppayModel: ZModelPurchase?
    private lazy var z_viewbg: UIView = {
        let z_temp = UIView.init(frame: CGRect.main())
        z_temp.backgroundColor = "#000000".color.withAlphaComponent(0.3)
        return z_temp
    }()
    private lazy var z_viewinsufficientbalance: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(15.scale, z_viewcontent.y - 50.scale, 345.scale, 35.scale))
        z_temp.isUserInteractionEnabled = false
        z_temp.backgroundColor = "#000000".color.withAlphaComponent(0.5)
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        return z_temp
    }()
    private lazy var z_lbinsufficientbalance: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, 0, z_viewinsufficientbalance.width, z_viewinsufficientbalance.height))
        z_temp.boldSize = 14
        z_temp.textColor = "#E9E9E9".color
        z_temp.text = ZString.lbInsufficientBalance.text
        z_temp.textAlignment = .center
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_viewcontent: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(0, kScreenHeight, kScreenWidth, 225.scale))
        z_temp.alpha = 0
        z_temp.backgroundColor = "#1E1925".color
        z_temp.border(color: .clear, radius: 10.scale, width: 0)
        return z_temp
    }()
    private lazy var z_imagecoins: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(15.scale, 18.scale, 20.scale, 23.scale))
        z_temp.image = Asset.iconDiamond2.image
        return z_temp
    }()
    private lazy var z_lbcoins: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(43.scale, 15.scale, 200.scale, 29.scale))
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 15
        return z_temp
    }()
    private lazy var z_btnclose: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_viewcontent.width - 50.scale, 0, 50.scale, 50.scale))
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.btnCloseW.image, for: .normal)
        z_temp.imageEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        return z_temp
    }()
    private lazy var z_viewtype: ZRechargeTypeView = {
        let z_temp = ZRechargeTypeView.init(frame: CGRect.init(0, 50.scale, kScreenWidth, 85.scale))
        z_temp.isHidden = true
        return z_temp
    }()
    private lazy var z_viewapay: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: 115.scale, height: 160.scale)
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.scrollDirection = .horizontal
        
        let z_temp = ZBaseCV.init(frame: CGRect.init(0, z_viewcontent.height - 170.scale, z_viewcontent.width, 170.scale), collectionViewLayout: z_templayout)
        z_temp.tag = 1
        z_temp.isHidden = true
        z_temp.backgroundColor = .clear
        z_temp.showsVerticalScrollIndicator = false
        z_temp.showsHorizontalScrollIndicator = false
        z_temp.register(ZRechargeItemCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        return z_temp
    }()
    private lazy var z_viewppay: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: 115.scale, height: 160.scale)
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.scrollDirection = .horizontal
        
        let z_temp = ZBaseCV.init(frame: CGRect.init(0, z_viewcontent.height - 170.scale, z_viewcontent.width, 170.scale), collectionViewLayout: z_templayout)
        z_temp.tag = 2
        z_temp.isHidden = false
        z_temp.backgroundColor = .clear
        z_temp.showsVerticalScrollIndicator = false
        z_temp.showsHorizontalScrollIndicator = false
        z_temp.register(ZRechargeItemCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        return z_temp
    }()
    private lazy var z_aiview: UIActivityIndicatorView = {
        let z_temp = UIActivityIndicatorView.init(style: .white)
        z_temp.frame = CGRect.init(kScreenWidth/2 - 15, kScreenHeight/2 - 15, 30, 30)
        return z_temp
    }()
    private let z_viewmodel: ZRechargeViewModel = ZRechargeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.view.backgroundColor = .clear
        self.view.addSubview(z_viewbg)
        z_viewbg.addSubview(z_aiview)
        self.view.addSubview(z_viewinsufficientbalance)
        self.view.addSubview(z_viewcontent)
        self.view.sendSubviewToBack(z_viewbg)
        
        z_viewinsufficientbalance.addSubview(z_lbinsufficientbalance)
        
        z_viewcontent.addSubview(z_imagecoins)
        z_viewcontent.addSubview(z_lbcoins)
        z_viewcontent.addSubview(z_btnclose)
        z_viewcontent.addSubview(z_viewtype)
        z_viewcontent.addSubview(z_viewapay)
        z_viewcontent.addSubview(z_viewppay)
        
        z_lbcoins.text = ZSettingKit.shared.balance.str
        
        z_viewmodel.delegate = self
        z_viewapay.delegate = self
        z_viewapay.dataSource = self
        z_viewppay.delegate = self
        z_viewppay.dataSource = self
        
        z_viewmodel.func_checkrechargefaild()
        
        z_aiview.startAnimating()
        z_btnclose.addTarget(self, action: "func_btncloseclick", for: .touchUpInside)
        z_viewbg.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "func_viewbgtap:"))
        z_viewtype.z_onbuttontypeclick = { row in
            switch row {
            case 1:
                self.z_viewapay.isHidden = false
                self.z_viewppay.isHidden = true
            case 2:
                self.z_viewapay.isHidden = true
                self.z_viewppay.isHidden = false
            default: break
            }
        }
        NotificationCenter.default.addObserver(self, selector: "func_UserBalanceChange:", name: Notification.Names.UserBalanceChange, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        z_viewmodel.func_reloadrechargelocal()
    }
    deinit {
        z_viewmodel.delegate = nil
        z_viewapay.delegate = nil
        z_viewapay.dataSource = nil
        z_viewppay.delegate = nil
        z_viewppay.dataSource = nil
        NotificationCenter.default.removeObserver(self, name: Notification.Names.UserBalanceChange, object: nil)
    }
    @objc override func func_UserBalanceChange(_ sender: Notification) {
        z_lbcoins.text = ZSettingKit.shared.balance.str
        if self.isCurrentShowVC {
            self.func_btncloseclick()
        }
    }
    @objc private func func_viewbgtap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended: self.func_btncloseclick()
        default: break
        }
    }
    @objc private func func_btncloseclick() {
        z_btnclose.isEnabled = false
        UIView.animate(withDuration: 0.25, animations: {
            self.z_viewinsufficientbalance.alpha = 0
            self.z_viewbg.alpha = 0
            self.z_viewcontent.alpha = 0
            self.z_viewcontent.y = kScreenHeight
        }, completion: { _ in
            ZRouterKit.dismiss(fromVC: self, animated: false, completion: nil)
        })
    }
    private final func func_showviewrecharge() {
        if self.z_arrayType.count > 1 {
            self.z_viewtype.isHidden = false
            self.z_viewcontent.height = 305.scale
            
            self.z_apayModel = self.z_arrayType.first
            self.z_ppayModel = self.z_arrayType.last
        } else {
            self.z_viewtype.isHidden = true
            self.z_viewcontent.height = 225.scale
            
            self.z_apayModel = self.z_arrayType.first
            self.z_ppayModel = self.z_arrayType.first
        }
        self.z_viewinsufficientbalance.alpha = 0
        self.z_viewinsufficientbalance.y = kScreenHeight - self.z_viewcontent.height - self.z_viewinsufficientbalance.height - 15.scale
        self.z_viewtype.z_arrayType = self.z_arrayType
        self.z_viewapay.y = self.z_viewcontent.height - self.z_viewapay.height
        self.z_viewapay.reloadData()
        self.z_viewppay.y = self.z_viewcontent.height - self.z_viewppay.height
        self.z_viewppay.reloadData()
        UIView.animate(withDuration: 0.25, animations: {
            self.z_viewinsufficientbalance.alpha = 1
            self.z_viewcontent.alpha = 1
            self.z_viewcontent.y = kScreenHeight - self.z_viewcontent.height
        })
    }
}
extension ZRechargeAlertViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 2: return self.z_ppayModel?.items?.count ?? 0
        default: break
        }
        return self.z_apayModel?.items?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! ZRechargeItemCVC
        cell.tag = indexPath.row
        switch collectionView.tag {
        case 1:
            cell.z_modelPurchase = self.z_apayModel
            if let model = self.z_apayModel?.items?[indexPath.row] {
                cell.z_modelRecharge = ZModelRecharge.init(instance: model)
            }
        case 2:
            cell.z_modelPurchase = self.z_ppayModel
            if let model = self.z_ppayModel?.items?[indexPath.row] {
                cell.z_modelRecharge = ZModelRecharge.init(instance: model)
            }
        default: break
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 1:
            if let model = self.z_apayModel?.items?[indexPath.row], let gid = self.z_apayModel?.gid {
                switch gid {
                case .apa:
                    self.z_viewmodel.func_requestapplerecharge(model: model)
                case .ppa:
                    self.z_viewmodel.func_requestpparecharge(model: model)
                default: break
                }
            }
        case 2:
            if let model = self.z_ppayModel?.items?[indexPath.row], let gid = self.z_ppayModel?.gid {
                switch gid {
                case .apa:
                    self.z_viewmodel.func_requestapplerecharge(model: model)
                case .ppa:
                    self.z_viewmodel.func_requestpparecharge(model: model)
                default: break
                }
            }
        default: break
        }
    }
}
extension ZRechargeAlertViewController: ZRechargeViewModelDeletegate {
    func func_requestsupportsuccess(model: ZModelUserInfo?) {
        
    }
    func func_requestppasuccess(dic: [String: Any]) {
        NotificationCenter.default.post(name: Notification.Names.ShowRechargeVC, object: dic)
    }
    func func_reloadarrayfaild() {
        z_viewmodel.func_reloadrechargearray()
    }
    func func_reloadarraysuccess(models: [ZModelPurchase]?) {
        self.z_aiview.stopAnimating()
        self.z_arrayType.removeAll()
        if let array = models {
            self.z_arrayType.append(contentsOf: array)
        }
        self.func_showviewrecharge()
    }
}
