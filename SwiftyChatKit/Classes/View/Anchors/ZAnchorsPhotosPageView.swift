
import UIKit

class ZAnchorsPhotosPageView: UIView {
    
    var z_pagetotal: Int = 0 {
        didSet {
            self.func_pagechange()
            self.lastpagetotal = self.z_pagetotal
        }
    }
    var z_pagecurrent: Int = 0 {
        didSet {
            self.z_pagecurrent = self.z_pagecurrent < 0 ? self.z_pagetotal : self.z_pagecurrent
            self.func_pagechange()
            self.lastpagecurrent = self.z_pagecurrent
        }
    }
    private var lastpagecurrent: Int = 0
    private var lastpagetotal: Int = 0
    private func func_pagechange() {
        if z_pagecurrent == lastpagecurrent && z_pagetotal == lastpagetotal {
            return
        }
        if self.z_pagetotal == 0 {
            for i in 1...9 {
                guard let view = self.viewWithTag(i) else {
                    return
                }
                view.isHidden = true
            }
            return
        }
        let defaultw = 15.scale
        let defaults = 4.scale
        var offsetx: CGFloat = (self.width - (defaultw*CGFloat(z_pagetotal) + defaults*CGFloat(z_pagetotal - 1)))/2
        UIView.animate(withDuration: 0.25, animations: {
            for i in 1...self.z_pagetotal {
                guard let view = self.viewWithTag(i) else {
                    return
                }
                view.isHidden = false
                view.x = offsetx
                if i == (self.z_pagecurrent+1) || self.z_pagecurrent >= self.z_pagetotal {
                    view.backgroundColor = "#FFFFFF".color
                } else {
                    view.backgroundColor = "#FFFFFF".color.withAlphaComponent(0.3)
                }
                offsetx = view.x + view.width + defaults
            }
        })
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        for i in 1...9 {
            let z_temp = UIView.init(frame: CGRect.init(0, 0, 15.scale, self.height))
            z_temp.border(color: .clear, radius: self.height/2, width: 0)
            z_temp.tag = i
            z_temp.isHidden = true
            z_temp.backgroundColor = .clear
            self.addSubview(z_temp)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
