
import UIKit
import BFKit
import SwiftBasicKit

/// 轮播图片分页控件显示位置
enum ZCycleBaseScrollViewPageContolAliment: Int {
    case right
    case left
    case center
}
/// 轮播图片对象
class ZCycleBaseScrollView: UIView {
    
    /// 闭包 子项目点击事件
    var onItemCycleEvent: ((Int)->())?
    /// 子项目改变回调事件
    var onItemChangeEvent: ((Int)->())?
    /// 是否是无限循环 default is True
    var infiniteLoop: Bool = true
    /// 占位图
    var placeHolderImage: UIImage? = Asset.defaultBanner.image
    /// 分页显示位置 ZCycleBaseScrollViewPageContolAliment.right
    var pageControlAliment: ZCycleBaseScrollViewPageContolAliment = .center
    /// 分页控件小圆标颜色 defaulet is 255
    var currentPageIndicatorTintColor: UIColor = "#FFFFFF".color {
        didSet {
            self.pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor
        }
    }
    /// 分页未选中小圆标颜色 default is 255 a 0.3
    var pageIndicatorTintColor: UIColor = "#FFFFFF".color.withAlphaComponent(0.3) {
        didSet {
            self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor
        }
    }
    /// 是否是自动滚动 default is true
    var autoScroll: Bool = true {
        didSet {
            self.setAutoScroll()
        }
    }
    /// 网络图片数组
    var arrayImageUrlString: [String] = [String]() {
        didSet {
            self.imagesGroup.removeAll()
            self.imagesGroup.append(contentsOf: self.arrayImageUrlString)
        }
    }
    /// 是否显示分页
    var showPageControl: Bool = true {
        didSet {
            self.pageControl.isHidden = !self.showPageControl
            self.setNeedsLayout()
        }
    }
    /// 使用图片
    private var imagesGroup: [String] = [String]() {
        didSet {
            if self.infiniteLoop {
                self.totalItemsCount = self.imagesGroup.count > 0 ? self.imagesGroup.count + 2 : 0
                self.maxOffsetX = CGFloat(self.imagesGroup.count) * self.width
            } else {
                self.totalItemsCount = self.imagesGroup.count
            }
            if self.imagesGroup.count > 1 {
                self.viewCollection.isScrollEnabled = true
                self.pageControl.isHidden = !self.showPageControl
                self.setAutoScroll()
            } else {
                self.viewCollection.isScrollEnabled = false
                self.pageControl.isHidden = true
            }
            self.pageControl.numberOfPages = self.imagesGroup.count
            self.viewCollection.reloadData()
            self.setNeedsLayout()
        }
    }
    /// 时间间隔  default is 5.0
    var autoScrollTimeInterval: TimeInterval = kAutoScrollTime
    var maxOffsetX: CGFloat = 0
    private lazy var viewCollectionFlowLayout: UICollectionViewFlowLayout = {
        let item = UICollectionViewFlowLayout.init()
        
        item.itemSize = self.frame.size
        item.minimumLineSpacing = 0
        item.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        return item
    }()
    private lazy var viewCollection: UICollectionView = {
        let item = UICollectionView.init(frame: self.bounds, collectionViewLayout: self.viewCollectionFlowLayout)
        
        item.scrollsToTop = false
        item.isUserInteractionEnabled = true
        item.backgroundColor = UIColor.clear
        item.isPagingEnabled = true
        item.showsHorizontalScrollIndicator = false
        item.showsVerticalScrollIndicator = false
        item.register(ZCycleCollectionViewCell.self, forCellWithReuseIdentifier: "kcellid")
        if #available(iOS 11.0, *) {
            item.contentInsetAdjustmentBehavior = .never
        }
        return item
    }()
    /// 总计数量
    private lazy var totalItemsCount: Int = 0
    private lazy var viewPageControl: UIView = {
        let item = UIView.init()
        
        item.backgroundColor = UIColor.clear
        
        return item
    }()
    /// 分页显示控件
    private lazy var pageControl: UIPageControl = {
        let item = UIPageControl.init()
        
        item.pageIndicatorTintColor = self.pageIndicatorTintColor
        item.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor
        item.isUserInteractionEnabled = false
        
        return item
    }()
    /// 默认背景图片
    private lazy var imageDefaultBG: UIImageView = {
        let item = UIImageView.init(image: self.placeHolderImage)
        
        item.frame = self.bounds
        item.contentMode = UIView.ContentMode.scaleAspectFill
        
        return item
    }()
    /// 开始轮播时间控制器
    private var timer : Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initInnerView()
    }
    required convenience init() {
        self.init(frame: CGRect.zero)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    deinit {
        self.viewCollection.delegate = nil
        self.viewCollection.dataSource = nil
        self.timer?.invalidate()
        self.timer = nil
    }
    fileprivate func initInnerView() {
        
        self.addSubview(self.viewCollection)
        self.addSubview(self.viewPageControl)
        self.addSubview(self.imageDefaultBG)
        self.sendSubviewToBack(self.viewCollection)
        self.sendSubviewToBack(self.imageDefaultBG)
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        
        self.viewPageControl.addSubview(self.pageControl)
        
        self.viewCollection.delegate = self
        self.viewCollection.dataSource = self
        self.viewCollection.reloadData()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.viewCollection.frame = self.bounds
        self.imageDefaultBG.frame = self.bounds
        if self.infiniteLoop && self.totalItemsCount > 0 {
            self.viewCollection.setContentOffset(CGPoint.init(x: self.viewCollection.width, y: 0), animated: false)
        }
        self.viewPageControl.frame = CGRect.init(0, kStatusHeight + 10, self.width, 30)
        let pageSize: CGSize = self.pageControl.size(forNumberOfPages: self.imagesGroup.count)
        var pageX: CGFloat = (20).scale
        let pageY: CGFloat = self.viewPageControl.height/2-pageSize.height/2
        switch self.pageControlAliment {
        case .right:
            pageX = self.viewPageControl.width-pageSize.width-(20).scale
        case .center:
            pageX = self.viewPageControl.width/2-pageSize.width/2
        default: break
        }
        self.pageControl.frame = CGRect.init(pageX, pageY, pageSize.width, pageSize.height)
    }
    fileprivate func setAutoScroll() {
        self.timer?.invalidate()
        self.timer = nil
        if self.autoScroll {
            self.setupTimer()
        }
    }
    /// 自动轮播
    @objc fileprivate func automaticScroll() {
        if self.totalItemsCount == 0 {
            return
        }
        let currentIndex = Int(self.viewCollection.contentOffset.x/self.width)
        var nextIndex = currentIndex + 1
        if self.infiniteLoop, (nextIndex >= self.totalItemsCount) {
            nextIndex = 0
        }
        self.viewCollection.scrollToItem(at: NSIndexPath.init(row: nextIndex, section: 0) as IndexPath, at: UICollectionView.ScrollPosition(rawValue: 0), animated: true)
    }
    fileprivate func setupTimer() {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.autoScrollTimeInterval), target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
            RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
        }
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
}
// MARK: - UIScrollViewDelegate
extension ZCycleBaseScrollView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.imagesGroup.count == 0  {
            return
        }
        let offsetX = (scrollView.contentOffset.x)
        var currentIndex: Int = 0
        if self.infiniteLoop {
            if (offsetX <= 0) {
                currentIndex = self.imagesGroup.count
                scrollView.setContentOffset(CGPoint(x: self.maxOffsetX, y: 0), animated: false)
            } else if (offsetX >= CGFloat(self.imagesGroup.count + 1) * self.width) {
                currentIndex = 0
                scrollView.setContentOffset(CGPoint(x: self.width, y: 0), animated: false)
            } else {
                currentIndex = Int(offsetX/self.width) - 1
            }
        } else {
            currentIndex = Int(offsetX/self.width)
        }
        //BFLog.debug("CycleBaseScroll index: \(currentIndex)")
        self.pageControl.currentPage = currentIndex
        self.onItemChangeEvent?(currentIndex)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.autoScroll {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.autoScroll {
            self.setupTimer()
        }
    }
}
// MARK: - UICollectionViewDelegate UICollectionViewDataSource
extension ZCycleBaseScrollView: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.imagesGroup.count == 0 {
            return 0
        }
        return self.totalItemsCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kcellid", for: indexPath) as! ZCycleCollectionViewCell
        
        var itemIndex = indexPath.item
        if self.infiniteLoop {
            if (indexPath.item == 0) {
                itemIndex = self.imagesGroup.count - 1
            } else if (indexPath.item == self.imagesGroup.count + 1) {
                itemIndex = 0
            } else {
                itemIndex = indexPath.item - 1
            }
        }
        let url = self.imagesGroup[itemIndex]
        cell.tag = itemIndex
        cell.z_imagemain.setImageWitUrl(strUrl: url, placeholder: self.placeHolderImage)
        cell.z_on_itemcycleclick = { (row) in
            let rowIndex = row
            self.onItemCycleEvent?(rowIndex)
        }
        return cell
    }
}
