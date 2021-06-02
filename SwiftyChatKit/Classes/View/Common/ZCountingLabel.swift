
import UIKit
import SwiftBasicKit

class ZCountingLabel: UILabel {
    
    private let duration: TimeInterval = 0.5
    private var fromValue: Double = 0
    private var toValue: Double = 0
    private var timer: CADisplayLink?
    private var progress: TimeInterval = 0
    private var lastUpdateTime: TimeInterval = 0
    private var totalTime: TimeInterval = 0
    
    private var currentValue: Double {
        if progress >= totalTime { return toValue }
        return fromValue + Double(progress / totalTime) * (toValue - fromValue)
    }
    private func start() {
        timer = CADisplayLink(target: self, selector: #selector(updateValue(timer:)))
        timer?.add(to: .main, forMode: .common)
    }
    private func stop() {
        timer?.invalidate()
        timer = nil
    }
    @objc private func updateValue(timer: Timer) {
        let now = Date.timeIntervalSinceReferenceDate
        progress += now - lastUpdateTime
        lastUpdateTime = now
        if progress >= totalTime {
            stop()
            progress = totalTime
        }
        setTextValue(value: currentValue)
    }
    private func setTextValue(value: Double) {
        text = String(format: "%.f", value)
    }
    final func animate(fromValue from: Double = 0, toValue to: Double, duration t: TimeInterval? = nil) {
        self.fromValue = from
        self.toValue = to
        stop()
        if (t == 0.0) || from == to {
            setTextValue(value: to)
            return
        }
        progress = 0.0
        totalTime = t ?? self.duration
        lastUpdateTime = Date.timeIntervalSinceReferenceDate
        start()
    }
}
