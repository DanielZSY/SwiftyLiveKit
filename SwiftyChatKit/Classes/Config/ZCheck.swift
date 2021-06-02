
import UIKit
import SwiftBasicKit

class ZCheck: NSObject {
    /// 设备是否越狱
    static func func_isjailbreak() -> Bool {
        if let url = URL.init(string: "cydia://"), UIApplication.shared.canOpenURL(url) { return true }
        if FileManager.default.fileExists(atPath: "User/Applications/") { return true }
        var paths = ["/Applications/Cydia.app",
                     "/Library/MobileSubstrate/MobileSubstrate.dylib",
                     "/bin/bash",
                     "/usr/sbin/sshd",
                     "/etc/apt"]
        for path in paths { if FileManager.default.fileExists(atPath: path) { return true } }
        return false
    }
}
