
import UIKit
import HandyJSON
import SwiftBasicKit

class ZRechargeViewController: ZZBaseViewController {
    
    private var z_currentPage: Int = 0
    private var z_modelsupport: ZModelUserInfo?
    private var z_apayModel: ZModelPurchase?
    private var z_ppayModel: ZModelPurchase?
    private var z_arrayType: [ZModelPurchase] = [ZModelPurchase]()
    private lazy var z_lbcoins: ZBalanceButton = {
        let z_temp = ZBalanceButton.init(frame: CGRect.init(kScreenWidth - 100, kStatusHeight + 8, 90, 23))
        return z_temp
    }()
    private lazy var z_viewtype: ZRechargeTypeView = {
        let z_temp = ZRechargeTypeView.init(frame: CGRect.init(0, kTopNavHeight, kScreenWidth, 85.scale))
        z_temp.isHidden = true
        return z_temp
    }()
    private lazy var z_viewmain: ZBaseSV = {
        let z_temp = ZBaseSV.init(frame: CGRect.init(0, kTopNavHeight + 10, kScreenWidth, kScreenHeight - kTopNavHeight - 60))
        z_temp.tag = 10
        z_temp.bounces = false
        z_temp.scrollsToTop = false
        z_temp.isScrollEnabled = false
        z_temp.isPagingEnabled = true
        z_temp.backgroundColor = .clear
        z_temp.showsVerticalScrollIndicator = false
        z_temp.showsHorizontalScrollIndicator = false
        z_temp.contentSize = CGSize.init(width: z_temp.width*2, height: z_temp.height)
        z_temp.contentOffset = CGPoint.init(x: z_temp.width, y: 0)
        return z_temp
    }()
    private lazy var z_viewapay: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: z_viewmain.width, height: 85.scale)
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.scrollDirection = .vertical
        z_templayout.sectionHeadersPinToVisibleBounds = false
        z_templayout.sectionFootersPinToVisibleBounds = false
        
        let z_temp = ZBaseCV.init(frame: CGRect.init(0, 0, z_viewmain.width, z_viewmain.height), collectionViewLayout: z_templayout)
        z_temp.tag = 1
        z_temp.scrollsToTop = true
        z_temp.alwaysBounceVertical = true
        z_temp.backgroundColor = .clear
        z_temp.register(ZRechargeItemHCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        return z_temp
    }()
    private lazy var z_viewppay: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: z_viewmain.width, height: 85.scale)
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.scrollDirection = .vertical
        z_templayout.sectionHeadersPinToVisibleBounds = false
        z_templayout.sectionFootersPinToVisibleBounds = false
        
        let z_temp = ZBaseCV.init(frame: CGRect.init(z_viewmain.width, 0, z_viewmain.width, z_viewmain.height), collectionViewLayout: z_templayout)
        z_temp.tag = 2
        z_temp.scrollsToTop = true
        z_temp.alwaysBounceVertical = true
        z_temp.backgroundColor = .clear
        z_temp.register(ZRechargeItemHCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        return z_temp
    }()
    private lazy var z_btnnotreceived: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(30.scale, kScreenHeight - 55, kScreenWidth - 60.scale, 50))
        z_temp.titleLabel?.boldSize = 12
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        let text = ZString.lbDiamondsnotreceived.text
        let atttext = NSMutableAttributedString.init(string: text)
        atttext.addAttributes([NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                               NSAttributedString.Key.underlineColor: "#E9E9E9".color,
                               NSAttributedString.Key.foregroundColor: "#E9E9E9".color],
                              range: NSRange.init(location: 0, length: text.count))
        z_temp.setAttributedTitle(atttext, for: .normal)
        return z_temp
    }()
    private let z_viewmodel: ZRechargeViewModel = ZRechargeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.isNavigationAlpha = 0
        self.title = ZString.lbStore.text
        
        self.view.addSubview(z_lbcoins)
        self.view.addSubview(z_viewtype)
        self.view.addSubview(z_viewmain)
        self.view.addSubview(z_btnnotreceived)
        
        z_viewmain.addSubview(z_viewapay)
        z_viewmain.addSubview(z_viewppay)
        
        z_viewmain.delegate = self
        z_viewapay.delegate = self
        z_viewapay.dataSource = self
        z_viewppay.delegate = self
        z_viewppay.dataSource = self
        z_viewmodel.delegate = self
        
        z_viewmain.onRefreshHeader = {
            self.z_viewmodel.func_reloadrechargearray()
        }
        z_viewtype.z_onbuttontypeclick = { row in
            switch row {
            case 1:
                self.z_viewmain.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
            case 2:
                self.z_viewmain.setContentOffset(CGPoint.init(x: self.z_viewmain.width, y: 0), animated: false)
            default: break
            }
        }
        z_btnnotreceived.addTarget(self, action: "func_btnnotreceivedclick", for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: "func_UserBalanceChange:", name: Notification.Names.UserBalanceChange, object: nil)
        
        z_viewmodel.func_reloadrechargelocal()
        z_viewmodel.func_requestsupport()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.func_setupdata()
    }
    deinit {
        z_viewmain.delegate = nil
        z_viewapay.delegate = nil
        z_viewapay.dataSource = nil
        z_viewppay.delegate = nil
        z_viewppay.dataSource = nil
        z_viewmodel.delegate = nil
        NotificationCenter.default.removeObserver(self, name: Notification.Names.UserBalanceChange, object: nil)
    }
    @objc private func func_btnnotreceivedclick() {
        guard let model = self.z_modelsupport else {
            self.z_viewmodel.func_requestsupport()
            return
        }
        NotificationCenter.default.post(name: Notification.Names.ShowChatMessageVC, object: model)
    }
    override func func_UserBalanceChange(_ sender: Notification) {
        self.func_setupdata()
    }
    private func func_setupdata() {
        z_lbcoins.text = ZSettingKit.shared.balance.str
    }
    private final func func_showviewrecharge() {
        if self.z_arrayType.count > 1 {
            self.z_viewtype.z_arrayType = self.z_arrayType
            self.z_viewtype.isHidden = false
            self.z_apayModel = self.z_arrayType.first
            self.z_ppayModel = self.z_arrayType.last
            let z_viewmainy = z_viewtype.y + z_viewtype.height + 5
            self.z_viewmain.frame = CGRect.init(0, z_viewmainy, z_viewmain.width, kScreenHeight - z_btnnotreceived.height - z_viewmainy)
        } else {
            self.z_viewtype.isHidden = true
            self.z_apayModel = self.z_arrayType.first
            self.z_ppayModel = self.z_arrayType.first
            let z_viewmainy = z_viewtype.y
            self.z_viewmain.frame = CGRect.init(0, z_viewmainy, z_viewmain.width, kScreenHeight - z_btnnotreceived.height - z_viewmainy)
        }
        self.z_viewapay.height = self.z_viewmain.height
        self.z_viewppay.height = self.z_viewmain.height
        self.z_viewapay.reloadData()
        self.z_viewppay.reloadData()
    }
    private final func func_itemchange() {
        if z_viewtype.z_currentPage == self.z_currentPage { return }
        z_viewtype.z_currentPage = self.z_currentPage
        switch self.z_currentPage {
        case 1:
            self.z_viewapay.scrollsToTop = true
            self.z_viewppay.scrollsToTop = false
        case 2:
            self.z_viewapay.scrollsToTop = false
            self.z_viewppay.scrollsToTop = true
        default: break
        }
    }
}
extension ZRechargeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 2:
            return self.z_ppayModel?.items?.count ?? 0
        default: break
        }
        return self.z_apayModel?.items?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! ZRechargeItemHCVC
        cell.tag = indexPath.row
        switch collectionView.tag {
        case 2:
            cell.z_modelPurchase = self.z_ppayModel
            if let model = self.z_ppayModel?.items?[indexPath.row] {
                cell.z_modelRecharge = ZModelRecharge.init(instance: model)
            }
        case 1:
            cell.z_modelPurchase = self.z_apayModel
            if let model = self.z_apayModel?.items?[indexPath.row] {
                cell.z_modelRecharge = ZModelRecharge.init(instance: model)
            }
        default: break
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 2:
            if let model = self.z_ppayModel {
                switch model.gid {
                case .apa:
                    if let item = model.items?[indexPath.row] {
                        self.z_viewmodel.func_requestapplerecharge(model: item)
                    }
                case .ppa:
                    if let item = model.items?[indexPath.row] {
                        self.z_viewmodel.func_requestpparecharge(model: item)
                    }
                default: break
                }
            }
        case 1:
            if let model = self.z_apayModel {
                switch model.gid {
                case .apa:
                    if let item = model.items?[indexPath.row] {
                        self.z_viewmodel.func_requestapplerecharge(model: item)
                    }
                case .ppa:
                    if let item = model.items?[indexPath.row] {
                        self.z_viewmodel.func_requestpparecharge(model: item)
                    }
                default: break
                }
            }
        default: break
        }
    }
}
extension ZRechargeViewController: ZRechargeViewModelDeletegate {
    func func_requestsupportsuccess(model: ZModelUserInfo?) {
        self.z_modelsupport = model
    }
    func func_requestppasuccess(dic: [String: Any]) {
        NotificationCenter.default.post(name: Notification.Names.ShowRechargeVC, object: dic)
    }
    func func_reloadarrayfaild() {
        z_viewmodel.func_reloadrechargearray()
    }
    func func_reloadarraysuccess(models: [ZModelPurchase]?) {
        self.z_arrayType.removeAll()
        if let array = models {
            self.z_arrayType.append(contentsOf: array)
        }
        self.func_showviewrecharge()
    }
}
extension ZRechargeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 10 {
            self.z_currentPage = Int(floor(scrollView.contentOffset.x/(scrollView.frame.size.width/3*2))) + 1
            self.func_itemchange()
        }
    }
}
