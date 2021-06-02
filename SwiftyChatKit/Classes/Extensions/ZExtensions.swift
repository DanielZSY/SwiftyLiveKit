
import UIKit
import AVKit
import Foundation
import SwiftBasicKit

extension Bundle {
    static var chatAssetBundle: Bundle {
        guard let url = Bundle(for: ZZBaseViewController.self).url(forResource: "SwiftyChatKit", withExtension: "bundle"),
              let resourcesBundle = Bundle(url: url)
        else {
            return Bundle.main
        }
        return resourcesBundle
    }
    static var resourcesAssetBundle: Bundle {
        guard let url = Bundle(for: ZZBaseViewController.self).url(forResource: "SwiftyChatResourcesKit", withExtension: "bundle"),
              let resourcesBundle = Bundle(url: url)
        else {
            return Bundle.main
        }
        return resourcesBundle
    }
    static var videoAssetBundle: Bundle {
        guard let url = Bundle(for: ZZBaseViewController.self).url(forResource: "SwiftyChatVideoKit", withExtension: "bundle"),
              let resourcesBundle = Bundle(url: url)
        else {
            return Bundle.main
        }
        return resourcesBundle
    }
    static var callAssetBundle: Bundle {
        guard let url = Bundle(for: ZZBaseViewController.self).url(forResource: "SwiftyChatCallKit", withExtension: "bundle"),
              let resourcesBundle = Bundle(url: url)
        else {
            return Bundle.main
        }
        return resourcesBundle
    }
}
extension URL {
    static func callUrl(named: String) -> URL? {
        return Bundle.callAssetBundle.url(forResource: "Call", withExtension: "bundle")?.appendingPathComponent(named).appendingPathExtension("mp3")
    }
    static func loginBGUrl(named: String) -> URL? {
        return Bundle.videoAssetBundle.url(forResource: "Video", withExtension: "bundle")?.appendingPathComponent(named).appendingPathExtension("mp4")
    }
    static func resourceUrl(named: String) -> URL? {
        return Bundle.resourcesAssetBundle.url(forResource: "Resources", withExtension: "bundle")?.appendingPathComponent(named)
    }
}
extension UIImage {
    var down: UIImage? {
        if let cgimage = self.cgImage {
            return UIImage.init(cgImage: cgimage, scale: 1, orientation: UIImage.Orientation.down)
        }
        return self
    }
    static func assetImage(named: String) -> UIImage? {
        let image = UIImage(named: named, in: Bundle.chatAssetBundle, compatibleWith: nil)
        if image == nil {
            return UIImage.init(named: named)
        }
        return image
    }
}
extension UIButton {
    func customStyle() {
        self.adjustsImageWhenHighlighted = false
        self.setTitleColor("#FFF5F5".color, for: .normal)
        self.titleLabel?.boldSize = 15
        self.backgroundColor = "#7037E9".color
        self.border(color: .clear, radius: self.height/2, width: 0)
    }
}
extension TimeInterval {
    /// 秒转换倒计时时间格式
    var strTime: String {
        let allTime: Int = Int(self)
        var hours = 0
        var minutes = 0
        var seconds = 0
        var hoursText = ""
        var minutesText = ""
        var secondsText = ""
        
        hours = allTime / 3600
        hoursText = hours > 9 ? "\(hours)" : "0\(hours)"
        
        minutes = allTime % 3600 / 60
        minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        seconds = allTime % 3600 % 60
        secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        if hoursText == "00" {
            return "\(minutesText):\(secondsText)"
        }
        return "\(hoursText):\(minutesText):\(secondsText)"
    }
    /// 消息列表时间格式
    var strMessageTime: String {
        // 获取当前的时间戳
        let currentTime = Date().timeIntervalSince1970
        // 时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
        let timeSta: TimeInterval = TimeInterval(self)
        // 时间差
        let reduceTime : TimeInterval = currentTime - timeSta
        // 时间差小于60秒
        if reduceTime < 60 { return ZString.lbJustnow.text }
        // 时间差大于一分钟小于60分钟内
        let mins = Int(reduceTime / 60)
        if mins < 60 { return "\(mins) " + ZString.lbMinutesago.text }
        let hours = Int(reduceTime / 3600)
        if hours < 24 { return "\(hours) " + ZString.lbHoursago.text }
        //let days = Int(reduceTime / 3600 / 24)
        //if days < 30 { return "\(days)" + ZString.lbDaysago.text}
        return self.toFormat()
    }
    func toFormat(format: String = ZKey.timeFormat.yyyyMMddHHmm) -> String {
        if self == 0 { return "" }
        let date = Date.init(timeIntervalSince1970: (self))
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = format
        dfmatter.locale = Locale.current
        dfmatter.timeZone = TimeZone.current
        return dfmatter.string(from: date)
    }
}
extension Int64 {
    var strTime: String {
        return TimeInterval(self).strTime
    }
}
extension Float {
    var strTime: String {
        return TimeInterval(self).strTime
    }
}
extension Int {
    var strTime: String {
        return TimeInterval(self).strTime
    }
}
extension UIView {
    var isVideoVCing: Bool {
        if let currentVC = ZRouterKit.getCurrentVC(), let callVC = NSClassFromString("ZCallViewController"), currentVC.isMember(of: callVC) {
            return true
        }
        if let currentVC = ZRouterKit.getCurrentVC(), let callVC = NSClassFromString("ZVideoViewController"), currentVC.isMember(of: callVC) {
            return true
        }
        return false
    }
    func onlineColor(online: Bool, busy: Bool) {
        switch online {
        case true:
            switch busy {
            case true:
                self.backgroundColor = "#FECA19".color
            case false:
                self.backgroundColor = "#7037E9".color
            default: break
            }
        case false:
            self.backgroundColor = "#7F7F7F".color
        default: break
        }
    }
}
extension UIImageView {
    func onlineImage(online: Bool, busy: Bool) {
        switch online {
        case true:
            switch busy {
            case true:
                self.image = Asset.btnBusy.image
            case false:
                self.image = Asset.btnOnline.image
            default: break
            }
        case false:
            self.image = Asset.btnOffline.image
        default: break
        }
    }
}
