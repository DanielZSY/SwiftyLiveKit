
import UIKit
import SwiftBasicKit

class ZUserBlacklistViewController: ZZBaseViewController {
    
    private var arrayBlacks: [ZModelUserInfo] = [ZModelUserInfo]()
    private lazy var z_viewmain: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: kScreenWidth, height: 85.scale)
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.scrollDirection = .vertical
        
        let z_temp = ZBaseCV.init(frame: CGRect.mainRemoveTop(), collectionViewLayout: z_templayout)
        z_temp.tag = 1
        z_temp.addNoDataView()
        z_temp.addRefreshHeader()
        z_temp.addRefreshFooter()
        z_temp.backgroundColor = .clear
        z_temp.alwaysBounceVertical = true
        z_temp.showsVerticalScrollIndicator = true
        z_temp.showsHorizontalScrollIndicator = false
        z_temp.register(ZUserFollowItemCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        return z_temp
    }()
    private let z_viewmodel: ZUserBlacklistViewModel = ZUserBlacklistViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        z_viewmodel.vc = self
        self.title = ZString.lbBlacklist.text
        self.view.addSubview(z_viewmain)
        
        z_viewmain.onRefreshHeader = {
            self.z_viewmodel.func_requestheader()
        }
        z_viewmain.onRefreshFooter = {
            self.z_viewmodel.func_requestfooter()
        }
        z_viewmain.delegate = self
        z_viewmain.dataSource = self
        z_viewmodel.delegate = self
        
        z_viewmain.startAnimating()
        z_viewmodel.func_requestlocal()
        z_viewmodel.func_requestheader()
    }
    deinit {
        z_viewmain.delegate = nil
        z_viewmain.dataSource = nil
        z_viewmodel.delegate = nil
    }
}
extension ZUserBlacklistViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayBlacks.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! ZUserFollowItemCVC
        
        cell.z_model = ZModelUserInfo.init(instance: arrayBlacks[indexPath.row])
        cell.z_row = indexPath.row
        cell.tag = collectionView.tag
        cell.z_hidmessage = true
        cell.z_onbuttonclick = { opt, tag, row in
            guard self.arrayBlacks.count > row else { return }
            let user = self.arrayBlacks[row]
            switch opt {
            case 1:
                let z_tempvc = ZUserDetailViewController.init()
                z_tempvc.z_model = ZModelUserInfo.init(instance: user)
                ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
            case 3:
                ZAlertView.showAlertView(vc: self, message: ZString.alertAreyousureunblockcurrentuser.text, completeBlock: { i in
                    if i == 1 {
                        self.z_viewmodel.func_unblockuser(userid: user.userid, row: row, tag: tag)
                    }
                })
            default: break
            }
        }
        return cell
    }
}
extension ZUserBlacklistViewController: ZUserBlacklistViewModelDelegate {
    func func_unblicksuccess(row: Int, tag: Int) {
        if self.arrayBlacks.count > row { self.arrayBlacks.remove(at: row) }
        if self.arrayBlacks.count == 0 { self.z_viewmain.endRefreshHeader(0) }
        self.z_viewmain.reloadData()
    }
    func func_requestheadersuccess(models: [ZModelUserInfo]?) {
        self.arrayBlacks.removeAll()
        if let array = models {
            self.arrayBlacks.append(contentsOf: array)
        }
        let count = models?.count ?? 0
        self.z_viewmain.stopAnimating(count: count)
        self.z_viewmain.endRefreshHeader(count)
        self.z_viewmain.reloadData()
    }
    func func_requestfootersuccess(models: [ZModelUserInfo]?) {
        if let array = models {
            self.arrayBlacks.append(contentsOf: array)
        }
        let count = models?.count ?? 0
        self.z_viewmain.endRefreshFooter(count)
        self.z_viewmain.reloadData()
    }
}
