
import UIKit
import BFKit
import BMPlayer
import SwiftBasicKit

class ZStartViewController: ZZBaseViewController {
    
    private var currentTime: TimeInterval = 0
    private var totalTime: TimeInterval = 1
    
    private lazy var z_viewmain: BMPlayer = {
        let control = ZBMPlayerCustomControlView()
        control.isUserInteractionEnabled = false
        control.backgroundColor = .clear
        control.progressView.alpha = 0
        let item = BMPlayer.init(customControlView: control)
        
        item.frame = CGRect.main()
        item.isUserInteractionEnabled = false
        item.panGesture.isEnabled = false
        item.backgroundColor = UIColor.clear
        item.videoGravity = .resizeAspectFill
        return item
    }()
    private lazy var z_viewcontent: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.main())
        z_temp.backgroundColor = .clear
        z_temp.image = Asset.loginBG.image
        z_temp.isUserInteractionEnabled = true
        return z_temp
    }()
    private lazy var z_btnsignin: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(UIScreen.screenWidth - 100.scale, kStatusHeight, 100.scale, 45))
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.btnSignIn.text, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .normal)
        z_temp.titleLabel?.boldSize = 16
        return z_temp
    }()
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, z_lbcontent.y - 15.scale - 24.scale, UIScreen.screenWidth, 24.scale))
        z_temp.textAlignment = .center
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 18
        z_temp.text = ZString.lbLoginTitle.text
        return z_temp
    }()
    private lazy var z_lbcontent: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(UIScreen.screenWidth/2 - 238.scale/2, z_btngender.y - 20.scale - 35.scale, 238.scale, 35.scale))
        z_temp.textAlignment = .center
        z_temp.textColor = "#FFFFFF".color
        z_temp.fontSize = 13
        z_temp.numberOfLines = 0
        z_temp.text = ZString.lbLoginDesc.text
        return z_temp
    }()
    private lazy var z_btngender: ZLoginGenderButton = {
        let z_temp = ZLoginGenderButton.init(frame: CGRect.init(kScreenWidth/2 - 150.scale/2, z_btnguest.y - 20.scale - 30.scale, 160.scale, 30.scale))
        return z_temp
    }()
    private lazy var z_btnguest: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(28.scale, z_viewcontent.height - 45.scale - 54.scale, 320.scale, 54.scale))
        z_temp.isEnabled = false
        z_temp.adjustsImageWhenHighlighted = true
        z_temp.setTitleColor("#333333".color, for: .normal)
        z_temp.titleLabel?.boldSize = 16
        z_temp.backgroundColor = "#FFFFFF".color
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        return z_temp
    }()
    private lazy var z_aiguest: UIActivityIndicatorView = {
        let z_temp = UIActivityIndicatorView.init(frame: CGRect.init(z_btnguest.width/2 - 25.scale/2, z_btnguest.height/2 - 25.scale/2, 25.scale, 25.scale))
        z_temp.style = .gray
        return z_temp
    }()
    private let z_viewmodel: ZStartViewModel = ZStartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.isNavigationHidden = true
        self.view.addSubview(z_viewmain)
        self.view.addSubview(z_viewcontent)
        self.view.bringSubviewToFront(z_viewcontent)
        z_viewcontent.addSubview(z_btnsignin)
        z_viewcontent.addSubview(z_lbtitle)
        z_viewcontent.addSubview(z_lbcontent)
        z_viewcontent.addSubview(z_btngender)
        z_viewcontent.addSubview(z_btnguest)
        z_btnguest.addSubview(z_aiguest)
        
        func_setupevent()
        func_setupdata()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.func_startplayer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.func_stopplayer()
    }
    deinit {
        self.z_viewmain.playTimeDidChange = nil
        self.z_viewmain.pause()
    }
    private func func_setupdata() {
        z_aiguest.startAnimating()
        z_viewmodel.func_request_loginpre({ [weak self] guest in
            guard let `self` = self else { return }
            self.z_aiguest.stopAnimating()
            self.z_btnguest.isEnabled = true
            self.z_viewmodel.z_guest = guest
            if guest {
                self.z_btnguest.setTitle(ZString.btnStartChatting.text, for: .normal)
            } else {
                self.z_btnguest.setTitle(ZString.btnSignUp.text, for: .normal)
            }
        })
        guard let url = URL.loginBGUrl(named: "loginbg") else { return }
        let resource = BMPlayerResource.init(url: url)
        self.z_viewmain.setVideo(resource: resource)
        self.z_viewmain.playTimeDidChange = { current, total in
            self.currentTime = current
            self.totalTime = total
            if self.currentTime == self.totalTime {
                self.func_replayer()
            }
        }
    }
    private func func_setupevent() {
        z_btngender.addTarget(self, action: "func_btngenderclick", for: .touchUpInside)
        z_btnguest.addTarget(z_viewmodel, action: "func_loginclick", for: .touchUpInside)
        z_btnsignin.addTarget(z_viewmodel, action: "func_signinclick", for: .touchUpInside)
    }
    @objc private func func_btngenderclick() {
        switch self.z_btngender.z_gender {
        case .male:
            self.z_btngender.z_gender = .female
            self.z_viewmodel.z_gender = .female
        case .female:
            self.z_btngender.z_gender = .male
            self.z_viewmodel.z_gender = .male
        default: break
        }
    }
    private final func func_replayer() {
        self.z_viewmain.seek(0, completion: {
            DispatchQueue.DispatchaSync(mainHandler: {
                self.z_viewmain.play()
            })
        })
    }
    private func func_startplayer() {
        if self.currentTime == self.totalTime {
            self.z_viewmain.seek(0, completion: {
                DispatchQueue.DispatchaSync(mainHandler: {
                    self.z_viewmain.play()
                })
            })
        } else {
            DispatchQueue.DispatchaSync(mainHandler: {
                self.z_viewmain.play()
            })
        }
    }
    private func func_stopplayer() {
        DispatchQueue.DispatchaSync(mainHandler: {
            self.z_viewmain.pause()
        })
    }
}
