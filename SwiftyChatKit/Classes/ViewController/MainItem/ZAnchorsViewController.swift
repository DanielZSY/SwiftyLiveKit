
import UIKit
import BFKit
import SwiftBasicKit

class ZAnchorsViewController: ZZBaseViewController {
    
    private var lastemail: String? = ZSettingKit.shared.user?.email
    private var z_arrayhot: [ZModelUserInfo] = [ZModelUserInfo]()
    private var z_arraynew: [ZModelUserInfo] = [ZModelUserInfo]()
    private var z_currentpage: Int = 0
    private lazy var z_btnhot: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(10.scale, kStatusHeight, 81, 45))
        z_temp.isSelected = true
        z_temp.isHighlighted = false
        z_temp.titleLabel?.boldSize = 30
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.btnHot.text, for: .normal)
        z_temp.setTitle(ZString.btnHot.text, for: .selected)
        z_temp.setTitleColor("#493443".color, for: .normal)
        z_temp.setTitleColor("#E9E9E9".color, for: .selected)
        return z_temp
    }()
    private lazy var z_btnnew: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_btnhot.x + z_btnhot.width, kStatusHeight, 81, 45))
        z_temp.isSelected = false
        z_temp.isHighlighted = false
        z_temp.titleLabel?.boldSize = 30
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.btnNew.text, for: .normal)
        z_temp.setTitle(ZString.btnNew.text, for: .selected)
        z_temp.setTitleColor("#493443".color, for: .normal)
        z_temp.setTitleColor("#E9E9E9".color, for: .selected)
        return z_temp
    }()
    private lazy var z_btnrank: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(kScreenWidth - 55, kStatusHeight, 55, 45))
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.btnRank.image, for: .normal)
        return z_temp
    }()
    private lazy var z_viewmain: ZBaseSV = {
        let z_tempy = z_btnhot.y + z_btnhot.height
        let z_temp = ZBaseSV.init(frame: CGRect.init(0, z_tempy, kScreenWidth, kScreenHeight - kTabbarHeight - z_tempy))
        z_temp.tag = 10
        z_temp.backgroundColor = .clear
        z_temp.isPagingEnabled = true
        z_temp.scrollsToTop = false
        z_temp.showsVerticalScrollIndicator = false
        z_temp.showsHorizontalScrollIndicator = false
        z_temp.contentSize = CGSize.init(width: kScreenWidth*2, height: z_temp.height)
        return z_temp
    }()
    private lazy var z_viewhot: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: kScreenWidth/2, height: 262.scale)
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.scrollDirection = .vertical
        z_templayout.sectionHeadersPinToVisibleBounds = false
        z_templayout.sectionFootersPinToVisibleBounds = false
        
        let z_temp = ZBaseCV.init(frame: z_viewmain.bounds, collectionViewLayout: z_templayout)
        z_temp.tag = 1
        z_temp.scrollsToTop = true
        z_temp.backgroundColor = .clear
        z_temp.alwaysBounceVertical = true
        z_temp.showsVerticalScrollIndicator = true
        z_temp.showsHorizontalScrollIndicator = false
        z_temp.addNoDataView()
        z_temp.addRefreshHeader()
        z_temp.addRefreshFooter()
        z_temp.register(ZAnchorsItemCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        z_temp.register(ZAnchorsItemHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellHeaderId)
        z_temp.register(ZAnchorsItemSpaceView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellFooterId)
        return z_temp
    }()
    private lazy var z_viewnew: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: kScreenWidth/2, height: 262.scale)
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.scrollDirection = .vertical
        z_templayout.sectionHeadersPinToVisibleBounds = false
        z_templayout.sectionFootersPinToVisibleBounds = false
        
        let z_temp = ZBaseCV.init(frame: CGRect.init(z_viewmain.width, 0, z_viewmain.width, z_viewmain.height), collectionViewLayout: z_templayout)
        z_temp.tag = 2
        z_temp.scrollsToTop = false
        z_temp.backgroundColor = .clear
        z_temp.alwaysBounceVertical = true
        z_temp.showsVerticalScrollIndicator = true
        z_temp.showsHorizontalScrollIndicator = false
        z_temp.addNoDataView()
        z_temp.addRefreshHeader()
        z_temp.addRefreshFooter()
        z_temp.register(ZAnchorsItemCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        z_temp.register(ZAnchorsItemHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellHeaderId)
        z_temp.register(ZAnchorsItemSpaceView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellFooterId)
        return z_temp
    }()
    private let z_viewmodel: ZAnchorsViewModel = ZAnchorsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.isNavigationHidden = true
        self.view.addSubview(z_btnhot)
        self.view.addSubview(z_btnnew)
        self.view.addSubview(z_btnrank)
        self.view.addSubview(z_viewmain)
        z_viewmain.addSubview(z_viewhot)
        z_viewmain.addSubview(z_viewnew)
        
        self.view.addSubview(z_btnfirst)
        self.view.bringSubviewToFront(z_btnfirst)
        
        func_setupevent()
        
        z_viewmodel.delegate = self
        z_viewhot.delegate = self
        z_viewhot.dataSource = self
        z_viewnew.delegate = self
        z_viewnew.dataSource = self
        z_viewmain.delegate = self
        
        z_viewmodel.func_requesthotanchorslocal()
        z_viewmodel.func_requestnewanchorslocal()
        
        z_viewmodel.func_requesthotanchorsheader()
        z_viewmodel.func_requestnewanchorsheader()
        NotificationCenter.default.addObserver(self, selector: "func_PayRechargeSuccess:", name: Notification.Name.init(rawValue: "PayRechargeSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_UserBalanceChange:", name: Notification.Names.UserBalanceChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_UserInfoRefresh:", name: Notification.Name.init(rawValue: "UserInfoRefresh"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if lastemail != ZSettingKit.shared.user?.email {
            self.z_viewhot.reloadData()
        }
    }
    deinit {
        z_viewmodel.delegate = nil
        z_viewhot.delegate = nil
        z_viewhot.dataSource = nil
        z_viewnew.delegate = nil
        z_viewnew.dataSource = nil
        z_viewmain.delegate = nil
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(rawValue: "PayRechargeSuccess"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Names.UserBalanceChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(rawValue: "UserInfoRefresh"), object: nil)
    }
    private func func_setupevent() {
        z_viewhot.onRefreshHeader = {
            self.z_viewmodel.func_requesthotanchorsheader()
        }
        z_viewhot.onRefreshFooter = {
            self.z_viewmodel.func_requesthotanchorsfooter()
        }
        z_viewnew.onRefreshHeader = {
            self.z_viewmodel.func_requestnewanchorsheader()
        }
        z_viewnew.onRefreshFooter = {
            self.z_viewmodel.func_requestnewanchorsfooter()
        }
        self.z_viewhot.startAnimating()
        self.z_viewnew.startAnimating()
        z_btnhot.addTarget(self, action: "func_btnhotclick", for: .touchUpInside)
        z_btnnew.addTarget(self, action: "func_btnnewclick", for: .touchUpInside)
        z_btnrank.addTarget(self, action: "func_btnrankclick", for: .touchUpInside)
    }
    @objc private func func_btnhotclick() {
        z_viewhot.scrollsToTop = true
        z_viewnew.scrollsToTop = false
        if self.z_currentpage == 0 { return }
        z_viewmain.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    @objc private func func_btnnewclick() {
        z_viewhot.scrollsToTop = false
        z_viewnew.scrollsToTop = true
        if self.z_currentpage == 1 { return }
        z_viewmain.setContentOffset(CGPoint.init(x: z_viewmain.width, y: 0), animated: true)
    }
    @objc private func func_btnrankclick() {
        let z_tempvc = ZRankViewController.init()
        ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
    }
    private func func_itemchange(page: Int) {
        if self.z_currentpage != page {
            switch page {
            case 0:
                self.z_btnhot.isSelected = true
                self.z_btnnew.isSelected = false
            case 1:
                self.z_btnhot.isSelected = false
                self.z_btnnew.isSelected = true
            default: break
            }
            self.z_currentpage = page
        }
    }
}
extension ZAnchorsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch collectionView.tag {
        case 1:
            if let email = ZSettingKit.shared.user?.email, email.count == 0 {
                return CGSize.init(width: collectionView.width, height: 137.scale)
            }
        default:break
        }
        return CGSize.init(width: collectionView.width, height: 0.01.scale)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch collectionView.tag {
        case 1:
            if let email = ZSettingKit.shared.user?.email, email.count == 0 {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellHeaderId, for: indexPath) as! ZAnchorsItemHeaderView
                view.on_btncompleteclick = {
                    let z_tempvc = ZRegisterViewController.init()
                    z_tempvc.z_isbind = true
                    ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
                }
                return view
            }
        default:break
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellFooterId, for: indexPath) as! ZAnchorsItemSpaceView
        return view
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 2: return z_arraynew.count
        default:break
        }
        return z_arrayhot.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! ZAnchorsItemCVC
        switch collectionView.tag {
        case 1:
            cell.func_setcvcmodel(model: z_arrayhot[indexPath.row])
        case 2:
            cell.func_setcvcmodel(model: z_arraynew[indexPath.row])
        default: break
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let z_tempvc = ZUserDetailViewController.init()
        switch collectionView.tag {
        case 1:
            z_tempvc.z_model = ZModelUserInfo.init(instance: z_arrayhot[indexPath.row])
        case 2:
            z_tempvc.z_model = ZModelUserInfo.init(instance: z_arraynew[indexPath.row])
        default: break
        }
        ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
    }
}
extension ZAnchorsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 10 {
            let currentIndex = Int(floor(scrollView.contentOffset.x/(scrollView.frame.size.width/3*2)))
            self.func_itemchange(page: currentIndex)
        }
    }
}
extension ZAnchorsViewController: ZAnchorsViewModelDelegate {
  
    func func_requesthotsuccessheader(models: [ZModelUserInfo]?) {
        self.z_arrayhot.removeAll()
        if let array = models {
            self.z_arrayhot.append(contentsOf: array)
        }
        let count = models?.count ?? 0
        self.z_viewhot.stopAnimating(count: count)
        self.z_viewhot.endRefreshHeader(count)
        self.z_viewhot.reloadData()
    }
    func func_requestnewsuccessheader(models: [ZModelUserInfo]?) {
        self.z_arraynew.removeAll()
        if let array = models {
            self.z_arraynew.append(contentsOf: array)
        }
        let count = models?.count ?? 0
        self.z_viewnew.stopAnimating(count: count)
        self.z_viewnew.endRefreshHeader(count)
        self.z_viewnew.reloadData()
    }
    func func_requesthotsuccessfooder(models: [ZModelUserInfo]?) {
        if let array = models {
            self.z_arrayhot.append(contentsOf: array)
        }
        let count = models?.count ?? 0
        self.z_viewhot.endRefreshFooter(count)
        self.z_viewhot.reloadData()
    }
    func func_requestnewsuccessfooder(models: [ZModelUserInfo]?) {
        if let array = models {
            self.z_arraynew.append(contentsOf: array)
        }
        let count = models?.count ?? 0
        self.z_viewnew.endRefreshFooter(count)
        self.z_viewnew.reloadData()
    }
}
