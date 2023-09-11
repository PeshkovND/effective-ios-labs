import UIKit

class ConnectionErrorLabel: UILabel {
    init() {
        super.init(frame: .zero)
        self.text = "Offline Mode! Showing cached data"
        self.textColor = .red
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textAlignment = .center
        self.alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.alpha = 0
        }
    }
}
