
import UIKit
import SwiftBasicKit

class ZAnchorsDetailView: UIView {
    
    var z_model: ZModelUserInfo? {
        didSet {
            self.func_anchordetailchange()
        }
    }
    var z_onrankmoreclick: (() -> Void)?
    var z_oncontentheightchange: ((_ height: CGFloat) -> Void)?
    /// aboutme
    private lazy var z_lbaboutme: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(15.scale, kStatusHeight + 20.scale, 300.scale, 20))
        z_temp.boldSize = 18
        z_temp.textColor = "#56565C".color
        z_temp.text = ZString.lbAboutMe.text
        z_temp.isHidden = true
        return z_temp
    }()
    private lazy var z_lbaboutmecontent: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(17.scale, z_lbaboutme.y + z_lbaboutme.height + 10.scale, self.width - 34.scale, 20))
        z_temp.boldSize = 15
        z_temp.textColor = "#FFFFFF".color
        z_temp.text = ZString.lbAboutMe.text
        z_temp.numberOfLines = 0
        z_temp.lineBreakMode = .byCharWrapping
        z_temp.isHidden = true
        return z_temp
    }()
    /// ranks
    private lazy var z_viewranks: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(0, z_lbaboutmecontent.y + z_lbaboutmecontent.height, self.width, 133 + 24))
        z_temp.isHidden = true
        z_temp.backgroundColor = .clear
        return z_temp
    }()
    private lazy var z_lbranks: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(15.scale, 0, 300.scale, 20))
        z_temp.boldSize = 18
        z_temp.textColor = "#56565C".color
        z_temp.text = ZString.lbLntimateLover.text
        return z_temp
    }()
    private lazy var z_btnrankmore: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_viewranks.width - 55, -12.5, 55, 45))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.btnMore.text, for: .normal)
        z_temp.setTitleColor("#56565C".color, for: .normal)
        return z_temp
    }()
    private lazy var z_btnranktop1: ZAnchorsDetailRankButton = {
        let z_temp = ZAnchorsDetailRankButton.init(frame: CGRect.init(17.scale, z_btnrankmore.y + z_btnrankmore.height + 5, 80.scale, 92.scale))
        z_temp.tag = 1
        z_temp.isHidden = true
        return z_temp
    }()
    private lazy var z_btnranktop2: ZAnchorsDetailRankButton = {
        let z_temp = ZAnchorsDetailRankButton.init(frame: CGRect.init(147.scale, z_btnranktop1.y, 80.scale, 92.scale))
        z_temp.tag = 2
        z_temp.isHidden = true
        return z_temp
    }()
    private lazy var z_btnranktop3: ZAnchorsDetailRankButton = {
        let z_temp = ZAnchorsDetailRankButton.init(frame: CGRect.init(280.scale, z_btnranktop1.y, 80.scale, 92.scale))
        z_temp.tag = 3
        z_temp.isHidden = true
        return z_temp
    }()
    /// tags
    private lazy var z_viewtags: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(0, z_lbranks.y + z_lbranks.height + 30.scale, self.width, 60.scale))
        z_temp.isHidden = true
        z_temp.backgroundColor = .clear
        return z_temp
    }()
    private lazy var z_lbtags: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(15.scale, 0, 300.scale, 20))
        z_temp.boldSize = 18
        z_temp.textColor = "#56565C".color
        z_temp.text = ZString.lbTags.text
        return z_temp
    }()
    private lazy var z_viewhobby: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(0, z_viewtags.y + z_viewtags.height + 30.scale, self.width, 220))
        z_temp.isHidden = true
        z_temp.backgroundColor = .clear
        return z_temp
    }()
    private lazy var z_lbmybodytype: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(15.scale, 0, 300.scale, 24))
        z_temp.text = ZString.lbMyBodyType.text
        z_temp.textColor = "#56565C".color
        z_temp.boldSize = 15
        return z_temp
    }()
    private lazy var z_lbmybodytypevalue: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(15.scale, z_lbmybodytype.y + z_lbmybodytype.height + 5.scale, 300.scale, 24))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 15
        return z_temp
    }()
    private lazy var z_lbmyheight: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(15.scale, z_lbmybodytypevalue.y + z_lbmybodytypevalue.height + 20.scale, 300.scale, 24))
        z_temp.text = ZString.lbMyHeight.text
        z_temp.textColor = "#56565C".color
        z_temp.boldSize = 15
        return z_temp
    }()
    private lazy var z_lbmyheightvalue: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(15.scale, z_lbmyheight.y + z_lbmyheight.height + 5.scale, 300.scale, 24))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 15
        return z_temp
    }()
    private lazy var z_lbmyweight: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(15.scale, z_lbmyheightvalue.y + z_lbmyheightvalue.height + 20.scale, 300.scale, 24))
        z_temp.text = ZString.lbMyWeight.text
        z_temp.textColor = "#56565C".color
        z_temp.boldSize = 15
        return z_temp
    }()
    private lazy var z_lbmyweightvalue: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(15.scale, z_lbmyweight.y + z_lbmyweight.height + 5.scale, 300.scale, 24))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 15
        return z_temp
    }()
    private lazy var z_lbmybelong: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(15.scale, z_lbmyweightvalue.y + z_lbmyweightvalue.height + 20.scale, 300.scale, 24))
        z_temp.text = ZString.lbMyBelong.text
        z_temp.textColor = "#56565C".color
        z_temp.boldSize = 15
        return z_temp
    }()
    private lazy var z_lbmybelongvalue: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(15.scale, z_lbmybelong.y + z_lbmybelong.height + 5.scale, 300.scale, 24))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 15
        return z_temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addSubview(z_lbaboutme)
        self.addSubview(z_lbaboutmecontent)
        self.addSubview(z_viewranks)
        self.addSubview(z_viewtags)
        self.addSubview(z_viewhobby)
        
        z_viewranks.addSubview(z_lbranks)
        z_viewranks.addSubview(z_btnrankmore)
        z_viewranks.addSubview(z_btnranktop1)
        z_viewranks.addSubview(z_btnranktop2)
        z_viewranks.addSubview(z_btnranktop3)
        
        z_viewtags.addSubview(z_lbtags)
        
        z_viewhobby.addSubview(z_lbmybodytype)
        z_viewhobby.addSubview(z_lbmybodytypevalue)
        z_viewhobby.addSubview(z_lbmyheight)
        z_viewhobby.addSubview(z_lbmyheightvalue)
        z_viewhobby.addSubview(z_lbmyweight)
        z_viewhobby.addSubview(z_lbmyweightvalue)
        z_viewhobby.addSubview(z_lbmybelong)
        z_viewhobby.addSubview(z_lbmybelongvalue)
        
        for i in 10...19 {
            let z_temp = UILabel.init(frame: CGRect.init(0, z_lbtags.y + z_lbtags.height + 10.scale, 0, 30))
            z_temp.tag = i
            z_temp.isHidden = true
            z_temp.backgroundColor = "#493443".color
            z_temp.textColor = "#BFBDBE".color
            z_temp.boldSize = 15
            z_temp.textAlignment = .center
            z_temp.border(color: .clear, radius: 15, width: 0)
            z_viewtags.addSubview(z_temp)
        }
        z_btnrankmore.addTarget(self, action: "func_btnrankmoreclick", for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func func_anchordetailchange() {
        guard let user = self.z_model else {
            return
        }
        z_lbaboutme.isHidden = false
        z_lbaboutmecontent.isHidden = false
        
        z_lbaboutmecontent.text = user.introduction
        z_lbaboutmecontent.height = user.introduction.getHeight(z_lbaboutmecontent.font, width: z_lbaboutmecontent.width)
        
        z_viewranks.y = z_lbaboutmecontent.y + z_lbaboutmecontent.height + 30.scale
        // 处理视频秀 TODO: 现在没有视频秀，这里预留空位
        
        // 处理排行榜
        if let ranks = user.ranks {
            z_viewranks.isHidden = false
            z_btnranktop1.isHidden = true
            z_btnranktop2.isHidden = true
            z_btnranktop3.isHidden = true
            var i: Int = 0
            for user in ranks {
                switch i {
                case 0:
                    z_btnranktop1.isHidden = false
                    z_btnranktop1.z_model = ZModelUserInfo.init(instance: user)
                case 1:
                    z_btnranktop2.isHidden = false
                    z_btnranktop2.z_model = ZModelUserInfo.init(instance: user)
                case 2:
                    z_btnranktop3.isHidden = false
                    z_btnranktop3.z_model = ZModelUserInfo.init(instance: user)
                default: break
                }
                i += 1
            }
            z_viewtags.y = z_viewranks.y + z_viewranks.height
        } else {
            z_viewranks.isHidden = true
            z_viewtags.y = z_viewranks.y
        }
        // 处理标签
        if let tags = user.tags {
            z_viewtags.isHidden = false
            let maxw = z_viewtags.width - 30.scale
            var lbx = 15.scale
            var lby = z_lbtags.y + z_lbtags.height + 10.scale
            let lbh: CGFloat = 30
            for (i, lb) in z_viewtags.subviews.enumerated() {
                if lb.tag >= 10 {
                    if tags.count >= i {
                        let tag = tags[i-1]
                        lb.isHidden = false
                        (lb as? UILabel)?.text = tag.tagname
                        var font = UIFont.boldSystemFont(15)
                        let lbw = tag.tagname.getWidth(font, height: 30) + 40
                        if (lbx + lbw) > maxw {
                            lbx = 15.scale
                            lby = lby + lbh + 10
                        }
                        lb.frame = CGRect.init(x: lbx, y: lby, width: lbw, height: lbh)
                        lbx = lbx + lbw + 15.scale
                    } else {
                        lb.isHidden = true
                        lb.frame = CGRect.init(x: lbx, y: lby, width: 0, height: lbh)
                    }
                }
            }
            z_viewtags.height = lby + lbh + 30.scale
        } else {
            z_viewtags.isHidden = true
            z_viewtags.height = 0
        }
        z_viewhobby.y = z_viewtags.y + z_viewtags.height
        // 处理身体特征
        if user.bodytype.count > 0 || user.height.count > 0 || user.weight.count > 0 || user.belong.count > 0 {
            z_viewhobby.isHidden = false
            z_lbmybodytypevalue.text = user.bodytype
            z_lbmyheightvalue.text = user.height + "cm"
            z_lbmybelongvalue.text = user.belong
            z_lbmyweightvalue.text = user.weight + "kg"
            self.height = z_viewhobby.y + z_viewhobby.height + 100.scale
        } else {
            z_viewhobby.isHidden = true
            self.height = z_viewhobby.y + 70.scale
        }
        self.z_oncontentheightchange?(self.height)
    }
    @objc private func func_btnrankmoreclick() {
        self.z_onrankmoreclick?()
    }
}
