
import UIKit
import BFKit
import SnapKit
import Photos
import PhotosUI
import SwiftBasicKit

class ZUserInfoEditViewController: ZZBaseViewController {
    
    private var z_showkeyend: Bool = false
    private var z_isclickmore: Bool = false
    private var z_phototag: Int = 0
    private var z_inputTag: Int = 1
    private var z_photocount: Int = 5
    
    private lazy var z_viewmain: ZBaseSV = {
        let z_temp = ZBaseSV.init(frame: CGRect.main())
        return z_temp
    }()
    private lazy var z_viewphotos: ZUserEditPhotosView = {
        let z_temp = ZUserEditPhotosView.init(frame: CGRect.init(0, kTopNavHeight + 10, z_viewmain.width, 255.scale))
        
        return z_temp
    }()
    private lazy var z_btnaddaphoto: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(28.scale, z_viewphotos.y + z_viewphotos.height, 320.scale, 50.scale))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.titleLabel?.boldSize = 15
        z_temp.setTitle(ZString.lbAddAPhoto.text, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .normal)
        z_temp.backgroundColor = "#7037E9".color
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        return z_temp
    }()
    private lazy var z_btnmorephoto: UIButton = {
        let z_temp = UIButton.init(frame: z_btnaddaphoto.frame)
        z_temp.isHidden = true
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.titleLabel?.boldSize = 15
        z_temp.setTitle(ZString.lbMorePhoto.text, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .normal)
        z_temp.backgroundColor = "#2D2638".color
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        return z_temp
    }()
    private lazy var z_viewnickname: ZUserEditTextField = {
        let z_temp = ZUserEditTextField.init(frame: CGRect.init(0, z_btnaddaphoto.y + z_btnaddaphoto.height + 20.scale, z_viewmain.width, 75))
        z_temp.tag = 1
        return z_temp
    }()
    private lazy var z_viewbirthday: ZUserEditTextField = {
        let z_temp = ZUserEditTextField.init(frame: CGRect.init(0, z_viewnickname.y + z_viewnickname.height + 1.scale, z_viewmain.width, 75))
        z_temp.tag = 2
        return z_temp
    }()
    private lazy var z_viewaboutme: ZUserEditTextView = {
        let z_temp = ZUserEditTextView.init(frame: CGRect.init(0, z_viewbirthday.y + z_viewbirthday.height + 1.scale, z_viewmain.width, 200))
        z_temp.tag = 3
        return z_temp
    }()
    private lazy var z_viewheight: ZUserEditTextField = {
        let z_temp = ZUserEditTextField.init(frame: CGRect.init(0, z_viewaboutme.y + z_viewaboutme.height + 1.scale, z_viewmain.width, 75))
        z_temp.tag = 4
        return z_temp
    }()
    private lazy var z_viewweight: ZUserEditTextField = {
        let z_temp = ZUserEditTextField.init(frame: CGRect.init(0, z_viewheight.y + z_viewheight.height + 1.scale, z_viewmain.width, 75))
        z_temp.tag = 5
        return z_temp
    }()
    private lazy var z_viewbodytype: ZUserEditTextField = {
        let z_temp = ZUserEditTextField.init(frame: CGRect.init(0, z_viewweight.y + z_viewweight.height + 1.scale, z_viewmain.width, 75))
        z_temp.tag = 6
        return z_temp
    }()
    private lazy var z_viewbelong: ZUserEditTextField = {
        let z_temp = ZUserEditTextField.init(frame: CGRect.init(0, z_viewbodytype.y + z_viewbodytype.height + 1.scale, z_viewmain.width, 75))
        z_temp.tag = 7
        return z_temp
    }()
    private let z_viewmodel: ZUserEditViewModel = ZUserEditViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.title = ZString.lbEditProfile.text
        
        self.view.addSubview(z_viewmain)
        
        z_viewmain.addSubview(z_viewphotos)
        z_viewmain.addSubview(z_btnaddaphoto)
        z_viewmain.addSubview(z_btnmorephoto)
        z_viewmain.addSubview(z_viewnickname)
        z_viewmain.addSubview(z_viewbirthday)
        z_viewmain.addSubview(z_viewaboutme)
        z_viewmain.addSubview(z_viewheight)
        z_viewmain.addSubview(z_viewweight)
        z_viewmain.addSubview(z_viewbodytype)
        z_viewmain.addSubview(z_viewbelong)

        z_viewmain.contentSize = CGSize.init(width: z_viewmain.width, height: z_viewbelong.y + z_viewbelong.height + 50.scale)

        func_setupevent()
        z_viewmodel.delegate = self
        z_viewmodel.func_requestuserphotos()
    }
    deinit {
        z_viewmodel.delegate = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.func_reloaduserinfo()
        self.registerKeyboardNotification()
        
        if ZSettingKit.shared.userId == ZSettingKit.shared.user?.nickname, z_showkeyend == false {
            z_showkeyend = true
            z_viewnickname.z_showkey = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardNotification()
    }
    override func btnNavBarLeftButtonEvent() {
        if self.z_viewmodel.z_changeduser {
            self.view.endEditing(true)
            ZAlertView.showAlertView(vc: self, message: ZString.alertMakesurenotsavechangeduserinfo.text, button: ZString.btnSave.text, completeBlock: { tag in
                if tag == 1 {
                    self.z_viewmodel.func_changeuserinfo()
                } else {
                    ZRouterKit.pop(fromVC: self)
                }
            })
            return
        }
        ZRouterKit.pop(fromVC: self)
    }
    override func keyboardFrameChange(_ height: CGFloat) {
        super.keyboardFrameChange(height)
        
        if height > 0 {
            var inputContentY = self.z_viewnickname.y + self.z_viewnickname.height
            switch self.z_inputTag {
            case 2: inputContentY = self.z_viewbirthday.y + self.z_viewbirthday.height
            case 3: inputContentY = self.z_viewaboutme.y + self.z_viewaboutme.height
            case 4: inputContentY = self.z_viewheight.y + self.z_viewheight.height
            case 5: inputContentY = self.z_viewweight.y + self.z_viewweight.height
            case 6: inputContentY = self.z_viewbodytype.y + self.z_viewbodytype.height
            case 7: inputContentY = self.z_viewbelong.y + self.z_viewbelong.height
            default: break
            }
            let inputY = self.z_viewmain.height - inputContentY - height
            if inputY < 0 {
                let scOffsetY = CGFloat(abs(inputY))
                self.z_viewmain.setContentOffset(CGPoint.init(x: 0, y: scOffsetY), animated: false)
            }
        }
    }
    private func func_setupevent() {
        z_viewphotos.z_onbuttonevent = { opt, tag in
            self.z_phototag = tag
            switch opt {
            case .cover:
                if tag > 0 {
                    ZAlertView.showActionSheetView(vc: self, message: ZString.lbAvatar.text, buttons: [ZString.lbSetavatar.text, ZString.lbMoveUp.text, ZString.lbMoveDown.text], completeBlock: { row in
                        switch row {
                        case 0: self.z_viewmodel.func_changephototohead(row: tag)
                        case 1: self.z_viewmodel.func_changephotomoveup(row: tag)
                        case 2: self.z_viewmodel.func_changephotomovedown(row: tag)
                        default: break
                        }
                    })
                }
            case .delete:
                if self.z_viewmodel.z_photos.count > 1 {
                    ZAlertView.showAlertView(vc: self, message: ZString.alertAreyousuredeletecurrentselectedphoto.text, completeBlock: { row in
                        if row == 1 {
                            self.z_viewmodel.func_deleteuserphotos(row: tag)
                        }
                    })
                } else {
                    ZAlertView.showAlertView(vc: self, message: ZString.alertDeleteuserphotosoneleast.text)
                }
            default: break
            }
        }
        z_btnaddaphoto.addTarget(self, action: "func_btnaddaphotoclick", for: .touchUpInside)
        z_btnmorephoto.addTarget(self, action: "func_btnmorephotoclick", for: .touchUpInside)
        
        z_viewnickname.z_onTextBeginEdit = {
            self.z_inputTag = self.z_viewnickname.tag
        }
        z_viewbirthday.z_onTextBeginEdit = {
            self.z_inputTag = self.z_viewbirthday.tag
        }
        z_viewaboutme.z_onTextBeginEdit = {
            self.z_inputTag = self.z_viewaboutme.tag
        }
        z_viewheight.z_onTextBeginEdit = {
            self.z_inputTag = self.z_viewheight.tag
        }
        z_viewweight.z_onTextBeginEdit = {
            self.z_inputTag = self.z_viewweight.tag
        }
        z_viewbodytype.z_onTextBeginEdit = {
            self.z_inputTag = self.z_viewbodytype.tag
        }
        z_viewbelong.z_onTextBeginEdit = {
            self.z_inputTag = self.z_viewbelong.tag
        }
        z_viewnickname.z_onTextChangedEdit = { text in
            self.z_viewmodel.z_username = text
            self.z_viewmodel.z_changeduser = true
        }
        z_viewbirthday.z_onTextChangedEdit = { text in
            self.z_viewmodel.z_birthday = text
            self.z_viewmodel.z_changeduser = true
        }
        z_viewaboutme.z_onTextChangedEdit = { text in
            self.z_viewmodel.z_aboutme = text
            self.z_viewmodel.z_changeduser = true
        }
        z_viewheight.z_onTextChangedEdit = { text in
            self.z_viewmodel.z_height = text
            self.z_viewmodel.z_changeduser = true
        }
        z_viewweight.z_onTextChangedEdit = { text in
            self.z_viewmodel.z_weight = text
            self.z_viewmodel.z_changeduser = true
        }
        z_viewbodytype.z_onTextChangedEdit = { text in
            self.z_viewmodel.z_bodytype = text
            self.z_viewmodel.z_changeduser = true
        }
        z_viewbelong.z_onTextChangedEdit = { text in
            self.z_viewmodel.z_belong = text
            self.z_viewmodel.z_changeduser = true
        }
    }
    private func func_reloaduserinfo() {
        guard let user = ZSettingKit.shared.user else { return }
        z_viewmodel.z_birthday = user.birthday
        z_viewmodel.z_username = user.nickname
        z_viewmodel.z_aboutme = user.introduction
        z_viewmodel.z_weight = user.weight
        z_viewmodel.z_height = user.height
        z_viewmodel.z_belong = user.belong
        z_viewmodel.z_bodytype = user.bodytype
        if let photos = user.photos {
            z_viewmodel.z_photos.append(contentsOf: photos)
            z_viewphotos.func_setuserphotos(photos: photos)
        }
        z_btnaddaphoto.isHidden = self.z_viewmodel.z_photos.count >= z_photocount
        z_btnmorephoto.isHidden = self.z_viewmodel.z_photos.count < z_photocount
        
        z_viewnickname.z_text = user.nickname
        z_viewbirthday.z_birthday = user.birthday
        z_viewheight.z_text = user.height
        z_viewweight.z_text = user.weight
        z_viewbodytype.z_bodytype = user.bodytype
        z_viewbelong.z_belong = user.belong
        z_viewaboutme.z_aboutme = user.introduction
    }
    @objc private func func_btnaddaphotoclick() {
        self.func_showactionsheetview()
    }
    @objc private func func_btnmorephotoclick() {
        if self.z_viewmodel.z_changeduser {
            ZAlertView.showAlertView(vc: self, message: ZString.alertPleasesavethechangedinfofirst.text, button: ZString.btnSave.text, completeBlock: { tag in
                if tag == 1 {
                    self.z_isclickmore = true
                    self.z_viewmodel.func_changeuserinfo()
                }
            })
            return
        }
        let t_tempvc = ZUserPhotoEditViewController.init()
        ZRouterKit.push(toVC: t_tempvc, fromVC: self, animated: true)
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
extension ZUserInfoEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        ZRouterKit.dismiss(fromVC: picker, animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.z_viewmodel.func_uploaduserphoto(image: image)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        ZRouterKit.dismiss(fromVC: picker, animated: true, completion: nil)
    }
}
extension ZUserInfoEditViewController: ZUserEditViewModelDelegate {
    func func_photochange() {
        self.func_requesstuserinfosuccess()
    }
    func func_changeuserinfosuccess() {
        if self.z_isclickmore {
            self.z_viewmodel.func_reloaduserinfo()
            let t_tempvc = ZUserPhotoEditViewController.init()
            ZRouterKit.push(toVC: t_tempvc, fromVC: self, animated: true)
        } else {
            ZRouterKit.pop(fromVC: self)
        }
    }
    func func_requesstuserinfosuccess() {
        self.z_viewphotos.func_setuserphotos(photos: self.z_viewmodel.z_photos)
        self.z_btnaddaphoto.isHidden = self.z_viewmodel.z_photos.count >= z_photocount
        self.z_btnmorephoto.isHidden = self.z_viewmodel.z_photos.count < z_photocount
    }
}
