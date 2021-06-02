
import UIKit
import SwipeCellKit
import SwiftBasicKit

class ZChatlistMessagesCVC: SwipeCollectionViewCell {
    
    var z_model: ZModelMessageRecord? {
        didSet {
            func_contentchange()
        }
    }
    var z_onbuttondeleteclick: ((_ row: Int) -> Void)?
    private lazy var z_imagephoto: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(10.scale, 10.scale, 68.scale, 68.scale))
        z_temp.border(color: .clear, radius: 68.scale/2, width: 0)
        return z_temp
    }()
    private lazy var z_lbusername: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(87.scale, z_imagephoto.x + 12.scale, 200.scale, 24.scale))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 14
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_lbmessage: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(87.scale, z_imagephoto.x + z_imagephoto.height/2 + 2.scale, 230.scale, 20.scale))
        z_temp.textColor = "#515158".color
        z_temp.boldSize = 12
        z_temp.lineBreakMode = .byTruncatingTail
        return z_temp
    }()
    private lazy var z_lbtime: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(self.contentView.width - 80.scale, z_lbusername.y, 70.scale, 24.scale))
        z_temp.textColor = "#515158".color
        z_temp.boldSize = 12
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_lbcount: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(self.contentView.width - 47.scale, z_lbmessage.y + 2.scale, 37.scale, 17.scale))
        z_temp.isHidden = true
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 12
        z_temp.textAlignment = .center
        z_temp.adjustsFontSizeToFitWidth = true
        z_temp.backgroundColor = "#C12070".color
        z_temp.border(color: .clear, radius: 17.scale/2, width: 0)
        return z_temp
    }()
    private lazy var z_imageservice: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(86.scale, z_imagephoto.y + 17.scale, 14.scale, 16.scale))
        z_temp.isHidden = true
        z_temp.image = Asset.chatService.image
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.backgroundView?.backgroundColor = .clear
        self.contentView.isUserInteractionEnabled = true
        
        self.contentView.addSubview(z_imagephoto)
        self.contentView.addSubview(z_imageservice)
        self.contentView.addSubview(z_lbusername)
        self.contentView.addSubview(z_lbmessage)
        self.contentView.addSubview(z_lbtime)
        self.contentView.addSubview(z_lbcount)
        
        self.delegate = self
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    deinit {
        self.delegate = nil
    }
    private func func_contentchange() {
        guard let model = self.z_model else { return }
        switch model.message_type {
        case .call:
            z_lbmessage.textColor = "#C12070".color
        default:
            z_lbmessage.textColor = "#515158".color
        }
        z_lbcount.isHidden = model.message_unread_count == 0
        z_lbcount.text = model.message_unread_count.str
        z_imageservice.isHidden = true
        z_lbusername.frame = CGRect.init(87.scale, z_lbusername.y, 200.scale, z_lbusername.height)
        z_lbmessage.text = model.message
        z_lbtime.text = model.message_time.strMessageTime
        guard let user = model.message_user else { return }
        switch user.role {
        case .customerService:
            z_imageservice.isHidden = false
            z_lbusername.frame = CGRect.init(103.scale, z_lbusername.y, 184.scale, z_lbusername.height)
        default: break
        }
        z_lbusername.text = user.nickname
        z_imagephoto.setImageWitUrl(strUrl: user.avatar, placeholder: Asset.defaultAvatar.image)
    }
}
extension ZChatlistMessagesCVC: SwipeCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        guard let model = self.z_model else { return nil }
        if model.message_user?.role == .customerService { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: ZString.btnDelete.text) { [weak self] action, indexPath in
            guard let `self` = self else { return }
            self.z_onbuttondeleteclick?(indexPath.row)
        }
        return [deleteAction]
    }
}
