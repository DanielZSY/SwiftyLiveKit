
import UIKit
import SwiftBasicKit

/// 排行榜页面 - 用户详情点击进入
class ZRankIntimateViewController: ZZBaseViewController {
    
    var z_modeluser: ZModelUserInfo? {
        didSet {
            self.z_viewmodel.modeluser = z_modeluser
        }
    }
    private var z_currentpage: Int = 0
    private var arrayday: [ZModelUserInfo] = [ZModelUserInfo]()
    private var arrayweek: [ZModelUserInfo] = [ZModelUserInfo]()
    private lazy var z_btnback: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(0, kStatusHeight, 55, 50))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.arrowLeftW.image, for: .normal)
        return z_temp
    }()
    private lazy var z_btnweek: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(kScreenWidth/2 - 100, kStatusHeight, 100, 45))
        z_temp.isSelected = true
        z_temp.isHighlighted = false
        z_temp.titleLabel?.boldSize = 18
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.lbWeek.text, for: .normal)
        z_temp.setTitle(ZString.lbWeek.text, for: .selected)
        z_temp.setTitleColor("#493443".color, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .selected)
        return z_temp
    }()
    private lazy var z_btnday: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(kScreenWidth/2, kStatusHeight, 100, 45))
        z_temp.isSelected = false
        z_temp.isHighlighted = false
        z_temp.titleLabel?.boldSize = 18
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.lbDay.text, for: .normal)
        z_temp.setTitle(ZString.lbDay.text, for: .selected)
        z_temp.setTitleColor("#493443".color, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .selected)
        return z_temp
    }()
    private lazy var z_viewmain: ZBaseSV = {
        let z_temp = ZBaseSV.init(frame: CGRect.init(0, kTopNavHeight, kScreenWidth, kScreenMainHeight))
        z_temp.tag = 10
        z_temp.scrollsToTop = false
        z_temp.isPagingEnabled = true
        z_temp.showsVerticalScrollIndicator = false
        z_temp.showsHorizontalScrollIndicator = false
        z_temp.contentSize = CGSize.init(width: z_temp.width*2, height: z_temp.height)
        return z_temp
    }()
    private lazy var z_viewweek: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: z_viewmain.width, height: 85.scale)
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.scrollDirection = .vertical
        
        let z_temp = ZBaseCV.init(frame: CGRect.init(0, 0, z_viewmain.width, z_viewmain.height), collectionViewLayout: z_templayout)
        z_temp.tag = kEnumRankTime.Week.rawValue
        z_temp.scrollsToTop = true
        z_temp.addNoDataView()
        z_temp.alwaysBounceVertical = true
        z_temp.register(ZRankItemCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        return z_temp
    }()
    private lazy var z_viewday: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: z_viewmain.width, height: 85.scale)
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.scrollDirection = .vertical
        
        let z_temp = ZBaseCV.init(frame: CGRect.init(z_viewmain.width, 0, z_viewmain.width, z_viewmain.height), collectionViewLayout: z_templayout)
        z_temp.tag = kEnumRankTime.Day.rawValue
        z_temp.scrollsToTop = false
        z_temp.addNoDataView()
        z_temp.alwaysBounceVertical = true
        z_temp.register(ZRankItemCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        return z_temp
    }()
    private let z_viewmodel: ZRankViewModel = ZRankViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.isNavigationHidden = true
        self.view.addSubview(z_btnback)
        self.view.addSubview(z_btnweek)
        self.view.addSubview(z_btnday)
        self.view.addSubview(z_viewmain)
        
        z_viewmain.addSubview(z_viewweek)
        z_viewmain.addSubview(z_viewday)
        
        func_setupevent()
        
        z_viewweek.delegate = self
        z_viewweek.dataSource = self
        z_viewday.delegate = self
        z_viewday.dataSource = self
        z_viewmodel.delegate = self
        z_viewmain.delegate = self
        
        z_viewweek.startAnimating()
        z_viewday.startAnimating()
        z_viewmodel.func_requestranklocal(type: .Lover, time: .Week)
        z_viewmodel.func_requestranklocal(type: .Lover, time: .Day)
    }
    deinit {
        z_viewweek.delegate = nil
        z_viewweek.dataSource = nil
        z_viewday.delegate = nil
        z_viewday.dataSource = nil
        z_viewmodel.delegate = nil
        z_viewmain.delegate = nil
    }
    private func func_setupevent() {
        z_viewweek.addRefreshHeader()
        z_viewweek.addRefreshFooter()
        z_viewweek.onRefreshHeader = {
            self.z_viewmodel.func_requestrankheader(type: .Lover, time: .Week)
        }
        z_viewweek.onRefreshFooter = {
            self.z_viewmodel.func_requestrankfooter(type: .Lover, time: .Week)
        }
        z_viewday.addRefreshHeader()
        z_viewday.addRefreshFooter()
        z_viewday.onRefreshHeader = {
            self.z_viewmodel.func_requestrankheader(type: .Lover, time: .Day)
        }
        z_viewday.onRefreshFooter = {
            self.z_viewmodel.func_requestrankfooter(type: .Lover, time: .Day)
        }
        z_btnback.addTarget(self, action: "func_btnbackclick", for: .touchUpInside)
        z_btnweek.addTarget(self, action: "func_btnweekclick", for: .touchUpInside)
        z_btnday.addTarget(self, action: "func_btndayclick", for: .touchUpInside)
    }
    @objc private func func_btnbackclick() {
        ZRouterKit.pop(fromVC: self)
    }
    @objc private func func_btnweekclick() {
        z_viewweek.scrollsToTop = true
        z_viewday.scrollsToTop = false
        if self.z_currentpage == 0 { return }
        z_viewmain.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    @objc private func func_btndayclick() {
        z_viewweek.scrollsToTop = false
        z_viewday.scrollsToTop = true
        if self.z_currentpage == 1 { return }
        z_viewmain.setContentOffset(CGPoint.init(x: z_viewmain.width, y: 0), animated: true)
    }
    private func func_itemchange(page: Int) {
        if self.z_currentpage != page {
            switch page {
            case 0:
                self.z_btnweek.isSelected = true
                self.z_btnday.isSelected = false
            case 1:
                self.z_btnweek.isSelected = false
                self.z_btnday.isSelected = true
            default: break
            }
            self.z_currentpage = page
        }
    }
}
extension ZRankIntimateViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case kEnumRankTime.Day.rawValue: return arrayday.count
        default: break
        }
        return arrayweek.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! ZRankItemCVC
        switch collectionView.tag {
        case kEnumRankTime.Week.rawValue:
            cell.z_model = ZModelUserInfo.init(instance: arrayweek[indexPath.row])
        case kEnumRankTime.Day.rawValue:
            cell.z_model = ZModelUserInfo.init(instance: arrayday[indexPath.row])
        default: break
        }
        cell.z_type = .Lover
        cell.z_row = indexPath.row
        cell.tag = collectionView.tag
        
        return cell
    }
}
extension ZRankIntimateViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 10 {
            let currentIndex = Int(floor(scrollView.contentOffset.x/(scrollView.frame.size.width/3*2)))
            self.func_itemchange(page: currentIndex)
        }
    }
}
extension ZRankIntimateViewController: ZRankViewModelDelegate {
    func func_requestranklocalsuccess(models: [ZModelUserInfo]?, type: kEnumRankType, time: kEnumRankTime) {
        let count = models?.count ?? 0
        switch time {
        case .Day:
            self.arrayday.removeAll()
            if let array = models {
                self.arrayday.append(contentsOf: array)
            }
            self.z_viewday.stopAnimating(count: count)
            self.z_viewday.endRefreshHeader()
            self.z_viewday.reloadData()
        case .Week:
            self.arrayweek.removeAll()
            if let array = models {
                self.arrayweek.append(contentsOf: array)
            }
            self.z_viewweek.stopAnimating(count: count)
            self.z_viewweek.endRefreshHeader()
            self.z_viewweek.reloadData()
        default: break
        }
        switch type {
        case .Lover:
            switch time {
            case .Day: self.z_viewmodel.func_requestrankheader(type: .Lover, time: .Day)
            case .Week: self.z_viewmodel.func_requestrankheader(type: .Lover, time: .Week)
            default: break
            }
        default: break
        }
    }
    func func_requestrankheadersuccess(models: [ZModelUserInfo]?, type: kEnumRankType, time: kEnumRankTime) {
        let count = models?.count ?? 0
        switch time {
        case .Day:
            self.arrayday.removeAll()
            if let array = models {
                self.arrayday.append(contentsOf: array)
            }
            self.z_viewday.stopAnimating(count: count)
            self.z_viewday.endRefreshHeader()
            self.z_viewday.reloadData()
        case .Week:
            self.arrayweek.removeAll()
            if let array = models {
                self.arrayweek.append(contentsOf: array)
            }
            self.z_viewweek.stopAnimating(count: count)
            self.z_viewweek.endRefreshHeader()
            self.z_viewweek.reloadData()
        default: break
        }
    }
    func func_requestrankfootersuccess(models: [ZModelUserInfo]?, type: kEnumRankType, time: kEnumRankTime) {
        switch time {
        case .Day:
            if let array = models {
                self.arrayday.append(contentsOf: array)
            }
            self.z_viewday.endRefreshFooter(models?.count ?? 0)
            self.z_viewday.reloadData()
        case .Week:
            if let array = models {
                self.arrayweek.append(contentsOf: array)
            }
            self.z_viewweek.endRefreshFooter(models?.count ?? 0)
            self.z_viewweek.reloadData()
        default: break
        }
    }
}
