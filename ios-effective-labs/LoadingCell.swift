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
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .red
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
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
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        
        cardContainerView.addSubview(errorLabel)
        cardContainerView.addSubview(reloadButton)
        
        errorLabel.centerXAnchor.constraint(equalTo: cardContainerView.centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: cardContainerView.centerYAnchor).isActive = true
        errorLabel.leftAnchor.constraint(equalTo: cardContainerView.leftAnchor).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: cardContainerView.rightAnchor).isActive = true
        
        reloadButton.centerXAnchor.constraint(equalTo: errorLabel.centerXAnchor).isActive = true
        reloadButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor).isActive = true
        reloadButton.widthAnchor.constraint(equalToConstant: reloadButton.intrinsicContentSize.width).isActive = true
    }
    
    func start() {
        reloadButton.removeFromSuperview()
        errorLabel.removeFromSuperview()
        
        cardContainerView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        activityIndicator.centerXAnchor.constraint(equalTo: cardContainerView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: cardContainerView.centerYAnchor).isActive = true
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
        cardContainerView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        cardContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        cardContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        cardContainerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cardContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: cardContainerView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: cardContainerView.centerYAnchor).isActive = true
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
