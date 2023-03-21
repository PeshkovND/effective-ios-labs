import UIKit

final class LoadingView: UIView {
    
    
    init() {
        super.init(frame: .zero)
        
        setLayut()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }
    
    func stop() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        }
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .red
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
        
    private func setLayut() {
        alpha = 0
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(activityIndicator)
        
        blurEffectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blurEffectView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        blurEffectView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: blurEffectView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: blurEffectView.centerYAnchor).isActive = true
    }
}

