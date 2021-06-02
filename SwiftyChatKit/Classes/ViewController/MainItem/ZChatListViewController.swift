
import UIKit
import SwiftBasicKit

class ZChatListViewController: ZZBaseViewController {
    
    private let kCellDefaultId = "kCellDefaultId"
    private let kCellCallId = "kCellCallId"
    private let kCellMessageId = "kCellMessageId"
    private var z_isauthorize: Bool {
        return ZConfig.shared.isNotificationAuthorize
    }
    private var z_arrayCalls: [ZModelCallRecord] = [ZModelCallRecord]()
    private var z_arrayMessages: [ZModelMessageRecord] = [ZModelMessageRecord]()
    private lazy var z_btnrank: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(kScreenWidth - 55, kStatusHeight, 55, 45))
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.btnRank.image, for: .normal)
        return z_temp
    }()
    private lazy var z_viewmain: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: kScreenWidth, height: 80)
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.scrollDirection = .vertical
        z_templayout.sectionHeadersPinToVisibleBounds = true
        z_templayout.sectionFootersPinToVisibleBounds = true
        
        let z_temp = ZBaseCV.init(frame: CGRect.init(0, kStatusHeight, kScreenWidth, kScreenHeight - kStatusHeight - kTabbarHeight), collectionViewLayout: z_templayout)
        z_temp.addRefreshHeader()
        z_temp.addRefreshFooter()
        z_temp.scrollsToTop = true
        z_temp.alwaysBounceVertical = true
        z_temp.isUserInteractionEnabled = true
        z_temp.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: kCellDefaultId)
        z_temp.register(ZChatlistMessagesCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        z_temp.register(ZCollectionSpaceReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellHeaderId)
        z_temp.register(ZChatlistHistoryView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellCallId)
        z_temp.register(ZChatlistMessagesView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellMessageId)
        return z_temp
    }()
    private let z_viewmodel: ZChatlistViewModel = ZChatlistViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.isNavigationHidden = true
        self.view.addSubview(z_btnrank)
        self.view.addSubview(z_viewmain)
        self.view.bringSubviewToFront(z_btnrank)
        
        self.view.addSubview(z_btnfirst)
        self.view.bringSubviewToFront(z_btnfirst)
        
        z_viewmain.delegate = self
        z_viewmain.dataSource = self
        z_viewmain.onRefreshHeader = {
            self.z_viewmodel.func_requestcallarray()
            self.z_viewmodel.func_requestmessagearrayheader()
        }
        z_btnrank.addTarget(self, action: "func_btnrankclick", for: .touchUpInside)
        z_viewmodel.delegate = self
        z_viewmodel.func_requestcalllocal()
        NotificationCenter.default.addObserver(self, selector: #selector(func_ReceivedNewMessage(_:)), name: Notification.Names.ReceivedNewMessage, object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_PayRechargeSuccess:", name: Notification.Name.init(rawValue: "PayRechargeSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_UserBalanceChange:", name: Notification.Names.UserBalanceChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_UserInfoRefresh:", name: Notification.Name.init(rawValue: "UserInfoRefresh"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        z_viewmodel.func_requestcallarray()
        z_viewmodel.func_requestmessagearrayheader()
    }
    deinit {
        z_viewmain.delegate = nil
        z_viewmain.dataSource = nil
        z_viewmodel.delegate = nil
        NotificationCenter.default.removeObserver(self, name: Notification.Names.ReceivedNewMessage, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(rawValue: "PayRechargeSuccess"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Names.UserBalanceChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(rawValue: "UserInfoRefresh"), object: nil)
    }
    @objc private func func_btnrankclick() {
        let z_tempvc = ZRankViewController.init()
        ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
    }
    @objc private func func_ReceivedNewMessage(_ sender: Notification) {
        if self.isCurrentShowVC {
            z_viewmodel.func_requestmessagearrayheader()
        }
    }
}
extension ZChatListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0: return (self.z_arrayCalls.count == 0) ?
            CGSize.init(width: collectionView.width, height: 0.01.scale) :
            CGSize.init(width: collectionView.width, height: 225.scale)
        default: break
        }
        return self.z_isauthorize ? CGSize.init(width: collectionView.width, height: 45) : CGSize.init(width: collectionView.width, height: 105.scale)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            if self.z_arrayCalls.count == 0 {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellHeaderId, for: indexPath) as! ZCollectionSpaceReusableView
                return view
            }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellCallId, for: indexPath) as! ZChatlistHistoryView
            view.z_arrayCall = self.z_arrayCalls
            view.z_oncallitemclick = { model in
                guard let user = model?.calluser else { return }
                let z_tempvc = ZUserDetailViewController.init()
                z_tempvc.z_model = ZModelUserInfo.init(instance: user)
                ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
            }
            return view
        default: break
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellMessageId, for: indexPath) as! ZChatlistMessagesView
        view.z_isauthorize = self.z_isauthorize
        view.z_onbuttonnotificationclick = {
            ZConfig.shared.registerNotification({ [weak self] accepted in
                guard let `self` = self else { return }
                DispatchQueue.DispatchaSync(mainHandler: {
                    if accepted {
                        self.z_viewmain.reloadData()
                    } else {
                        URL.openSetting()
                    }
                })
            })
        }
        return view
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 0
        default: break
        }
        return self.z_arrayMessages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellDefaultId, for: indexPath) as! UICollectionViewCell
            return cell
        default: break
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! ZChatlistMessagesCVC
        cell.tag = indexPath.row
        cell.z_model = self.z_arrayMessages[indexPath.row]
        cell.z_onbuttondeleteclick = { row in
            let model = self.z_arrayMessages[row]
            ZSQLiteKit.delModel(model: model)
            self.z_arrayMessages.remove(at: row)
            self.z_viewmain.reloadData()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let model = self.z_arrayMessages[indexPath.row]
            guard let user = model.message_user else { return }
            NotificationCenter.default.post(name: Notification.Names.ShowChatMessageVC, object: user)
        default: break
        }
    }
}
extension ZChatListViewController: ZChatlistViewModelDelegate {
    func func_requestcallssuccess(models: [ZModelCallRecord]?) {
        self.z_arrayCalls.removeAll()
        if let array = models {
            self.z_arrayCalls.append(contentsOf: array)
        }
        self.z_viewmain.reloadData()
    }
    func func_requestmessagesheadersuccess(models: [ZModelMessageRecord]?) {
        self.z_arrayMessages.removeAll()
        if let array = models {
            self.z_arrayMessages.append(contentsOf: array)
        }
        self.z_viewmain.reloadData()
        self.z_viewmain.endRefreshHeader(models?.count ?? 0)
    }
    func func_requestmessagesfootersuccess(models: [ZModelMessageRecord]?) {
        if let array = models {
            self.z_arrayMessages.append(contentsOf: array)
        }
        self.z_viewmain.reloadData()
        self.z_viewmain.endRefreshFooter(models?.count ?? 0)
    }
}
