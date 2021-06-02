
import UIKit
import BFKit
import SwiftBasicKit

class ZHtmlViewController: ZZBaseViewController {
    
    public var fileName: String = "" {
        didSet {
            guard let url = URL.resourceUrl(named: fileName) else {
                return
            }
            let text = (try? String.init(contentsOfFile: url.path)) ?? ""
            self.textContent.text = text
        }
    }
    private lazy var textContent: UITextView = {
        let z_temp = UITextView.init(frame: CGRect.init(18.scale, kTopNavHeight, kScreenWidth - 18.scale*2, kScreenHeight - kTopNavHeight))
        z_temp.textColor = "#515158".color
        z_temp.font = UIFont.systemFont(ofSize: 14)
        z_temp.isEditable = false
        z_temp.isScrollEnabled = true
        z_temp.backgroundColor = .clear
        return z_temp
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.textContent)
    }
}
