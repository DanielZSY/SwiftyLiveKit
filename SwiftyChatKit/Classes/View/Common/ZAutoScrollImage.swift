
import UIKit

public enum ZAutoScrollDirection {
    case Right
    case Left
}
public class ZAutoScrollImage: UIView {
    
    private static let kDefaultFadeLength = CGFloat(7.0)
    private static let kDefaultLabelBufferSpace = CGFloat(10.0)  // Pixel buffer space between scrolling label
    private static let kDefaultPixelsPerSecond: Double = 30.0
    private static let kDefaultPauseTime: Double = 0
    
    public var scrollDirection = ZAutoScrollDirection.Left {
        didSet {
            scrollLabelIfNeeded()
        }
    }
    // Pixels per second, defaults to 30
    public var scrollSpeed = ZAutoScrollImage.kDefaultPixelsPerSecond {
        didSet {
            scrollLabelIfNeeded()
        }
    }
    // Defaults to 1.5
    public var pauseInterval = ZAutoScrollImage.kDefaultPauseTime
    
    // Pixels, defaults to 10
    public var imagespacing = ZAutoScrollImage.kDefaultLabelBufferSpace
    
    public var animationOptions: UIView.AnimationOptions = UIView.AnimationOptions.curveLinear
    
    // Returns YES, if it is actively scrolling, NO if it has paused or if text is within bounds (disables scrolling).
    public var scrolling = true
    
    // Defaults to 7
    public var fadeLength = ZAutoScrollImage.kDefaultFadeLength {
        didSet {
            if oldValue != fadeLength {
                refreshimages()
                applyGradientMaskForFadeLength(fadeLengthIn: fadeLength, enableFade: false)
            }
        }
    }
    public var imageNames: [String] = [String]() {
        didSet {
            self.scrollView.removeAllSubviews()
            var offset = -(self.imagespacing + self.height)
            var names = self.imageNames.shuffled()
            names.reversed().forEach { (named) in
                let imageView = UIImageView.init(image: UIImage.assetImage(named: named))
                imageView.backgroundColor = UIColor.clear
                imageView.frame = CGRect.init(origin: CGPoint.init(x: offset, y: 0), size: CGSize.init(width: self.height, height: self.height))
                imageView.border(color: .clear, radius: self.height/2, width: 0)
                self.scrollView.addSubview(imageView)
                
                offset = offset - (self.imagespacing + self.height)
            }
            offset = self.imagespacing
            names.append(contentsOf: names)
            names.forEach { (named) in
                let imageView = UIImageView.init(image: UIImage.assetImage(named: named))
                imageView.backgroundColor = UIColor.clear
                imageView.frame = CGRect.init(origin: CGPoint.init(x: offset, y: 0), size: CGSize.init(width: self.height, height: self.height))
                imageView.border(color: .clear, radius: self.height/2, width: 0)
                self.scrollView.addSubview(imageView)
                
                offset = offset + self.height + self.imagespacing
            }
            didChangeFrame()
        }
    }
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(frame: self.bounds)
        sv.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        sv.backgroundColor = UIColor.clear
        if #available(iOS 11.0, *) {
            sv.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        sv.scrollsToTop = false
        sv.isScrollEnabled = true
        sv.isUserInteractionEnabled = false
        return sv
    }()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    public required init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private func commonInit() {
        addSubview(scrollView)
        
        // Default values
        self.scrollDirection = ZAutoScrollDirection.Left
        self.scrollSpeed = ZAutoScrollImage.kDefaultPixelsPerSecond
        self.pauseInterval = ZAutoScrollImage.kDefaultPauseTime
        self.imagespacing = ZAutoScrollImage.kDefaultLabelBufferSpace
        self.fadeLength = ZAutoScrollImage.kDefaultFadeLength
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.isScrollEnabled = false
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
    }
    public override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue
            didChangeFrame()
        }
    }
    public override var bounds: CGRect {
        get {
            return super.bounds
        }
        set {
            super.bounds = newValue
            didChangeFrame()
        }
    }
    private func didChangeFrame() {
        refreshimages()
        applyGradientMaskForFadeLength(fadeLengthIn: self.fadeLength, enableFade: self.scrolling)
    }
    public func observeApplicationNotifications() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(
            self, selector: #selector(ZAutoScrollImage.scrollLabelIfNeeded),
            name: UIApplication.willEnterForegroundNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(ZAutoScrollImage.scrollLabelIfNeeded),
            name: UIApplication.didBecomeActiveNotification, object: nil
        )
    }
    
    @objc private func enableShadow() {
        scrolling = true
        self.applyGradientMaskForFadeLength(fadeLengthIn: self.fadeLength, enableFade: true)
    }
    
    @objc public func scrollLabelIfNeeded() {
        
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                strongSelf.scrollLabelIfNeededAction()
            }
        }
    }
    
    func scrollLabelIfNeededAction() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(ZAutoScrollImage.scrollLabelIfNeeded), object: nil)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(ZAutoScrollImage.enableShadow), object: nil)
        
        self.scrollView.layer.removeAllAnimations()
        let contentWidth = self.scrollView.contentSize.width
        if self.scrollDirection == .Left {
            scrollView.contentOffset = CGPoint.zero
        } else {
            scrollView.contentOffset = CGPoint.init(x: contentWidth, y: 0)
        }
        self.perform(#selector(ZAutoScrollImage.enableShadow), with: nil, afterDelay: self.pauseInterval)
        
        // Animate the scrolling
        let duration = Double(contentWidth) / self.scrollSpeed
        UIView.animate(
            withDuration: duration,
            delay: self.pauseInterval,
            options: [self.animationOptions, UIView.AnimationOptions.allowUserInteraction],
            animations: { [weak self] () -> Void in
                if let strongSelf = self {
                    // Adjust offset
                    if strongSelf.scrollDirection == .Left {
                        strongSelf.scrollView.contentOffset = CGPoint.init(x: contentWidth, y: 0)
                    } else {
                        strongSelf.scrollView.contentOffset = CGPoint.zero
                    }
                }
            }) { [weak self] finished in
            if let strongSelf = self {
                strongSelf.scrolling = false
                // Remove the left shadow
                strongSelf.applyGradientMaskForFadeLength(
                    fadeLengthIn: strongSelf.fadeLength, enableFade: false
                )
                // Setup pause delay/loop
                if finished {
                    strongSelf.performSelector(inBackground: #selector(ZAutoScrollImage.scrollLabelIfNeeded), with: nil)
                }
            }
        }
    }
    
    @objc private func refreshimages() {
        scrollView.layer.removeAllAnimations()
        let count = CGFloat(imageNames.count)
        let contentwidth = count * self.height + (count) * self.imagespacing
        scrollView.contentSize = CGSize.init(width: contentwidth, height: self.height)
        if self.scrollDirection == .Left {
            scrollView.contentOffset = CGPoint.zero
        } else {
            scrollView.contentOffset = CGPoint.init(x: contentwidth, y: 0)
        }
        // If the label is bigger than the space allocated, then it should scroll
        if self.scrollView.contentSize.width > bounds.width {
            
            self.applyGradientMaskForFadeLength(fadeLengthIn: self.fadeLength, enableFade: self.scrolling)
            
            //scrollLabelIfNeeded()
        } else {
            
            // Adjust the scroll view and main label
            self.scrollView.contentSize = self.bounds.size
            
            // Cleanup animation
            scrollView.layer.removeAllAnimations()
            
            applyGradientMaskForFadeLength(fadeLengthIn: 0, enableFade: false)
        }
    }
    
    private func applyGradientMaskForFadeLength(fadeLengthIn: CGFloat, enableFade fade: Bool) {
        var fadeLength = fadeLengthIn
        
        let labelWidth = self.scrollView.contentSize.width
        if labelWidth <= self.bounds.width {
            fadeLength = 0
        }
        
        if fadeLength != 0 {
            gradientMaskFade(fade: fade)
        } else {
            layer.mask = nil
        }
    }
    
    func gradientMaskFade(fade: Bool) {
        // Recreate gradient mask with new fade length
        let gradientMask = CAGradientLayer()
        
        gradientMask.bounds = self.layer.bounds
        gradientMask.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        gradientMask.shouldRasterize = true
        gradientMask.rasterizationScale = UIScreen.main.scale
        
        gradientMask.startPoint = CGPoint(x: 0, y: self.frame.midY)
        gradientMask.endPoint = CGPoint(x: 1, y: self.frame.midY)
        
        // Setup fade mask colors and location
        let transparent = UIColor.clear.cgColor
        
        let opaque = UIColor.black.cgColor
        gradientMask.colors = [transparent, opaque, opaque, transparent]
        
        // Calcluate fade
        let fadePoint = fadeLength / self.bounds.width
        var leftFadePoint = fadePoint
        var rightFadePoint = 1 - fadePoint
        if !fade {
            switch (self.scrollDirection) {
            case .Left:
                leftFadePoint = 0
                
            case .Right:
                leftFadePoint = 0
                rightFadePoint = 1
            }
        }
        // Apply calculations to mask
        gradientMask.locations = [
            0, NSNumber(value: Double(leftFadePoint)), NSNumber(value: Double(rightFadePoint)), 1
        ]
        // Don't animate the mask change
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.layer.mask = gradientMask
        CATransaction.commit()
    }
    private func onUIApplicationDidChangeStatusBarOrientationNotification(notification: NSNotification) {
        // Delay to have it re-calculate on next runloop
        perform(#selector(ZAutoScrollImage.refreshimages), with: nil, afterDelay: 0.1)
        perform(#selector(ZAutoScrollImage.scrollLabelIfNeeded), with: nil, afterDelay: 0.1)
    }
}
