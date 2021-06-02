
import UIKit
import SwiftBasicKit

class ZChatlistHistoryView: UICollectionReusableView {
    
    var z_arrayCall: [ZModelCallRecord]? {
        didSet {
            z_viewcalls.reloadData()
        }
    }
    var z_oncallitemclick: ((_ model: ZModelCallRecord?) -> Void)?
    
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(10.scale, 0, 300.scale, 45.scale))
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 18
        z_temp.text = ZString.lbConversationhistory.text
        return z_temp
    }()
    private lazy var z_viewcalls: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: 130.scale, height: self.height - 45.scale)
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.scrollDirection = .horizontal
        
        let z_temp = ZBaseCV.init(frame: CGRect.init(0, 45.scale, self.width, z_templayout.itemSize.height), collectionViewLayout: z_templayout)
        z_temp.scrollsToTop = false
        z_temp.backgroundColor = .clear
        z_temp.isUserInteractionEnabled = true
        z_temp.register(ZChatlistCallHistoryCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_lbtitle)
        self.addSubview(z_viewcalls)
        self.backgroundColor = "#100D13".color
        
        z_viewcalls.delegate = self
        z_viewcalls.dataSource = self
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    deinit {
        z_viewcalls.delegate = nil
        z_viewcalls.dataSource = nil
    }
}
extension ZChatlistHistoryView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return z_arrayCall?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! ZChatlistCallHistoryCVC
        if let model = self.z_arrayCall?[indexPath.row] {
            cell.z_model = model
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.z_arrayCall?[indexPath.row] {
            self.z_oncallitemclick?(model)
        }
    }
}
