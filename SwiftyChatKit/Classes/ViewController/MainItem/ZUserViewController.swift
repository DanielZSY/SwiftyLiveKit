
import UIKit
import SwiftBasicKit

class ZUserViewController: ZZBaseViewController {
    
    private lazy var z_viewmain: ZBaseSV = {
        let z_temp = ZBaseSV.init(frame: CGRect.init(0, 0, kScreenWidth, kScreenHeight - kTabbarHeight))
        z_temp.addRefreshHeader()
        z_temp.backgroundColor = .clear
        z_temp.scrollsToTop = true
        z_temp.showsVerticalScrollIndicator = false
        z_temp.showsHorizontalScrollIndicator = false
        return z_temp
    }()
    private lazy var z_imagephoto: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(kScreenWidth/2 - 103/2, kStatusHeight + 33, 103, 103))
        z_temp.image = Asset.defaultAvatar.image
        z_temp.isUserInteractionEnabled = true
        z_temp.border(color: "#7037E9".color, radius: 103/2, width: 3)
        return z_temp
    }()
    private lazy var z_btneditphoto: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_imagephoto.x + 60, z_imagephoto.y + 64, 45, 45))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.userModify.image, for: .normal)
        return z_temp
    }()
    private lazy var z_lbusername: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, z_imagephoto.y + z_imagephoto.height + 12, kScreenWidth, 24))
        z_temp.textAlignment = .center
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 18
        return z_temp
    }()
    private lazy var z_lbuserid: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, z_lbusername.y + z_lbusername.height, kScreenWidth, 20))
        z_temp.textAlignment = .center
        z_temp.textColor = "#606068".color
        z_temp.boldSize = 13
        return z_temp
    }()
    private lazy var z_btnrecharge: ZUserRechargeButton = {
        let z_temp = ZUserRechargeButton.init(frame: CGRect.init(22.scale, z_lbuserid.y + 43, 332.scale, 70.scale))
        return z_temp
    }()
    private lazy var z_viewincognitomode: ZUserIncognitoModeView = {
        let z_temp = ZUserIncognitoModeView.init(frame: CGRect.init(0, z_btnrecharge.y + z_btnrecharge.height + 33.scale, kScreenWidth, 60))
        return z_temp
    }()
    private let btnitems = 1.scale
    private let btnitemx = 0.scale
    private let btnitemh = 50.scale
    private let btnitemw = kScreenWidth
    private lazy var z_btneditprofile: ZUserCenterItemButton = {
        let z_temp = ZUserCenterItemButton.init(frame: CGRect.init(btnitemx, z_viewincognitomode.y + z_viewincognitomode.height + 30.scale, btnitemw, btnitemh))
        z_temp.z_type = "EitProfile"
        return z_temp
    }()
    private lazy var z_btnexpensesrecord: ZUserCenterItemButton = {
        let z_temp = ZUserCenterItemButton.init(frame: CGRect.init(btnitemx, z_btneditprofile.y + z_btneditprofile.height + btnitems, btnitemw, btnitemh))
        z_temp.z_type = "ExpensesRecord"
        return z_temp
    }()
    private lazy var z_btnfollow: ZUserCenterItemButton = {
        let z_temp = ZUserCenterItemButton.init(frame: CGRect.init(btnitemx, z_btnexpensesrecord.y + z_btnexpensesrecord.height + btnitems, btnitemw, btnitemh))
        z_temp.z_type = "Follow"
        return z_temp
    }()
    private lazy var z_btnblacklist: ZUserCenterItemButton = {
        let z_temp = ZUserCenterItemButton.init(frame: CGRect.init(btnitemx, z_btnfollow.y + z_btnfollow.height + btnitems, btnitemw, btnitemh))
        z_temp.z_type = "Blacklist"
        return z_temp
    }()
    private lazy var z_btnsettings: ZUserCenterItemButton = {
        let z_temp = ZUserCenterItemButton.init(frame: CGRect.init(btnitemx, z_btnblacklist.y + z_btnblacklist.height + btnitems, btnitemw, btnitemh))
        z_temp.z_type = "Settings"
        return z_temp
    }()
    private let z_viewmodel: ZUserViewModel = ZUserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.isNavigationHidden = true
        self.view.addSubview(z_viewmain)
        
        z_viewmain.addSubview(z_imagephoto)
        z_viewmain.addSubview(z_btneditphoto)
        z_viewmain.bringSubviewToFront(z_btneditphoto)
        z_viewmain.addSubview(z_lbusername)
        z_viewmain.addSubview(z_lbuserid)
        z_viewmain.addSubview(z_btnrecharge)
        z_viewmain.addSubview(z_viewincognitomode)
        z_viewmain.addSubview(z_btneditprofile)
        z_viewmain.addSubview(z_btnexpensesrecord)
        z_viewmain.addSubview(z_btnfollow)
        z_viewmain.addSubview(z_btnblacklist)
        z_viewmain.addSubview(z_btnsettings)
        
        self.view.addSubview(z_btnfirst)
        self.view.bringSubviewToFront(z_btnfirst)
        
        z_viewmain.contentSize = CGSize.init(width: z_viewmain.width, height: z_btnsettings.y + z_btnsettings.height + 50.scale)
        
        z_viewmodel.delegate = self
        z_viewmain.onRefreshHeader = {
            self.z_viewmodel.func_requestuserdetail()
        }
        func_setupevent()
        NotificationCenter.default.addObserver(self, selector: "func_PayRechargeSuccess:", name: Notification.Name.init(rawValue: "PayRechargeSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_UserBalanceChange:", name: Notification.Names.UserBalanceChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_UserInfoRefresh:", name: Notification.Name.init(rawValue: "UserInfoRefresh"), object: nil)
    }
    deinit {
        z_viewmodel.delegate = nil
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(rawValue: "PayRechargeSuccess"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Names.UserBalanceChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(rawValue: "UserInfoRefresh"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        func_setupuserchange()
        z_viewmodel.func_requestuserdetail()
    }
    private func func_setupuserchange() {
        self.z_viewmain.endRefreshHeader()
        z_btnrecharge.z_coins = ZSettingKit.shared.balance
        guard let user = ZSettingKit.shared.user else { return }
        z_lbuserid.text = "ID: " + user.userid
        z_lbusername.text = user.nickname
        z_viewincognitomode.z_onmode = user.incognito_mode
        z_imagephoto.setImageWitUrl(strUrl: user.avatar, placeholder: Asset.defaultAvatar.image)
    }
    private func func_setupevent() {
        z_btneditphoto.addTarget(self, action: "func_btneditphotoclick", for: .touchUpInside)
        z_btnrecharge.addTarget(self, action: "func_btnrechargeclick", for: .touchUpInside)
        z_btneditprofile.addTarget(self, action: "func_btneditprofileclick", for: .touchUpInside)
        z_btnexpensesrecord.addTarget(self, action: "func_btnexpensesrecordclick", for: .touchUpInside)
        z_btnfollow.addTarget(self, action: "func_btnfollowclick", for: .touchUpInside)
        z_btnblacklist.addTarget(self, action: "func_btnblacklistclick", for: .touchUpInside)
        z_btnsettings.addTarget(self, action: "func_btnsettingsclick", for: .touchUpInside)
        z_viewincognitomode.z_onswitchchange = { on in
            self.z_viewmodel.func_changeuserinmode(on: on)
        }
        z_imagephoto.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "func_imagephototap:"))
    }
    @objc private func func_imagephototap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            let z_tempvc = ZUserInfoEditViewController.init()
            ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
        default: break
        }
    }
    @objc private func func_btneditphotoclick() {
        func_showactionsheetview()
    }
    @objc private func func_btnrechargeclick() {
        let z_tempvc = ZRechargeViewController.init()
        ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
    }
    @objc private func func_btneditprofileclick() {
        let z_tempvc = ZUserInfoEditViewController.init()
        ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
    }
    @objc private func func_btnexpensesrecordclick() {
        let z_tempvc = ZUserExpensesRecordViewController.init()
        ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
    }
    @objc private func func_btnfollowclick() {
        let z_tempvc = ZUserFollowViewController.init()
        ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
    }
    @objc private func func_btnblacklistclick() {
        let z_tempvc = ZUserBlacklistViewController.init()
        ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
    }
    @objc private func func_btnsettingsclick() {
        let z_tempvc = ZUserSettingsViewController.init()
        ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
    }
    private func func_showcamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let z_tempvc = ZImageSelectViewController()
            
            z_tempvc.delegate = self
            z_tempvc.allowsEditing = true
            z_tempvc.modalPresentationStyle = .fullScreen
            z_tempvc.sourceType = UIImagePickerController.SourceType.camera
            
            ZRouterKit.present(toVC: z_tempvc, fromVC: self, animated: true, completion: nil)
        } else {
            ZProgressHUD.showMessage(vc: self, text: ZString.errorDeviceNotCameraPrompt.text)
        }
    }
    private func func_showalbum() {
        let z_tempvc = ZImageSelectViewController()
        
        z_tempvc.delegate = self
        z_tempvc.allowsEditing = true
        z_tempvc.modalPresentationStyle = .fullScreen
        z_tempvc.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        ZRouterKit.present(toVC: z_tempvc, fromVC: self, animated: true, completion: nil)
    }
    private func func_showactionsheetview() {
        ZAlertView.showActionSheetView(vc: self, message: ZString.lbSelectPhoto.text, buttons: [ZString.btnAlbum.text, ZString.btnCamera.text], completeBlock: { row in
            switch row {
            case 0: self.func_showalbum()
            case 1: self.func_showcamera()
            default: break
            }
        })
    }
}
extension ZUserViewController: ZUserViewModelDelegate {
    func func_requestuserdetailfaild() {
        self.z_viewmain.endRefreshHeader()
    }
    func func_requestuserdetailsuccess() {
        self.func_setupuserchange()
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "UserInfoRefresh"), object: nil)
    }
    func func_requestuserchange() {
        self.func_setupuserchange()
    }
}
extension ZUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        ZRouterKit.dismiss(fromVC: picker, animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.z_viewmodel.func_uploaduserphoto(image: image)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        ZRouterKit.dismiss(fromVC: picker, animated: true, completion: nil)
    }
}

