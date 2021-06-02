
import UIKit
import BMPlayer

class ZBMPlayerCustomControlView: BMPlayerControlView {
    
    /**
     Override if need to customize UI components
     */
    override func customizeUIComponents() {
        // just make the view hidden
        topMaskView.isHidden = true
        chooseDefinitionView.isHidden = true
        
        // or remove from superview
        titleLabel.removeFromSuperview()
        backButton.removeFromSuperview()
        playButton.removeFromSuperview()
        replayButton.removeFromSuperview()
        currentTimeLabel.removeFromSuperview()
        totalTimeLabel.removeFromSuperview()
        timeSlider.removeFromSuperview()
        fullscreenButton.removeFromSuperview()
        
        // 播放进度条添加约束
        progressView.snp.remakeConstraints { (make) in
            make.bottom.left.right.equalTo(bottomMaskView)
            make.height.equalTo(2)
        }
    }
}
