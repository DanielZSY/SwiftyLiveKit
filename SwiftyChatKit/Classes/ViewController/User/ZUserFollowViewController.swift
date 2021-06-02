
import UIKit
import SwiftBasicKit

class ZUserFollowViewController: ZZBaseViewController {
    
    private var z_currentpage: Int = 1
    private var arrayfollowers: [ZModelUserInfo] = [ZModelUserInfo]()
    private var arrayfollowing: [ZModelUserInfo] = [ZModelUserInfo]()
    private lazy var z_btnback: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(0, kStatusHeight, 55, 50))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.arrowLeftW.image, for: .normal)
        return z_temp
    }()
    private lazy var z_btnfollowing: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(kScreenWidth/2 - 100, kStatusHeight, 100, 45))
        z_temp.isSelected = true
        z_temp.isHighlighted = false
        z_temp.titleLabel?.boldSize = 18
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.lbFollowing.text, for: .normal)
        z_temp.setTitle(ZString.lbFollowing.text, for: .selected)
        z_temp.setTitleColor("#493443".color, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .selected)
        return z_temp
    }()
    private lazy var z_btnfollowers: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(kScreenWidth/2, kStatusHeight, 100, 45))
        z_temp.isSelected = false
        z_temp.isHighlighted = false
        z_temp.titleLabel?.boldSize = 18
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.lbFollowers.text, for: .normal)
        z_temp.setTitle(ZString.lbFollowers.text, for: .selected)
        z_temp.setTitleColor("#493443".color, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .selected)
        return z_temp
    }()
    private lazy var z_viewmain: ZBaseSV = {
        let z_temp = ZBaseSV.init(frame: CGRect.init(0, kTopNavHeight, kScreenWidth, kScreenMainHeight))
        z_temp.tag = 10
        z_temp.scrollsToTop = false
        z_temp.isPagingEnabled = true
        z_temp.showsVerticalScrollIndicator = false
        z_temp.showsHorizontalScrollIndicator = false
        z_temp.contentSize = CGSize.init(width: z_temp.width*2, height: z_temp.height)
        return z_temp
    }()
    private lazy var z_viewfollowing: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: z_viewmain.width, height: 85.scale)
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.scrollDirection = .vertical
        
        let z_temp = ZBaseCV.init(frame: CGRect.init(0, 0, z_viewmain.width, z_viewmain.height), collectionViewLayout: z_templayout)
        z_temp.tag = 1
        z_temp.scrollsToTop = true
        z_temp.backgroundColor = .clear
        z_temp.alwaysBounceVertical = true
        z_temp.showsVerticalScrollIndicator = true
        z_temp.showsHorizontalScrollIndicator = false
        z_temp.addRefreshHeader()
        z_temp.addRefreshFooter()
        z_temp.register(ZUserFollowItemCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        return z_temp
    }()
    private lazy var z_viewfollowers: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: z_viewmain.width, height: 85.scale)
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.scrollDirection = .vertical
        
        let z_temp = ZBaseCV.init(frame: CGRect.init(z_viewmain.width, 0, z_viewmain.width, z_viewmain.height), collectionViewLayout: z_templayout)
        z_temp.tag = 2
        z_temp.scrollsToTop = false
        z_temp.backgroundColor = .clear
        z_temp.alwaysBounceVertical = true
        z_temp.showsVerticalScrollIndicator = true
        z_temp.showsHorizontalScrollIndicator = false
        z_temp.addRefreshHeader()
        z_temp.addRefreshFooter()
        z_temp.register(ZUserFollowItemCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        return z_temp
    }()
    private lazy var z_viewfollowingnodata: ZUserFollowNodataView = {
        let z_temp = ZUserFollowNodataView.init(frame: z_viewfollowing.bounds)
        z_viewfollowing.backgroundView = z_temp
        z_viewfollowing.backgroundView?.frame = z_viewfollowing.bounds
        return z_temp
    }()
    private lazy var z_viewfollowersnodata: ZUserFollowNodataView = {
        let z_temp = ZUserFollowNodataView.init(frame: z_viewfollowers.bounds)
        z_viewfollowers.backgroundView = z_temp
        z_viewfollowers.backgroundView?.frame = z_viewfollowers.bounds
        return z_temp
    }()
    private let z_viewmodel: ZUserFollowViewModel = ZUserFollowViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.isNavigationHidden = true
        self.view.addSubview(z_btnback)
        self.view.addSubview(z_btnfollowing)
        self.view.addSubview(z_btnfollowers)
        self.view.addSubview(z_viewmain)
        
        z_viewmain.addSubview(z_viewfollowing)
        z_viewmain.addSubview(z_viewfollowers)
        
        func_setupevent()
        
        z_viewfollowing.delegate = self
        z_viewfollowing.dataSource = self
        z_viewfollowers.delegate = self
        z_viewfollowers.dataSource = self
        z_viewmodel.delegate = self
        z_viewmain.delegate = self
        
        z_viewfollowingnodata.startAnimating()
        z_viewmodel.func_requestfollowinglocal()
        z_viewmodel.func_requestfollowerslocal()
        
        z_viewfollowersnodata.startAnimating()
        z_viewmodel.func_requestfollowingheader()
        z_viewmodel.func_requestfollowersheader()
    }
    deinit {
        z_viewfollowing.delegate = nil
        z_viewfollowing.dataSource = nil
        z_viewfollowers.delegate = nil
        z_viewfollowers.dataSource = nil
        z_viewmodel.delegate = nil
        z_viewmain.delegate = nil
    }
    private func func_setupevent() {
        z_viewfollowing.onRefreshHeader = {
            self.z_viewmodel.func_requestfollowingheader()
        }
        z_viewfollowing.onRefreshFooter = {
            self.z_viewmodel.func_requestfollowingfooter()
        }
        z_viewfollowers.onRefreshHeader = {
            self.z_viewmodel.func_requestfollowersheader()
        }
        z_viewfollowers.onRefreshFooter = {
            self.z_viewmodel.func_requestfollowersfooter()
        }
        z_viewfollowingnodata.z_onbuttonclick = {
            ZRouterKit.popToRoot(fromVC: self, animated: true, completion: {
                DispatchQueue.DispatchAfter(after: 0.75, handler: {
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "ShowAnchorListVC"), object: nil)
                })
            })
        }
        z_viewfollowersnodata.z_onbuttonclick = {
            ZRouterKit.popToRoot(fromVC: self, animated: true, completion: {
                DispatchQueue.DispatchAfter(after: 0.75, handler: {
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "ShowAnchorListVC"), object: nil)
                })
            })
        }
        z_btnback.addTarget(self, action: "func_btnbackclick", for: .touchUpInside)
        z_btnfollowing.addTarget(self, action: "func_btnfollowingclick", for: .touchUpInside)
        z_btnfollowers.addTarget(self, action: "func_btnfollowersclick", for: .touchUpInside)
    }
    @objc private func func_btnbackclick() {
        ZRouterKit.pop(fromVC: self)
    }
    @objc private func func_btnfollowingclick() {
        z_viewfollowing.scrollsToTop = true
        z_viewfollowers.scrollsToTop = false
        if self.z_currentpage == 0 { return }
        z_viewmain.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    @objc private func func_btnfollowersclick() {
        z_viewfollowing.scrollsToTop = false
        z_viewfollowers.scrollsToTop = true
        if self.z_currentpage == 1 { return }
        z_viewmain.setContentOffset(CGPoint.init(x: z_viewmain.width, y: 0), animated: true)
    }
    private func func_itemchange(page: Int) {
        if self.z_currentpage != page {
            switch page {
            case 0:
                self.z_btnfollowing.isSelected = true
                self.z_btnfollowers.isSelected = false
            case 1:
                self.z_btnfollowing.isSelected = false
                self.z_btnfollowers.isSelected = true
            default: break
            }
            self.z_currentpage = page
        }
    }
}
extension ZUserFollowViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 2: return arrayfollowers.count
        default: break
        }
        return arrayfollowing.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! ZUserFollowItemCVC
        switch collectionView.tag {
        case 1: cell.z_model = ZModelUserInfo.init(instance: arrayfollowing[indexPath.row])
        case 2: cell.z_model = ZModelUserInfo.init(instance: arrayfollowers[indexPath.row])
        default: break
        }
        cell.z_row = indexPath.row
        cell.tag = collectionView.tag
        cell.z_onbuttonclick = { opt, tag, row in
            let array = tag == 2 ? self.arrayfollowers : self.arrayfollowing
            guard array.count > row else { return }
            let user = array[row]
            switch opt {
            case 1:
                let z_tempvc = ZUserDetailViewController.init()
                z_tempvc.z_model = ZModelUserInfo.init(instance: user)
                ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
            case 2:
                NotificationCenter.default.post(name: Notification.Names.ShowChatMessageVC, object: user)
            case 3:
                ZAlertView.showAlertView(vc: self, message: ZString.alertAreyousureunfollowcurrentuser.text, completeBlock: { i in
                    if i == 1 { self.z_viewmodel.func_unfollowuser(userid: user.userid, row: row, tag: tag) }
                })
            default: break
            }
        }
        return cell
    }
}
extension ZUserFollowViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 10 {
            let currentIndex = Int(floor(scrollView.contentOffset.x/(scrollView.frame.size.width/3*2)))
            self.func_itemchange(page: currentIndex)
        }
    }
}
extension ZUserFollowViewController: ZUserFollowViewModelDelegate {
    func func_requestfollowingheadersuccess(models: [ZModelUserInfo]?) {
        self.arrayfollowing.removeAll()
        if let array = models {
            self.arrayfollowing.append(contentsOf: array)
        }
        let count = models?.count ?? 0
        self.z_viewfollowingnodata.z_datacount = count
        self.z_viewfollowing.endRefreshHeader(count)
        self.z_viewfollowing.reloadData()
    }
    func func_requestfollowersheadersuccess(models: [ZModelUserInfo]?) {
        self.arrayfollowers.removeAll()
        if let array = models {
            self.arrayfollowers.append(contentsOf: array)
        }
        let count = models?.count ?? 0
        self.z_viewfollowersnodata.z_datacount = count
        self.z_viewfollowers.endRefreshHeader(count)
        self.z_viewfollowers.reloadData()
    }
    func func_requestfollowingfootersuccess(models: [ZModelUserInfo]?) {
        if let array = models {
            self.arrayfollowing.append(contentsOf: array)
        }
        self.z_viewfollowing.endRefreshFooter(models?.count ?? 0)
        self.z_viewfollowing.reloadData()
    }
    func func_requestfollowersfootersuccess(models: [ZModelUserInfo]?) {
        if let array = models {
            self.arrayfollowers.append(contentsOf: array)
        }
        self.z_viewfollowers.endRefreshFooter(models?.count ?? 0)
        self.z_viewfollowers.reloadData()
    }
    func func_unfollowsuccess(row: Int, tag: Int) {
        switch tag {
        case 1:
            if self.arrayfollowing.count > row { self.arrayfollowing.remove(at: row) }
            if self.arrayfollowing.count == 0 { self.z_viewfollowingnodata.z_datacount = 0 }
            self.z_viewfollowing.reloadData()
        case 2:
            if self.arrayfollowers.count > row { self.arrayfollowers.remove(at: row) }
            if self.arrayfollowers.count == 0 { self.z_viewfollowersnodata.z_datacount = 0 }
            self.z_viewfollowers.reloadData()
        default: break
        }
    }
}
