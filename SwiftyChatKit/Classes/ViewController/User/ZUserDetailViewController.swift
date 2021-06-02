
import UIKit
import BFKit
import SwiftBasicKit

class ZUserDetailViewController: ZZBaseViewController {
    
    var z_isCountdown: Bool = false
    var z_model: ZModelUserInfo?
    
    private var z_isStopCountdown: Bool = false
    private var z_currenttime: TimeInterval = kMaxMatchWaitTime
    private lazy var z_viewpage: ZAnchorsPhotosPageView = {
        let z_temp = ZAnchorsPhotosPageView.init(frame: CGRect.init(55, kStatusHeight + 50.scale/2 - 3.scale, kScreenWidth - 110, 6.scale))
        return z_temp
    }()
    private lazy var z_viewphotos: ZCycleBaseScrollView = {
        let z_temp = ZCycleBaseScrollView.init(frame: CGRect.main())
        z_temp.showPageControl = false
        return z_temp
    }()
    private lazy var z_viewmain: ZBaseSV = {
        let z_temp = ZBaseSV.init(frame: CGRect.main())
        z_temp.backgroundColor = .clear
        z_temp.scrollsToTop = true
        z_temp.isPagingEnabled = true
        z_temp.showsHorizontalScrollIndicator = false
        z_temp.showsVerticalScrollIndicator = true
        z_temp.contentSize = CGSize.init(width: z_temp.width, height: z_temp.height * 2)
        return z_temp
    }()
    private lazy var z_viewheader: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(0, 0, kScreenWidth, 80 + kStatusHeight))
        z_temp.isUserInteractionEnabled = true
        z_temp.image = Asset.defaultTransparent.image
        return z_temp
    }()
    private lazy var z_btnback: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(0, kStatusHeight, 55, 50))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.btnBackRound.image, for: .normal)
        return z_temp
    }()
    private lazy var z_btnmore: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(kScreenWidth - 55, kStatusHeight, 55, 50))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.btnReport.image, for: .normal)
        return z_temp
    }()
    private lazy var z_viewtime: ZTimeCountdownView = {
        let z_temp = ZTimeCountdownView.init(frame: CGRect.init(kScreenWidth - 60.scale, kStatusHeight + 60, 55.scale, 55.scale))
        z_temp.z_maxtime = kMaxMatchWaitTime
        return z_temp
    }()
    private lazy var z_viewcontent: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(0, kScreenHeight - 224, kScreenWidth, 224))
        z_temp.image = Asset.defaultTransparentBig.image
        return z_temp
    }()
    private lazy var z_lbusername: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(kScreenWidth/2, z_imagegender.y - 4, 0, 30))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 24
        return z_temp
    }()
    private lazy var z_imagegender: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(kScreenWidth/2, 64, 22, 22))
        z_temp.image = Asset.matchMaleP.image
        return z_temp
    }()
    private lazy var z_viewcountry: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(57.scale, 108.scale, 92.scale, 28.scale))
        z_temp.backgroundColor = "#000000".color.withAlphaComponent(0.7)
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        return z_temp
    }()
    private lazy var z_imagecountry: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(13.scale, 7.scale, 18.scale, 14.scale))
        z_temp.image = Asset.us.image
        return z_temp
    }()
    private lazy var z_lbcountry: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(35.5.scale, 0, z_viewcountry.width - 38.scale, z_viewcountry.height))
        z_temp.textColor = "#BFBDBE".color
        z_temp.boldSize = 12
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_viewcoins: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(160.scale, 108.scale, 87.scale, 28.scale))
        z_temp.backgroundColor = "#000000".color.withAlphaComponent(0.7)
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        return z_temp
    }()
    private lazy var z_imagecoins: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(9.5.scale, 7.5.scale, 12.scale, 13.5.scale))
        z_temp.image = Asset.iconDiamond1.image
        return z_temp
    }()
    private lazy var z_lbcoins: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(27.scale, 0, z_viewcoins.width - 30.scale, z_viewcoins.height))
        z_temp.textColor = "#BFBDBE".color
        z_temp.boldSize = 12
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_viewscore: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(258.scale, 108.scale, 65.scale, 28.scale))
        z_temp.backgroundColor = "#000000".color.withAlphaComponent(0.7)
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        return z_temp
    }()
    private lazy var z_imagescore: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(9.5.scale, 9.scale, 10.5.scale, 10.scale))
        z_temp.image = Asset.anchorScore.image
        return z_temp
    }()
    private lazy var z_lbscore: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(27.scale, 0, z_viewscore.width - 30.scale, z_viewscore.height))
        z_temp.textColor = "#BFBDBE".color
        z_temp.boldSize = 12
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_viewbutton: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(0, kScreenHeight - 70, kScreenWidth, 70))
        z_temp.backgroundColor = .clear
        return z_temp
    }()
    private lazy var z_btnfollow: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(15.scale, 0, 73.scale, 50.scale))
        z_temp.isHidden = true
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.anchorFollowG.image, for: .normal)
        return z_temp
    }()
    private lazy var z_btnonline: ZUserDetailStatusButton = {
        let z_temp = ZUserDetailStatusButton.init(frame: CGRect.init(97.scale, z_btnfollow.y, 182.scale, 50.scale))
        z_temp.isHidden = true
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        return z_temp
    }()
    private lazy var z_btnmessage: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(288.scale, z_btnfollow.y, 73.scale, 50.scale))
        z_temp.isHidden = true
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.anchorChatG.image, for: .normal)
        return z_temp
    }()
    private lazy var z_viewdetail: ZAnchorsDetailView = {
        let z_temp = ZAnchorsDetailView.init(frame: CGRect.init(0, kScreenHeight, kScreenWidth, kScreenHeight))
        
        return z_temp
    }()
    private let z_viewmodel: ZUserDetailViewModel = ZUserDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.isNavigationHidden = true
        self.view.addSubview(z_viewmain)
        self.view.addSubview(z_viewheader)
        self.view.addSubview(z_viewbutton)
        self.view.bringSubviewToFront(z_viewbutton)
        self.view.bringSubviewToFront(z_viewheader)
        
        z_viewmain.addSubview(z_viewphotos)
        z_viewmain.addSubview(z_viewpage)
        z_viewmain.addSubview(z_viewcontent)
        z_viewmain.addSubview(z_viewdetail)
        z_viewmain.bringSubviewToFront(z_viewpage)
        z_viewmain.bringSubviewToFront(z_viewcontent)
        
        z_viewheader.addSubview(z_btnback)
        z_viewheader.addSubview(z_btnmore)
        
        z_viewcontent.addSubview(z_lbusername)
        z_viewcontent.addSubview(z_imagegender)
        
        z_viewcontent.addSubview(z_viewcountry)
        z_viewcountry.addSubview(z_imagecountry)
        z_viewcountry.addSubview(z_lbcountry)
        
        z_viewcontent.addSubview(z_viewcoins)
        z_viewcoins.addSubview(z_imagecoins)
        z_viewcoins.addSubview(z_lbcoins)
        
        z_viewcontent.addSubview(z_viewscore)
        z_viewscore.addSubview(z_imagescore)
        z_viewscore.addSubview(z_lbscore)
        
        z_viewbutton.addSubview(z_btnfollow)
        z_viewbutton.addSubview(z_btnonline)
        z_viewbutton.addSubview(z_btnmessage)
        if self.z_isCountdown {
            self.view.addSubview(z_viewtime)
            self.view.bringSubviewToFront(z_viewtime)
        }
        func_setupevent()
        func_setupdata()
        z_viewmodel.delegate = self
        let userid = self.z_model?.userid ?? ""
        z_viewmodel.func_requestuserdetail(userid: userid)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.z_isCountdown {
            self.z_currenttime = kMaxMatchWaitTime
            NotificationCenter.default.addObserver(self, selector: "func_ExecuteTimer:", name: Notification.Names.ExecuteTimer, object: nil)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.z_isCountdown {
            NotificationCenter.default.removeObserver(self, name: Notification.Names.ExecuteTimer, object: nil)
        }
    }
    deinit {
        z_viewmodel.delegate = nil
    }
    @objc private func func_ExecuteTimer(_ sender: Notification) {
        if self.z_currenttime < 0 { return }
        self.z_viewtime.isHidden = self.z_currenttime <= 0
        if self.z_isCountdown {
            if self.z_currenttime <= 0 {
                if self.z_isStopCountdown {
                    NotificationCenter.default.removeObserver(self, name: Notification.Names.ExecuteTimer, object: nil)
                    return
                }
                ZRouterKit.pop(fromVC: self)
                return
            }
            self.z_currenttime -= 1
            self.z_viewtime.func_settime(time: z_currenttime)
        }
    }
    private func func_setupevent() {
        z_btnback.addTarget(self, action: "func_btnbackclick", for: .touchUpInside)
        z_btnmore.addTarget(self, action: "func_btnmoreclick", for: .touchUpInside)
        z_btnfollow.addTarget(self, action: "func_btnfollowclick", for: .touchUpInside)
        z_btnonline.addTarget(self, action: "func_btnonlineclick", for: .touchUpInside)
        z_btnmessage.addTarget(self, action: "func_btnmessageclick", for: .touchUpInside)
        
        z_viewphotos.onItemChangeEvent = { row in
            self.z_viewpage.z_pagecurrent = row
        }
        z_viewdetail.z_oncontentheightchange = { height in
            self.z_viewmain.contentSize = CGSize.init(width: self.z_viewmain.width, height: self.z_viewdetail.y + height)
        }
        z_viewdetail.z_onrankmoreclick = {
            let z_tempvc = ZRankIntimateViewController.init()
            z_tempvc.z_modeluser = self.z_model?.copyable()
            ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
        }
    }
    private func func_setupdata() {
        guard let user = self.z_model else { return }
        // 无国籍显示白白
        z_imagecountry.image = user.countrycode.count == 2 ? UIImage.assetImage(named: user.countrycode.uppercased()) : UIImage()
        z_lbcountry.text = user.country
        z_lbusername.text = user.nickname
        z_lbusername.width = z_lbusername.text?.getWidth(z_lbusername.font, height: z_lbusername.height) ?? 10
        z_lbusername.x = kScreenWidth/2 - z_lbusername.width/2
        z_imagegender.x = z_lbusername.x + z_lbusername.width + 15.scale
        z_imagegender.image = user.gender == .male ? Asset.matchMaleP.image : Asset.matchFemaleR.image
        z_lbcoins.text = user.price.str + "/" + ZString.lbMin.text
        z_lbscore.text = user.comment_rating.strDouble
        z_btnonline.z_modeluser = user
        z_viewphotos.arrayImageUrlString = user.photos ?? []
        z_viewpage.z_pagetotal = user.photos?.count ?? 0
        z_viewdetail.z_model = user
        self.func_followchange(follow: user.is_following)
        z_btnonline.isHidden = false
        z_btnfollow.isHidden = user.is_following
        z_btnmessage.isHidden = self.z_isCountdown
    }
    private func func_followchange(follow: Bool) {
        if self.z_isCountdown {
            if follow {
                self.z_btnonline.frame = CGRect.init(kScreenWidth/2 - 265.scale/2, z_btnfollow.y, 265.scale, 50.scale)
            } else {
                self.z_btnonline.frame = CGRect.init(97.scale, z_btnfollow.y, 265.scale, 50.scale)
            }
        } else {
            if follow {
                self.z_btnonline.frame = CGRect.init(15.scale, z_btnfollow.y, 265.scale, 50.scale)
            } else {
                self.z_btnonline.frame = CGRect.init(97.scale, z_btnfollow.y, 182.scale, 50.scale)
            }
        }
        z_btnfollow.isHidden = follow
    }
    @objc private func func_btnbackclick() {
        ZRouterKit.pop(fromVC: self)
    }
    @objc private func func_btnmoreclick() {
        if self.z_model?.is_block == true {
            ZAlertView.showActionSheetView(vc: self, title: nil, message: nil, buttons: [ZString.btnCancelPullBlack.text, ZString.btnReport.text], completeBlock: { row in
                switch row {
                case 0:
                    self.z_viewmodel.func_requestcancelpullblackanchor(userid: self.z_model?.userid ?? "", callback: { [weak self] success, message in
                        guard let `self` = self else { return }
                        self.z_model?.is_block = false
                    })
                case 1:
                    let z_tempvc = ZReportViewController.init()
                    z_tempvc.z_model = self.z_model
                    ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
                default: break
                }
            })
        } else {
            ZAlertView.showActionSheetView(vc: self, title: nil, message: nil, buttons: [ZString.btnPullBlack.text, ZString.btnReport.text], completeBlock: { row in
                switch row {
                case 0:
                    self.z_viewmodel.func_requestpullblackanchor(userid: self.z_model?.userid ?? "", callback: { [weak self] success, message in
                        guard let `self` = self else { return }
                        self.z_model?.is_block = true
                    })
                case 1:
                    let z_tempvc = ZReportViewController.init()
                    z_tempvc.z_model = self.z_model
                    ZRouterKit.push(toVC: z_tempvc, fromVC: self, animated: true)
                default: break
                }
            })
        }
    }
    @objc private func func_btnfollowclick() {
        z_viewmodel.func_requestfollowanchor(userid: self.z_model?.userid ?? "", callback: { [weak self] success, message in
            guard let `self` = self else { return }
            self.func_followchange(follow: success)
        })
    }
    @objc private func func_btnonlineclick() {
        let type = (self.z_isCountdown && !self.z_isStopCountdown) ? 2 : 1
        self.z_viewmodel.func_callanchor(model: self.z_model, type: type, completion: { [weak self] success in
            guard let `self` = self else { return }
            if success {
                self.z_isStopCountdown = true
            }
        })
    }
    @objc private func func_btnmessageclick() {
        NotificationCenter.default.post(name: Notification.Names.ShowChatMessageVC, object: self.z_model)
    }
}
extension ZUserDetailViewController: ZUserDetailViewModelDelegate {
    
    func func_requestdetailsuccess(model: ZModelUserInfo) {
        self.z_model = ZModelUserInfo.init(instance: model)
        self.func_setupdata()
        z_viewmodel.func_requestrankarray(userid: model.userid)
        
        ZSQLiteKit.setModel(model: model)
    }
    func func_requestranksuccess(models: [ZModelUserInfo]?) {
        guard let array = models else { return }
        self.z_model?.ranks = array
        self.func_setupdata()
    }
}
