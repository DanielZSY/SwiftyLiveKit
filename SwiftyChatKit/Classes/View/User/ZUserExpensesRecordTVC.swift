
import UIKit
import SwiftBasicKit

enum ZUserExpensesRecordType: Int {
    case other = 0
    case recharge = 1
    case call = 2
}
class ZUserExpensesRecordTVC: ZBaseTVC {
    
    var z_model: ZModelExpensesRecord? {
        didSet {
            cellHeight = 90
            guard let model = z_model else { return }
            z_lbtitle.text = model.biz_name
            z_lbtime.text = model.occurred_on.strFormat()
            // 0: 其他 1:充值 2:通话 3:消息 9:提现 4: 活动 5:任务
            switch model.biz_code {
            case 1:
                z_lbtitlecall.isHidden = true
                z_lbtitlegift.isHidden = true
                z_lbtitlegiftprice.isHidden = true
                z_lbtitleratings.isHidden = true
                z_lbtitleratingsvalue.isHidden = true
                //z_btneditratingsbg.isHidden = true
                z_lbtitle.textColor = "#1DA229".color
                z_lbprice.text = "+" + model.amount.str
            case 2:
                cellHeight = 145
                z_lbtitlecall.isHidden = false
                z_lbtitlegift.isHidden = false
                z_lbtitlegiftprice.isHidden = false
                z_lbtitleratings.isHidden = false
                z_lbtitleratingsvalue.isHidden = false
                //z_btneditratingsbg.isHidden = true
                z_lbtitle.textColor = "#7037E9".color
                z_lbprice.text = "-" + model.biz_call_token.str
                z_lbtitlegiftprice.text = "-" + model.biz_gift_token.str
                // 评级: 1,2,3,4,5, 无此字段代表未评
                switch model.biz_comment_rating {
                case 1:
                    z_lbtitleratingsvalue.text = ZString.lbVerybad.text
                case 2:
                    z_lbtitleratingsvalue.text = ZString.lbBad.text
                case 3:
                    z_lbtitleratingsvalue.text = ZString.lbGeneral.text
                case 4:
                    z_lbtitleratingsvalue.text = ZString.lbGood.text
                case 5:
                    z_lbtitleratingsvalue.text = ZString.lbVeryGood.text
                default:
                    z_lbtitleratingsvalue.text = ZString.lbNot.text
                }
            default:
                z_lbtitlecall.isHidden = true
                z_lbtitlegift.isHidden = true
                z_lbtitlegiftprice.isHidden = true
                z_lbtitleratings.isHidden = true
                z_lbtitleratingsvalue.isHidden = true
                //z_btneditratingsbg.isHidden = true
                z_lbtitle.textColor = "#FFFFFF".color
                if model.amount > 0 {
                    z_lbprice.text = "+" + model.amount.str
                } else {
                    z_lbprice.text = model.amount.str
                }
            }
            z_viewcontent.height = cellHeight - z_viewcontent.y
        }
    }
    var z_onbtncommentratingsclick: ((_ model: ZModelExpensesRecord?) -> Void)?
    
    private lazy var z_viewcontent: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(0, 2.scale, cellWidth, self.cellHeight))
        z_temp.backgroundColor = "#1E1925".color
        return z_temp
    }()
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(16.scale, 15.scale, 260.scale, 30))
        z_temp.boldSize = 24
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_lbtime: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(self.cellWidth - 116.scale, 10.scale, 100.scale, 20))
        z_temp.boldSize = 14
        z_temp.textAlignment = .right
        z_temp.adjustsFontSizeToFitWidth = true
        z_temp.textColor = "#515158".color
        return z_temp
    }()
    private lazy var z_lbprice: ZBalanceButton = {
        let z_temp = ZBalanceButton.init(frame: CGRect.init(self.cellWidth - 112.scale, z_lbtime.y + z_lbtime.height + 20.scale, 100.scale, 28))
        return z_temp
    }()
    private lazy var z_lbtitlecall: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(16.scale, z_lbprice.y, 200.scale, 28))
        z_temp.isHidden = true
        z_temp.text = ZString.lbCalltimejust.text
        z_temp.fontSize = 14
        z_temp.adjustsFontSizeToFitWidth = true
        z_temp.textColor = "#FFFFFF".color
        return z_temp
    }()
    private lazy var z_lbtitlegift: UILabel = {    
        let z_temp = UILabel.init(frame: CGRect.init(16.scale, z_lbtitlecall.y + z_lbtitlecall.height, 200.scale, 28))
        z_temp.isHidden = true
        z_temp.text = ZString.lbGift.text
        z_temp.fontSize = 14
        z_temp.adjustsFontSizeToFitWidth = true
        z_temp.textColor = "#FFFFFF".color
        return z_temp
    }()
    private lazy var z_lbtitleratings: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(16.scale, z_lbtitlegift.y + z_lbtitlegift.height, 200.scale, 28))
        z_temp.isHidden = true
        z_temp.text = ZString.lbRatings.text
        z_temp.fontSize = 14
        z_temp.adjustsFontSizeToFitWidth = true
        z_temp.textColor = "#FFFFFF".color
        return z_temp
    }()
    private lazy var z_lbtitlegiftprice: ZBalanceButton = {
        let z_temp = ZBalanceButton.init(frame: CGRect.init(z_lbprice.x, z_lbtitlegift.y, 100.scale, z_lbtitlegift.height))
        z_temp.isHidden = true
        return z_temp
    }()
    private lazy var z_lbtitleratingsvalue: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_lbprice.x, z_lbtitleratings.y, 100.scale, z_lbtitleratings.height))
        z_temp.isHidden = true
        z_temp.boldSize = 14
        z_temp.textAlignment = .right
        z_temp.adjustsFontSizeToFitWidth = true
        z_temp.textColor = "#FFFFFF".color
        return z_temp
    }()
    private lazy var z_btneditratings: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(11.scale, z_btneditratingsbg.height/2 - 10.scale, 33.scale, 20.scale))
        z_temp.isUserInteractionEnabled = false
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.userEdit.image, for: .normal)
        z_temp.backgroundColor = "#7037E9".color
        z_temp.border(color: .clear, radius: 10.scale, width: 0)
        return z_temp
    }()
    private lazy var z_btneditratingsbg: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(self.cellWidth - 54.scale, z_lbtitleratingsvalue.y - 5, 54.scale, 38))
        z_temp.isHidden = true
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        return z_temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(z_viewcontent)
        
        self.z_viewcontent.addSubview(z_lbtitle)
        self.z_viewcontent.addSubview(z_lbtime)
        self.z_viewcontent.addSubview(z_lbprice)
        self.z_viewcontent.addSubview(z_lbtitlecall)
        self.z_viewcontent.addSubview(z_lbtitlegift)
        self.z_viewcontent.addSubview(z_lbtitlegiftprice)
        self.z_viewcontent.addSubview(z_lbtitleratings)
        self.z_viewcontent.addSubview(z_lbtitleratingsvalue)
        //self.z_viewcontent.addSubview(z_btneditratingsbg)
        
        //z_btneditratingsbg.addSubview(z_btneditratings)
        //z_btneditratingsbg.addTarget(self, action: "func_btneditratingsclick", for: .touchUpInside)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @objc private func func_btneditratingsclick() {
        self.z_onbtncommentratingsclick?(self.z_model)
    }
}
