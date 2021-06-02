
import UIKit
import BFKit
import SwiftDate
import SVGAPlayer
import SwiftBasicKit

/// 首次礼包按钮
class ZFirstPackageButton: UIButton {

    private let timeCountdown = ZTimeCountdown()
    private lazy var z_player: SVGAPlayer = {
        let z_temp = SVGAPlayer.init(frame: CGRect.init(0, 0, self.width, self.height))
        z_temp.isUserInteractionEnabled = false
        z_temp.clearsAfterStop = true
        return z_temp
    }()
    private lazy var z_parser: SVGAParser = {
        let z_temp = SVGAParser.init()
        return z_temp
    }()
    private lazy var z_imagetimebg: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(0, self.height - 18, self.width, 18))
        z_temp.image = Asset.comFirstTime.image
        return z_temp
    }()
    private lazy var z_imagetime: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(5, 4, 10, 10))
        z_temp.image = Asset.comTime.image
        return z_temp
    }()
    private lazy var z_lbtime: UILabel = {
        let timex = z_imagetime.x + z_imagetime.width + 3
        let z_temp = UILabel.init(frame: CGRect.init(timex, 0, z_imagetimebg.width - timex - 3, z_imagetimebg.height))
        z_temp.boldSize = 9
        z_temp.textAlignment = .center
        z_temp.text = "00:00:00"
        z_temp.textColor = "#FFFFFF".color
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_player)
        self.addSubview(z_imagetimebg)
        self.bringSubviewToFront(z_imagetimebg)
        
        z_imagetimebg.addSubview(z_imagetime)
        z_imagetimebg.addSubview(z_lbtime)
        
        timeCountdown.onZTimeCountdownBlock = { [weak self] day, hour, minute, second in
            self?.z_lbtime.text = "\(hour):\(minute):\(second)"
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    deinit {
        self.timeCountdown.onZTimeCountdownBlock = nil
        self.timeCountdown.stop()
        self.z_player.stopAnimation()
    }
    final func startAnimation() {
        z_parser.parse(with: Asset.svgaFirstPack.data.data, cacheKey: "svgaFirstPack".md5(), completionBlock: { videoItem in
            self.z_player.videoItem = videoItem
            self.z_player.startAnimation()
        }, failureBlock: { error in
            BFLog.debug("load svga error: \(error.localizedDescription)")
        })
    }
    final func stopAnimation() {
        self.timeCountdown.stop()
        self.z_player.stopAnimation()
    }
    final func setFirstTime(time: TimeInterval) {
        let starttime = Date.init(timeIntervalSince1970: time)
        let endtime = Date.init(timeIntervalSince1970: time + 24*60*60)
        BFLog.debug("starttime: \(starttime),  endtime: \(endtime)")
        timeCountdown.start(with: starttime.toFormat(ZKey.timeFormat.yyyyMMddHHmmss), end: endtime.toFormat(ZKey.timeFormat.yyyyMMddHHmmss))
    }
}
