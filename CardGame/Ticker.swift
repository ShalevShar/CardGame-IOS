import Foundation

class Ticker {
    private var timer: Timer?
    private var interval: TimeInterval
    private var action: () -> Void
    
    init(interval: TimeInterval, action: @escaping () -> Void) {
        self.interval = interval
        self.action = action
    }
    
    func intervalChange(newInterval: Double) {
        self.interval = newInterval
    }
    
    func start() {
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
                self?.action()
            }
        }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
