
import BFKit

/// 本地化配置文件
internal enum ZString: String {
    case btnDone
    case btnNext
    case btnSave
    case btnStart
    case btnSignIn
    case btnSignUp
    case btnSignOut
    case btnContinue
    case btnStartChatting
    case btnHot
    case btnNew
    case btnCallNow
    case btnComplete
    case btnMore
    case btnCancel
    case btnYesreport
    case btnReport
    case btnClaim
    case btnDownload
    case btnNothanks
    case btnComplaint
    case btnAlbum
    case btnCamera
    case btnFollow
    case btnPullBlack
    case btnCancelPullBlack
    case btnSubmit
    case btnDelete
    
    case lbNoData
    case lbAvatar
    case lbSetavatar
    case lbMoveUp
    case lbMoveDown
    case lbSelectPhoto
    /// 登录页面标题
    case lbLoginTitle
    /// 登录页面描述
    case lbLoginDesc
    case lbYourName
    case lbYourEMail
    case lbYourPassword
    case lbYourBirthday
    case lbYourPhoto
    case lbUserName
    case lbPassword
    case lbEMail
    case lbIAM
    case lbMale
    case lbFemale
    case lbBoth
    /// 在线人数描述内容
    case lbPeopleAreOnline
    /// 匹配类型选择 描述文案
    case lbMatchTypeTitle
    case lbMyCoins
    case lbLooking
    /// 匹配等待页面描述
    case lbLookDesc
    case lbMin
    case lbBusy
    case lbOnline
    case lbOffline
    /// 余额不足
    case lbInsufficientBalance
    /// 完成个人信息的 描述文案
    case lbCompleteYourProfile
    case lbAboutMe
    case lbAboutMePlaceholder
    case lbVideoShow
    case lbLntimateLover
    case lbTags
    case lbMyBodyType
    case lbMyHeight
    case lbMyBelong
    case lbMyWeight
    case lbHeight
    case lbWeight
    case lbBelong
    case lbBodytype
    case lbBirthday
    case lbAnchor
    case lbGold
    case lbGift
    case lbLover
    case lbWeek
    case lbDay
    case lbMonth
    case lbSaySomething
    /// 向上滑动取消发送
    case lbSwipeuptocancelsending
    /// 松手取消发送
    case lbLetgotocancelsending
    /// 按住录制音频
    case lbHoldtorecord
    /// 视频记录
    case lbConversationhistory
    case lbMessages
    /// 未开启推送的 描述文案
    case lbAllowPushNotification
    case lbID
    /// 隐私开关标题
    case lbIncognitomode
    /// 隐私开关 描述文案
    case lbIncognitomodeDesc
    case lbEditProfile
    case lbEditProfilePhotos
    case lbExpensesrecord
    case lbFellow
    case lbBlacklist
    case lbSettings
    case lbFollowing
    case lbFollowers
    case lbStore
    case lbRecharge
    case lbNoFollowing
    case lbNoFollowers
    /// 无关注数据 描述文案
    case lbNofollowDesc
    case lbAddAPhoto
    case lbMorePhoto
    case lbCall
    case lbCallNow
    case lbRatings
    case lbCalltimejust
    case lbSystemrewards
    case lbReport
    case lbNewUserGift
    case lbFreeofCharge
    case lbDiscount
    /// 推荐主播标题 描述文案
    case lbRecommendedAnchorTitle
    /// 推荐主播描述内容
    case lbRecommendedAnchorDesc
    /// 评价差的输入框提示文案
    case lbEvaluationPoorlyratedinputprompt
    /// 评价好的输入框提示文案
    case lbEvaluationofgoodinputprompt
    case lbNot
    case lbVerybad
    case lbBad
    case lbGeneral
    case lbGood
    case lbVeryGood
    case lbAddtags
    case lbTime
    case lbDiamonds
    case lbRating
    case lbEvaluation
    case lbRechargenow
    case lbGifts
    case lbPleaserechargenowtokeepthecallgoing
    case lbYouhave1minleft
    case lbYouhave30secondsleft
    case lbTypesomething
    case lbDeleteaccount
    case lbClearCache
    case lbFeedback
    case lbRateusinAppStore
    case lbTermsofService
    case lbShowLocation
    case lbVersion
    case lbExpensesRecordSearchPlaceholder
    case lbFeedbackPlaceholder
    case lbReportPlaceholder
    case lbBestOffer
    case lbOFF
    /// 余额没到账 描述文案
    case lbDiamondsnotreceived
    /// 刚刚
    case lbJustnow
    /// 分钟前
    case lbMinutesago
    /// 小时前
    case lbHoursago
    /// 天前
    case lbDaysago
    case lbNoFollow
    case lbNoFollowDesc
    case lbFreeTitle
    case lbFreeDesc
    case lbFirstDiscount
    case lbDownloadTips
    
    /// 拉黑成功
    case successBlack
    /// 关注成功
    case successFollow
    /// 充值成功，到账可能会有延迟
    case successRecharge
    /// 充值失败
    case faildRecharge
    
    /// 上传照片无脸识别错误描述文案
    case errorUploadPhotoPrompt
    /// 请选择您的出生年月日
    case errorBirthdatePrompt
    /// 请选择一张照片
    case errorSelectPhotoPrompt
    /// 请输入正确的电子邮箱格式
    case errorEmailPrompt
    /// 请输入3-30字符的用户昵称
    case errorUsernamePrompt
    /// 请输入6-20字符或数字或特殊字符的密码
    case errorPasswordPrompt
    /// 无摄像头设备提示
    case errorDeviceNotCameraPrompt
    
    /// 确定举报当前用户吗?
    case alertDoyouwanttoreportthisuser
    /// 确定删除当前帐号吗？
    case alertAreyousuretodeletethecurrentaccount
    /// 确定注销当前帐号吗？
    case alertAreyousuretologoutofthecurrentaccount
    /// 确定清空当前缓存吗？
    case alertAreyousuretoclearthecurrentcache
    /// 确定删除当前选择照片吗？
    case alertAreyousuredeletecurrentselectedphoto
    /// 用户信息更新成功
    case alertUserinfoupdatesuccessfully
    /// 用户相册更新成功
    case alertUserPhotosupdatesuccessfully
    /// 确定不保存已更改信息?
    case alertMakesurenotsavechangeduserinfo
    /// 请先保存已更改的信息?
    case alertPleasesavethechangedinfofirst
    /// 请先保存已更改的头像
    case alertPleasesavethechangephotos
    /// 照片最多只能上传9张
    case alertUploadphotossmaxcount
    /// 相册至少保留一张照片
    case alertDeleteuserphotosoneleast
    /// 确定取消关注当前用户？
    case alertAreyousureunfollowcurrentuser
    /// 确定取消拉黑当前用户？
    case alertAreyousureunblockcurrentuser
    /// 感谢您反馈的意见。我们会尽量满足每一位顾客的需求
    case alertFeedbackSuccessPrompt
    /// 举报成功，我们会尽快核实并处理您的举报
    case alertReportSuccessPrompt
    /// 绑定邮箱成功提示
    case alertBindAccountSuccess
    
    internal var text: String {
        let language = Locale.preferredLanguages.first?.components(separatedBy: "-").first ?? ""
        switch language {
        default:
            switch self {
            case .btnDone: return "Done"
            case .btnNext: return "Next"
            case .btnSave: return "Save"
            case .btnStart: return "Start"
            case .btnSignIn: return "Sign In"
            case .btnSignUp: return "Sign Up"
            case .btnSignOut: return "Sign out"
            case .btnContinue: return "Continue"
            case .btnStartChatting: return "Start Chatting"
            case .btnHot: return "Hot"
            case .btnNew: return "New"
            case .btnCallNow: return "Call Now"
            case .btnComplete: return "Complete"
            case .btnMore: return "More"
            case .btnCancel: return "Cancel"
            case .btnYesreport: return "Yes,report"
            case .btnReport: return "Report"
            case .btnClaim : return "Claim"
            case .btnDownload: return "Download"
            case .btnNothanks: return "No,thanks"
            case .btnComplaint: return "Complaint"
            case .btnAlbum: return "Album"
            case .btnCamera: return "Camera"
            case .btnFollow: return "Follow"
            case .btnPullBlack: return "Pull black"
            case .btnCancelPullBlack: return "Cancel pull black"
            case .btnSubmit: return "Submit"
            case .btnDelete: return "Delete"
                
            case .lbNoData: return "No Data"
            case .lbAvatar: return "Avatar"
            case .lbSetavatar: return "Set avatar"
            case .lbMoveUp: return "Move up"
            case .lbMoveDown: return "Move down"
            case .lbSelectPhoto: return "Select a photo"
            case .lbLoginTitle: return "WHO’S YOUR NEXT FLING?"
            case .lbLoginDesc: return " you can make video calls with strangers from all around the world~!"
            case .lbYourName: return "Your \nName"
            case .lbYourEMail: return "Your \nEmail"
            case .lbYourPassword: return "Your \nPassword"
            case .lbYourBirthday: return "Your \nBirthday"
            case .lbYourPhoto: return "Your \nPhoto"
            case .lbUserName: return "User name"
            case .lbPassword: return "Password"
            case .lbEMail: return "Email"
            case .lbIAM: return "I am "
            case .lbMale: return "Male"
            case .lbFemale: return "Female"
            case .lbBoth: return "Both"
            case .lbPeopleAreOnline: return "People are online"
            case .lbMatchTypeTitle: return "Who do you want to talk to?"
            case .lbMyCoins: return "My Coins"
            case .lbLooking: return "Looking for..."
            case .lbLookDesc: return "Find someone you like have a good time time"
            case .lbMin: return "min"
            case .lbBusy: return "Busy"
            case .lbOnline: return "Online"
            case .lbOffline: return "Offline"
            case .lbInsufficientBalance: return "Insufficient diamonds, go and purchase some!"
            case .lbCompleteYourProfile: return "Complete your profile for better experience! "
            case .lbAboutMe: return "About me"
            case .lbAboutMePlaceholder: return "About me, the limit is less than 200 characters"
            case .lbVideoShow: return "Video show"
            case .lbLntimateLover: return "Lntimate lover"
            case .lbTags: return "Tags"
            case .lbMyBodyType: return "My Bbody type"
            case .lbMyHeight: return "My Height"
            case .lbMyBelong: return "My Belong"
            case .lbMyWeight: return "My Weight"
            case .lbHeight: return "Height"
            case .lbWeight: return "Weight"
            case .lbBelong: return "Belong"
            case .lbBodytype: return "Body type"
            case .lbBirthday: return "Birthday"
            case .lbAnchor: return "Anchor"
            case .lbGold: return "Gold"
            case .lbGift: return "Gift"
            case .lbLover: return "Lover"
            case .lbWeek: return "Week"
            case .lbDay: return "Day"
            case .lbMonth: return "Month"
            case .lbSaySomething: return "Say something ..."
            case .lbSwipeuptocancelsending: return "Swipe up to cancel sending"
            case .lbHoldtorecord: return "Hold to record"
            case .lbLetgotocancelsending: return "Let go to cancel sending"
            case .lbConversationhistory: return "Conversation history"
            case .lbMessages: return "Messages"
            case .lbAllowPushNotification: return "Allow the push notification and check messages in time."
            case .lbID: return "ID"
            case .lbIncognitomode: return "Incognito mode"
            case .lbIncognitomodeDesc: return "Others can't see your info in Gold and Lover Chart."
            case .lbEditProfile: return "Edit Profile"
            case .lbEditProfilePhotos: return "Edit Photos"
            case .lbExpensesrecord: return "Expenses record"
            case .lbFellow: return "Fellow"
            case .lbBlacklist: return "Blacklist"
            case .lbSettings: return "Settings"
            case .lbFollowing: return "Following"
            case .lbFollowers: return "Followers"
            case .lbStore: return "Store"
            case .lbRecharge: return "Recharge"
            case .lbNoFollowing: return "No Following"
            case .lbNoFollowers: return "No Followers"
            case .lbNofollowDesc: return "Pay attention to more users immediately"
            case .lbAddAPhoto: return "Add a Photo"
            case .lbMorePhoto: return "More Photos"
            case .lbCall: return "Call"
            case .lbCallNow: return "Call Now"
            case .lbRatings: return "Ratings"
            case .lbCalltimejust: return "Call time just"
            case .lbSystemrewards: return "System rewards"
            case .lbReport: return "report"
            case .lbNewUserGift: return "New User Gift"
            case .lbFreeofCharge: return "Free of Charge"
            case .lbDiscount: return "Discount"
            case .lbRecommendedAnchorTitle: return "Sorry,the anchor failed to answer your video call"
            case .lbRecommendedAnchorDesc: return "You may also like..."
            case .lbEvaluationPoorlyratedinputprompt: return "Tell us about your problem and we will try our best to optimize it"
            case .lbEvaluationofgoodinputprompt: return "Leave a nice comment if you like her! She will see it! "
            case .lbNot: return "Not"
            case .lbVerybad: return "Very bad"
            case .lbBad: return "Bad"
            case .lbGeneral: return "General"
            case .lbGood: return "Good"
            case .lbVeryGood: return "Very Good"
            case .lbAddtags: return "Add tags"
            case .lbTime: return "Time"
            case .lbDiamonds: return "Diamonds"
            case .lbRating: return "Rating"
            case .lbEvaluation: return "Evaluation"
            case .lbRechargenow: return "Recharge now"
            case .lbGifts: return "Gifts"
            case .lbPleaserechargenowtokeepthecallgoing: return "Please recharge now to keep the call going."
            case .lbYouhave1minleft: return "You have 1 min left."
            case .lbYouhave30secondsleft: return "You have 30 seconds left."
            case .lbTypesomething: return "Type something..."
            case .lbDeleteaccount: return "Delete account"
            case .lbClearCache: return "Clear Cache"
            case .lbFeedback: return "Feedback"
            case .lbRateusinAppStore: return "Rate us in AppStore"
            case .lbTermsofService: return "Terms of Service"
            case .lbShowLocation: return "Show Location"
            case .lbVersion: return "Version"
            case .lbExpensesRecordSearchPlaceholder: return "Search: anchor nickname"
            case .lbFeedbackPlaceholder: return "Please enter the feedback content of 10-200 characters"
            case .lbReportPlaceholder: return "Please enter the report content of 10-200 characters"
            case .lbBestOffer: return "Best Offer"
            case .lbOFF: return "OFF"
            case .lbDiamondsnotreceived: return "Diamonds not received "
            case .lbJustnow: return "Just now"
            case .lbMinutesago: return "minutes ago"
            case .lbHoursago: return "hours ago"
            case .lbDaysago: return "days ago"
            case .lbNoFollow: return "No  follow"
            case .lbNoFollowDesc: return "Pay attention to more users immediately"
            case .lbFreeTitle: return "New User Gift"
            case .lbFreeDesc: return "Free of Charge"
            case .lbFirstDiscount: return "Discount"
            case .lbDownloadTips: return "Sorry that this version will no longer be usable"
                
            case .successBlack: return "Black is successful"
            case .successFollow: return "Following is successful"
            case .successRecharge: return "Recharge is successful, there may be a delay in the account"
            case .faildRecharge: return "Recharge failed, please check your information"
                
            case .errorUploadPhotoPrompt: return "Unable to recognize you face"
            case .errorBirthdatePrompt: return "Please select your birth date"
            case .errorSelectPhotoPrompt: return "Please select your a photo"
            case .errorEmailPrompt: return "Please enter the correct email address"
            case .errorUsernamePrompt: return "Please enter a user nickname of 3-30 characters"
            case .errorPasswordPrompt: return "Please enter a password with 6-20 letters or numbers or special characters"
            case .errorDeviceNotCameraPrompt: return "The device does not support the camera"
                
            case .alertDoyouwanttoreportthisuser: return "Do you want to report this user"
            case .alertAreyousuretodeletethecurrentaccount: return "Are you sure to delete the current account?"
            case .alertAreyousuretologoutofthecurrentaccount: return "Are you sure to log out of the current account?"
            case .alertAreyousuretoclearthecurrentcache: return "Are you sure to clear the current cache?"
            case .alertAreyousuredeletecurrentselectedphoto: return "Are you sure to delete the currently selected photo?"
            case .alertUserinfoupdatesuccessfully: return "User info update successfully"
            case .alertUserPhotosupdatesuccessfully: return "User avatars update successfully"
            case .alertMakesurenotsavechangeduserinfo: return "Make sure not to save the changed user info?"
            case .alertPleasesavethechangedinfofirst: return "Please save the changed information first?"
            case .alertPleasesavethechangephotos: return "Please save the changed avatars first?"
            case .alertUploadphotossmaxcount: return "Only up to 9 avatars can be uploaded"
            case .alertDeleteuserphotosoneleast: return "Keep at least one photo in the album"
            case .alertAreyousureunfollowcurrentuser: return "Are you sure to unfollow the current user?"
            case .alertAreyousureunblockcurrentuser: return "Are you sure to unblock the current user?"
            case .alertFeedbackSuccessPrompt: return "Thank you for your feedback. We will try our best to meet the needs of every customer"
            case .alertReportSuccessPrompt: return "The report is successful, we will verify and process your report as soon as possible"
            case .alertBindAccountSuccess: return "Account successfully bind"
            default: break
            }
        }
        return self.rawValue
    }
}



