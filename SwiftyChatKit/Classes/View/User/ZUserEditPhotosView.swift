
import UIKit

class ZUserEditPhotosView: UIView {
    
    var z_onbuttonevent: ((_ opt: ZUserEditPhotoOperation, _ row: Int) -> Void)?
    
    private lazy var z_viewcover: ZUserEditPhotoView = {
        let z_temp = ZUserEditPhotoView.init(frame: CGRect.init(13.scale, 0, 173.scale, 235.scale))
        z_temp.tag = 0
        z_temp.border(color: UIColor.clear, radius: 15, width: 0)
        return z_temp
    }()
    private lazy var z_viewphoto1: ZUserEditPhotoView = {
        let z_temp = ZUserEditPhotoView.init(frame: CGRect.init(z_viewcover.x + z_viewcover.width + 10.scale, 0, 77.scale, 113.scale))
        z_temp.tag = 1
        z_temp.border(color: UIColor.clear, radius: 15, width: 0)
        return z_temp
    }()
    private lazy var z_viewphoto2: ZUserEditPhotoView = {
        let z_temp = ZUserEditPhotoView.init(frame: CGRect.init(z_viewphoto1.x + z_viewphoto1.width + 9.scale, 0, 77.scale, 113.scale))
        z_temp.tag = 2
        z_temp.border(color: UIColor.clear, radius: 15, width: 0)
        return z_temp
    }()
    private lazy var z_viewphoto3: ZUserEditPhotoView = {
        let z_temp = ZUserEditPhotoView.init(frame: CGRect.init(z_viewcover.x + z_viewcover.width + 10.scale, z_viewphoto1.y + z_viewphoto1.height + 9.scale, 77.scale, 113.scale))
        z_temp.tag = 3
        z_temp.border(color: UIColor.clear, radius: 15, width: 0)
        return z_temp
    }()
    private lazy var z_viewphoto4: ZUserEditPhotoView = {
        let z_temp = ZUserEditPhotoView.init(frame: CGRect.init(z_viewphoto3.x + z_viewphoto3.width + 9.scale, z_viewphoto3.y, 77.scale, 113.scale))
        z_temp.tag = 4
        z_temp.border(color: UIColor.clear, radius: 15, width: 0)
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_viewcover)
        self.addSubview(z_viewphoto1)
        self.addSubview(z_viewphoto2)
        self.addSubview(z_viewphoto3)
        self.addSubview(z_viewphoto4)
        
        self.z_viewcover.z_onbuttonevent = { (opt, tag) in
            self.z_onbuttonevent?(opt, tag)
        }
        self.z_viewphoto1.z_onbuttonevent = { (opt, tag) in
            self.z_onbuttonevent?(opt, tag)
        }
        self.z_viewphoto2.z_onbuttonevent = { (opt, tag) in
            self.z_onbuttonevent?(opt, tag)
        }
        self.z_viewphoto3.z_onbuttonevent = { (opt, tag) in
            self.z_onbuttonevent?(opt, tag)
        }
        self.z_viewphoto4.z_onbuttonevent = { (opt, tag) in
            self.z_onbuttonevent?(opt, tag)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    final func func_setuserphotos(photos: [String]) {
        self.z_viewcover.z_imageavatar = nil
        self.z_viewphoto1.z_imageavatar = nil
        self.z_viewphoto2.z_imageavatar = nil
        self.z_viewphoto3.z_imageavatar = nil
        self.z_viewphoto4.z_imageavatar = nil
        
        for (i, photo) in photos.enumerated() {
            switch i {
            case 0:
                self.z_viewcover.z_imageavatarpath = photo
            default:
                let view = self.viewWithTag(i) as? ZUserEditPhotoView
                view?.z_imageavatarpath = photo
            }
        }
    }
}
