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
        reloadButton.removeFromSuperview()
        errorLabel.removeFromSuperview()
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
        
        blurEffectView.contentView.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: blurEffectView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: blurEffectView.centerYAnchor).isActive = true
    }
    
    func stop() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        }
    }
    
    func showError() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        blurEffectView.contentView.addSubview(errorLabel)
        blurEffectView.contentView.addSubview(reloadButton)
        
        errorLabel.centerXAnchor.constraint(equalTo: blurEffectView.centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: blurEffectView.centerYAnchor).isActive = true
        errorLabel.leftAnchor.constraint(equalTo: blurEffectView.leftAnchor).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: blurEffectView.rightAnchor).isActive = true
        
        reloadButton.centerXAnchor.constraint(equalTo: errorLabel.centerXAnchor).isActive = true
        reloadButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor).isActive = true
        reloadButton.widthAnchor.constraint(equalToConstant: reloadButton.intrinsicContentSize.width).isActive = true
    }

    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    private let errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.text = "Data loading error"
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textAlignment = .center
        errorLabel.textColor = .white
        return errorLabel
    }()
    
    let reloadButton: UIButton = {
        let reloadButton = UIButton()
        reloadButton.setTitle("Reload", for: .normal)
        reloadButton.setTitleColor(.red, for: .normal)
        reloadButton.setTitleColor(.white, for: .highlighted)
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        return reloadButton
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .red
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
        
    private func setLayut() {
        alpha = 0
        addSubview(blurEffectView)
        
        blurEffectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blurEffectView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        blurEffectView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}

