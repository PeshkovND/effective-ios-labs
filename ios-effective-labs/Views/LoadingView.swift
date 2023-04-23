import UIKit

final class LoadingView: UIView {
    
    
    init() {
        super.init(frame: .zero)
        setLayut()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let loadingView: UIView = {
        let loadingView = UIView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()
    
    private let errorView: UIView = {
        let errorView = UIView()
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.alpha = 0
        return errorView
    }()
    
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
        
    
    func start() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
            self.loadingView.alpha = 1
            self.errorView.alpha = 0
        }
    }
    
    func stop() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        }
    }
    
    func showError() {
        UIView.animate(withDuration: 0.5) {
            
            self.loadingView.alpha = 0
            self.errorView.alpha = 1
        }
    }

    private func setLayut() {
        addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(errorView)
        blurEffectView.contentView.addSubview(loadingView)
        
        errorView.addSubview(errorLabel)
        errorView.addSubview(reloadButton)
        
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        blurEffectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blurEffectView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        blurEffectView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        errorView.topAnchor.constraint(equalTo: blurEffectView.topAnchor).isActive = true
        errorView.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor).isActive = true
        errorView.leftAnchor.constraint(equalTo: blurEffectView.leftAnchor).isActive = true
        errorView.rightAnchor.constraint(equalTo: blurEffectView.rightAnchor).isActive = true
        
        loadingView.topAnchor.constraint(equalTo: blurEffectView.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor).isActive = true
        loadingView.leftAnchor.constraint(equalTo: blurEffectView.leftAnchor).isActive = true
        loadingView.rightAnchor.constraint(equalTo: blurEffectView.rightAnchor).isActive = true
        
        errorLabel.centerXAnchor.constraint(equalTo: errorView.centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: errorView.centerYAnchor).isActive = true
        errorLabel.leftAnchor.constraint(equalTo: errorView.leftAnchor).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: errorView.rightAnchor).isActive = true
        
        reloadButton.centerXAnchor.constraint(equalTo: errorLabel.centerXAnchor).isActive = true
        reloadButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor).isActive = true
        reloadButton.widthAnchor.constraint(equalToConstant: reloadButton.intrinsicContentSize.width).isActive = true

        activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
    }
}

