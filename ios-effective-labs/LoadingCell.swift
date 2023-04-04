import UIKit
import CollectionViewPagingLayout

final class LoadingCell: UICollectionViewCell {
    
    private enum Layout {
        static let cardLabelLeftConstraintValue = CGFloat(16)
        static let cardLabelBottomConstraintValue = CGFloat(-16)
        static let cardLabelRightConstraintValue = CGFloat(-16)
    }
    
    private let cardContainerView: UIView = {
        let cardContainerView = UIView()
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardContainerView.layer.cornerRadius = 30
        cardContainerView.clipsToBounds = true
        cardContainerView.backgroundColor = .gray
        return cardContainerView
    }()
    
    private let cardContainerLoadingView: UIView = {
        let cardContainerView = UIView()
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        return cardContainerView
    }()
    
    private let cardContainerErrorView: UIView = {
        let cardContainerView = UIView()
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        return cardContainerView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .red
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
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
    
    func showError() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.cardContainerLoadingView.alpha = 0
            self.cardContainerErrorView.alpha = 1
        }
    }
    
    func start() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.cardContainerLoadingView.alpha = 1
            self.cardContainerErrorView.alpha = 0
        }
        activityIndicator.startAnimating()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout(){
        contentView.addSubview(cardContainerView)
        cardContainerView.addSubview(cardContainerErrorView)
        cardContainerView.addSubview(cardContainerLoadingView)
        
        cardContainerErrorView.addSubview(errorLabel)
        cardContainerErrorView.addSubview(reloadButton)
        
        cardContainerLoadingView.addSubview(activityIndicator)
        
        cardContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        cardContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        cardContainerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cardContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        cardContainerLoadingView.leftAnchor.constraint(equalTo: cardContainerView.leftAnchor).isActive = true
        cardContainerLoadingView.rightAnchor.constraint(equalTo: cardContainerView.rightAnchor).isActive = true
        cardContainerLoadingView.topAnchor.constraint(equalTo: cardContainerView.topAnchor).isActive = true
        cardContainerLoadingView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor).isActive = true
        
        cardContainerErrorView.leftAnchor.constraint(equalTo: cardContainerView.leftAnchor).isActive = true
        cardContainerErrorView.rightAnchor.constraint(equalTo: cardContainerView.rightAnchor).isActive = true
        cardContainerErrorView.topAnchor.constraint(equalTo: cardContainerView.topAnchor).isActive = true
        cardContainerErrorView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: cardContainerLoadingView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: cardContainerLoadingView.centerYAnchor).isActive = true
        
        errorLabel.centerXAnchor.constraint(equalTo: cardContainerErrorView.centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: cardContainerErrorView.centerYAnchor).isActive = true
        errorLabel.leftAnchor.constraint(equalTo: cardContainerErrorView.leftAnchor).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: cardContainerErrorView.rightAnchor).isActive = true
        
        reloadButton.centerXAnchor.constraint(equalTo: errorLabel.centerXAnchor).isActive = true
        reloadButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor).isActive = true
        reloadButton.widthAnchor.constraint(equalToConstant: reloadButton.intrinsicContentSize.width).isActive = true
    }
}

extension LoadingCell: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        ScaleTransformViewOptions(
            minScale: 0.6,
            scaleRatio: 0.4,
            translationRatio: CGPoint(x: 0.66, y: 0.2),
            maxTranslationRatio: CGPoint(x: 2, y: 0),
            keepVerticalSpacingEqual: true,
            keepHorizontalSpacingEqual: true,
            scaleCurve: .linear,
            translationCurve: .linear
        )
    }
}
