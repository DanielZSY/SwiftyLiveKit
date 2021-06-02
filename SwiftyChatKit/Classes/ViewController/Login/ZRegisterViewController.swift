import UIKit
import SwiftBasicKit

class ZRegisterViewController: ZZBaseViewController {
    
    var z_isbind: Bool = false
    var z_gender: zUserGender = .male
    private var z_currentstep: Int = 1
    private var z_totalstep: Int = 4
    private var z_checkemail: Bool = false
    private var z_checkpassword: Bool = false
    private var z_checkusername: Bool = false
    private var z_checkphoto: Bool = false
    
    private lazy var z_btnback: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(0, kStatusHeight, 45, 45))
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.arrowLeftW.image, for: .normal)
        z_temp.imageEdgeInsets = UIEdgeInsets.init(top: 2, left: 2, bottom: 2, right: 2)
        return z_temp
    }()
    private lazy var z_viewcurrentstep: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(0, 0, (z_viewtotalstep.width)/CGFloat(z_totalstep), 6))
        z_temp.backgroundColor = "#493443".color
        z_temp.border(color: .clear, radius: 3, width: 0)
        return z_temp
    }()
    private lazy var z_viewtotalstep: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(z_btnback.width, kStatusHeight + 45/2 - 3, kScreenWidth - 70, 6))
        z_temp.backgroundColor = "#1E1925".color
        z_temp.border(color: .clear, radius: 3, width: 0)
        return z_temp
    }()
    private let z_inputheight: CGFloat = 230.scale
    private lazy var z_viewemail: ZRegisterInputView = {
        let z_temp = ZRegisterInputView.init(frame: CGRect.init(0, z_viewtotalstep.y + 55.scale, kScreenWidth, z_inputheight))
        z_temp.tag = 1
        return z_temp
    }()
    private lazy var z_viewusername: ZRegisterInputView = {
        let z_temp = ZRegisterInputView.init(frame: CGRect.init(kScreenWidth, z_viewemail.y, kScreenWidth, z_inputheight))
        z_temp.tag = 2
        z_temp.alpha = 0
        return z_temp
    }()
    private lazy var z_viewpassword: ZRegisterInputView = {
        let z_temp = ZRegisterInputView.init(frame: CGRect.init(kScreenWidth, z_viewemail.y, kScreenWidth, z_inputheight))
        z_temp.tag = 3
        z_temp.alpha = 0
        return z_temp
    }()
    private lazy var z_viewbirthday: ZRegisterBirthdayView = {
        let z_temp = ZRegisterBirthdayView.init(frame: CGRect.init(kScreenWidth, z_viewemail.y, kScreenWidth, 310))
        z_temp.alpha = 0
        return z_temp
    }()
    private lazy var z_btnNext: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(28.scale, z_viewemail.y + z_viewemail.height, 320.scale, 50.scale))
        z_temp.isEnabled = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.btnNext.text, for: .normal)
        z_temp.setTitle(ZString.btnNext.text, for: .disabled)
        z_temp.setTitleColor("#FFFFFF".color, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .disabled)
        z_temp.setBackgroundImage(UIImage.init(color: "#7037E9".color), for: .normal)
        z_temp.setBackgroundImage(UIImage.init(color: "#1E1925".color), for: .disabled)
        z_temp.titleLabel?.boldSize = 15
        z_temp.border(color: .clear, radius: 50.scale/2, width: 0)
        return z_temp
    }()
    private let z_viewmodel: ZRegisterViewModel = ZRegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.isNavigationHidden = true
        self.view.addSubview(z_btnback)
        self.view.addSubview(z_viewtotalstep)
        self.z_viewtotalstep.addSubview(z_viewcurrentstep)
        
        self.view.addSubview(z_viewemail)
        self.view.addSubview(z_viewusername)
        self.view.addSubview(z_viewpassword)
        self.view.addSubview(z_viewbirthday)
        self.view.addSubview(z_btnNext)
        
        self.z_btnback.addTarget(self, action: "func_btnbackclick", for: .touchUpInside)
        self.z_btnNext.addTarget(self, action: "func_btnnextclick", for: .touchUpInside)
        self.view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "func_viewtap:"))
        
        self.z_viewemail.z_ontextchange = { text in
            self.z_checkemail = text.isEmail()
            self.z_btnNext.isEnabled = self.z_checkemail
        }
        self.z_viewusername.z_ontextchange = { text in
            self.z_checkusername = ((text.count >= kMinUsername) && (text.count <= kMaxUsername))
            self.z_btnNext.isEnabled = self.z_checkusername
        }
        self.z_viewpassword.z_ontextchange = { text in
            self.z_checkpassword = text.isPassword()
            self.z_btnNext.isEnabled = self.z_checkpassword
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.z_viewmodel.delegate = self
        self.z_viewemail.func_showkey()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.z_viewmodel.delegate = nil
    }
    @objc private func func_viewtap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended: self.view.endEditing(true)
        default: break
        }
    }
    @objc private func func_btnbackclick() {
        switch z_currentstep {
        case 4:
            self.z_viewpassword.z_showkey = true
            self.z_btnNext.isEnabled = z_checkpassword
            UIView.animate(withDuration: 0.25, animations: {
                self.z_viewcurrentstep.width = self.z_viewtotalstep.width/CGFloat(self.z_totalstep)*3
                self.z_btnNext.y = self.z_viewpassword.y + self.z_viewpassword.height
                self.z_viewbirthday.alpha = 0
                self.z_viewbirthday.x = self.z_viewbirthday.width
                self.z_viewpassword.alpha = 1
                self.z_viewpassword.x = 0
            })
        case 3:
            self.z_viewpassword.z_showkey = false
            self.z_viewusername.z_showkey = true
            self.z_btnNext.isEnabled = z_checkusername
            UIView.animate(withDuration: 0.25, animations: {
                self.z_viewcurrentstep.width = self.z_viewtotalstep.width/CGFloat(self.z_totalstep)*2
                self.z_btnNext.y = self.z_viewusername.y + self.z_viewusername.height
                self.z_viewpassword.alpha = 0
                self.z_viewpassword.x = self.z_viewpassword.width
                self.z_viewusername.alpha = 1
                self.z_viewusername.x = 0
            })
        case 2:
            self.z_viewusername.z_showkey = false
            self.z_viewemail.z_showkey = true
            self.z_btnNext.isEnabled = z_checkemail
            UIView.animate(withDuration: 0.25, animations: {
                self.z_viewcurrentstep.width = self.z_viewtotalstep.width/CGFloat(self.z_totalstep)*1
                self.z_btnNext.y = self.z_viewemail.y + self.z_viewemail.height
                self.z_viewusername.alpha = 0
                self.z_viewusername.x = self.z_viewusername.width
                self.z_viewemail.alpha = 1
                self.z_viewemail.x = 0
            })
        case 1:
            ZRouterKit.pop(fromVC: self)
            return
        default: break
        }
        z_currentstep -= 1
    }
    @objc private func func_btnnextclick() {
        switch z_currentstep {
        case 1:
            self.view.endEditing(true)
            self.z_viewmodel.z_email = self.z_viewemail.z_text
            self.z_viewmodel.func_checkemail()
            return
//            self.z_viewemail.z_showkey = false
//            self.z_viewusername.z_showkey = true
//            self.z_btnNext.isEnabled = z_checkusername
//            UIView.animate(withDuration: 0.25, animations: {
//                self.z_viewcurrentstep.width = self.z_viewtotalstep.width/CGFloat(self.z_totalstep)*2
//                self.z_btnNext.y = self.z_viewusername.y + self.z_viewusername.height
//                self.z_viewemail.alpha = 0
//                self.z_viewemail.x = -self.z_viewemail.width
//                self.z_viewusername.alpha = 1
//                self.z_viewusername.x = 0
//            })
        case 2:
            self.z_viewusername.z_showkey = false
            self.z_viewpassword.z_showkey = true
            self.z_btnNext.isEnabled = z_checkpassword
            UIView.animate(withDuration: 0.25, animations: {
                self.z_viewcurrentstep.width = self.z_viewtotalstep.width/CGFloat(self.z_totalstep)*3
                self.z_btnNext.y = self.z_viewpassword.y + self.z_viewpassword.height
                self.z_viewusername.alpha = 0
                self.z_viewusername.x = -self.z_viewusername.width
                self.z_viewpassword.alpha = 1
                self.z_viewpassword.x = 0
            })
        case 3:
            self.z_viewpassword.z_showkey = false
            self.z_btnNext.isEnabled = true
            UIView.animate(withDuration: 0.25, animations: {
                self.z_viewcurrentstep.width = self.z_viewtotalstep.width/CGFloat(self.z_totalstep)*4
                self.z_btnNext.y = self.z_viewbirthday.y + self.z_viewbirthday.height
                self.z_viewpassword.alpha = 0
                self.z_viewpassword.x = -self.z_viewpassword.width
                self.z_viewbirthday.alpha = 1
                self.z_viewbirthday.x = 0
            })
        case 4:
            if self.z_isbind {
                self.func_bindclick()
            } else {
                self.func_registerclick()
            }
            return
        default: break
        }
        z_currentstep += 1
    }
    private func func_registerclick() {
        self.view.endEditing(true)
        self.z_viewmodel.z_gender = self.z_gender
        self.z_viewmodel.z_email = self.z_viewemail.z_text
        self.z_viewmodel.z_username = self.z_viewusername.z_text
        self.z_viewmodel.z_password = self.z_viewpassword.z_text
        self.z_viewmodel.z_birthday = self.z_viewbirthday.z_date
        self.z_viewmodel.z_year = self.z_viewbirthday.z_year
        
        self.z_viewmodel.func_registerclick()
    }
    private func func_bindclick() {
        self.view.endEditing(true)
        self.z_viewmodel.z_gender = self.z_gender
        self.z_viewmodel.z_email = self.z_viewemail.z_text
        self.z_viewmodel.z_username = self.z_viewusername.z_text
        self.z_viewmodel.z_password = self.z_viewpassword.z_text
        self.z_viewmodel.z_year = self.z_viewbirthday.z_year
        
        self.z_viewmodel.func_bindclick()
    }
}
extension ZRegisterViewController: ZRegisterViewModelDelegate {
    func func_bindsuccess() {
        ZAlertView.showAlertView(vc: self, message: ZString.alertBindAccountSuccess.text, completeBlock: {
            ZRouterKit.pop(fromVC: self)
        })
    }
    func func_checkemailsuccess() {
        self.z_viewemail.z_showkey = false
        self.z_viewusername.z_showkey = true
        self.z_btnNext.isEnabled = z_checkusername
        UIView.animate(withDuration: 0.25, animations: {
            self.z_viewcurrentstep.width = self.z_viewtotalstep.width/CGFloat(self.z_totalstep)*2
            self.z_btnNext.y = self.z_viewusername.y + self.z_viewusername.height
            self.z_viewemail.alpha = 0
            self.z_viewemail.x = -self.z_viewemail.width
            self.z_viewusername.alpha = 1
            self.z_viewusername.x = 0
        })
        self.z_currentstep += 1
    }
}
