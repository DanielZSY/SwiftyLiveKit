
import UIKit
import SwiftBasicKit

class ZUserSettingsViewController: ZZBaseViewController {
    
    private let btnitemw = kScreenWidth
    private let btnitemh = 50.scale
    private lazy var z_btndeleteaccount: ZUserSettingsItemButton = {
        let z_temp = ZUserSettingsItemButton.init(frame: CGRect.init(0, kTopNavHeight + 10, btnitemw, btnitemh))
        z_temp.z_type = "Deleteaccount"
        return z_temp
    }()
    private lazy var z_btnclearcache: ZUserSettingsItemButton = {
        let z_temp = ZUserSettingsItemButton.init(frame: CGRect.init(0, z_btndeleteaccount.y + z_btndeleteaccount.height + 10, btnitemw, btnitemh))
        z_temp.z_type = "ClearCache"
        return z_temp
    }()
    private lazy var z_btnfeedback: ZUserSettingsItemButton = {
        let z_temp = ZUserSettingsItemButton.init(frame: CGRect.init(0, z_btnclearcache.y + z_btnclearcache.height, btnitemw, btnitemh))
        z_temp.z_type = "Feedback"
        return z_temp
    }()
    private lazy var z_btnrateusinappstore: ZUserSettingsItemButton = {
        let z_temp = ZUserSettingsItemButton.init(frame: CGRect.init(0, z_btnfeedback.y + z_btnfeedback.height, btnitemw, btnitemh))
        z_temp.z_type = "RateusinAppStore"
        return z_temp
    }()
    private lazy var z_btntermsofservice: ZUserSettingsItemButton = {
        let z_temp = ZUserSettingsItemButton.init(frame: CGRect.init(0, z_btnrateusinappstore.y + z_btnrateusinappstore.height, btnitemw, btnitemh))
        z_temp.z_type = "TermsofService"
        return z_temp
    }()
    private lazy var z_btnshowlocation: ZUserSettingsItemButton = {
        let z_temp = ZUserSettingsItemButton.init(frame: CGRect.init(0, z_btntermsofservice.y + z_btntermsofservice.height, btnitemw, btnitemh))
        z_temp.z_type = "ShowLocation"
        return z_temp
    }()
    private lazy var z_btnversion: ZUserSettingsItemButton = {
        let z_temp = ZUserSettingsItemButton.init(frame: CGRect.init(0, z_btnshowlocation.y + z_btnshowlocation.height + 10, btnitemw, btnitemh))
        z_temp.z_type = "Version"
        return z_temp
    }()
    private lazy var z_btnsignout: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(10.scale, z_btnversion.y + z_btnversion.height + 30, 355.scale, 50.scale))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.btnSignOut.text, for: .normal)
        z_temp.titleLabel?.boldSize = 15
        z_temp.border(color: .clear, radius: 50.scale/2, width: 0)
        z_temp.setTitleColor("#FFFFFF".color, for: .normal)
        z_temp.backgroundColor = "#7037E9".color
        return z_temp
    }()
    private let z_viewmodel: ZUserSettingsViewModel = ZUserSettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.title = ZString.lbSettings.text
        
        self.view.addSubview(z_btndeleteaccount)
        self.view.addSubview(z_btnclearcache)
        self.view.addSubview(z_btnfeedback)
        self.view.addSubview(z_btnrateusinappstore)
        self.view.addSubview(z_btntermsofservice)
        self.view.addSubview(z_btnshowlocation)
        self.view.addSubview(z_btnversion)
        self.view.addSubview(z_btnsignout)
        
        z_btndeleteaccount.addTarget(self, action: "func_btndeleteaccountclick", for: .touchUpInside)
        z_btnclearcache.addTarget(self, action: "func_btnclearcacheclick", for: .touchUpInside)
        z_btnfeedback.addTarget(self, action: "func_btnfeedbackclick", for: .touchUpInside)
        z_btnrateusinappstore.addTarget(self, action: "func_btnrateusinappstoreclick", for: .touchUpInside)
        z_btntermsofservice.addTarget(self, action: "func_btntermsofserviceclick", for: .touchUpInside)
        //z_btnversion.addTarget(self, action: "func_btnversionclick", for: .touchUpInside)
        z_btnsignout.addTarget(self, action: "func_btnsignoutclick", for: .touchUpInside)
        z_btnshowlocation.z_onswitchchange = { ison in
            self.z_viewmodel.func_changeshowlocation(on: self.z_btnshowlocation.z_showlocation)
        }
        var cachesize: UInt64 = 0
        self.z_btnclearcache.z_cachesize = 0
        let cachepath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.path
        DispatchQueue.DispatchaSync(globalHandler: {
            cachesize = ZLocalFileApi.folderSize(folderPath: cachepath)
        }, mainHandler: {
            self.z_btnclearcache.z_cachesize = cachesize
        })
        self.z_btnversion.z_version = kAppVersion
        guard let user = ZSettingKit.shared.user else {
            return
        }
        self.z_btnshowlocation.z_showlocation = user.show_location
    }
    @objc private func func_btndeleteaccountclick() {
        ZAlertView.showAlertView(vc: self, message: ZString.alertAreyousuretodeletethecurrentaccount.text, completeBlock: { row in
            if row == 1 {
                self.z_viewmodel.func_requestdeleteaccount()
            }
        })
    }
    @objc private func func_btnclearcacheclick() {
        ZAlertView.showAlertView(vc: self, message: ZString.alertAreyousuretoclearthecurrentcache.text, completeBlock: { row in
            if row == 1 {
                var cachesize: UInt64 = 0
                let cachepath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.path
                DispatchQueue.DispatchaSync(globalHandler: {
                    ZLocalFileApi.deleteFiles(folderPath: ZLocalFileApi.imageFileFolder.path)
                    ZLocalFileApi.deleteFiles(folderPath: ZLocalFileApi.amrRecordFolder.path)
                    ZLocalFileApi.deleteFiles(folderPath: ZLocalFileApi.wavRecordFolder.path)
                    ZLocalFileApi.deleteFiles(folderPath: ZLocalFileApi.mp3RecordFolder.path)
                    ZLocalFileApi.deleteFiles(folderPath: ZLocalFileApi.mp4RecordFolder.path)
                    ZLocalFileApi.deleteFiles(folderPath: ZLocalFileApi.tempFileFolder.path)
                    cachesize = ZLocalFileApi.folderSize(folderPath: cachepath)
                }, mainHandler: {
                    self.z_btnclearcache.z_cachesize = cachesize
                })
            }
        })
    }
    @objc private func func_btnfeedbackclick() {
        ZRouterKit.push(toVC: ZUserFeedbackViewController.init(), fromVC: self, animated: true)
    }
    @objc private func func_btnrateusinappstoreclick() {
        URL.openURL(kAppRateUrl)
    }
    @objc private func func_btntermsofserviceclick() {
        let z_tempvc = ZHtmlViewController.init()
        z_tempvc.title = ZString.lbTermsofService.text
        z_tempvc.fileName = "terms.html"
        ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
    }
    @objc private func func_btnsignoutclick() {
        ZAlertView.showAlertView(vc: self, message: ZString.alertAreyousuretologoutofthecurrentaccount.text, completeBlock: { row in
            if row == 1 {
                self.z_viewmodel.func_requestlogout()
            }
        })
    }
}
