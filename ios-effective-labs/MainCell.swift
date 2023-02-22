import UIKit
import CollectionViewPagingLayout

final class MainCell: UICollectionViewCell {
    
    struct Model {
        let name: String
        let image: UIImage?
    }
    
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
        return cardContainerView
    }()
    
    private let cardImageView: UIImageView = {
        let cardImageView = UIImageView()
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.contentMode = .scaleAspectFill
        return cardImageView
    }()
    
    private let cardLabel: UILabel = {
        let cardLabel = UILabel()
        cardLabel.translatesAutoresizingMaskIntoConstraints = false
        cardLabel.textColor = .white
        cardLabel.font = UIFont.boldSystemFont(ofSize: 24)
        cardLabel.numberOfLines = 0
        return cardLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cardContainerView)
        cardContainerView.addSubview(cardImageView)
        cardImageView.addSubview(cardLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setupConstraints(){
        cardContainerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cardContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cardContainerView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        cardContainerView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        cardImageView.topAnchor.constraint(equalTo: cardContainerView.topAnchor).isActive = true
        cardImageView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor).isActive = true
        cardImageView.leftAnchor.constraint(equalTo: cardContainerView.leftAnchor).isActive = true
        cardImageView.rightAnchor.constraint(equalTo: cardContainerView.rightAnchor).isActive = true
        
        cardLabel.bottomAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: Layout.cardLabelBottomConstraintValue).isActive = true
        cardLabel.leftAnchor.constraint(equalTo: cardImageView.leftAnchor, constant: Layout.cardLabelLeftConstraintValue).isActive = true
        cardLabel.rightAnchor.constraint(equalTo: cardImageView.rightAnchor, constant: Layout.cardLabelRightConstraintValue).isActive = true
    }

    
    func setup(_ model: Model) {
        cardImageView.image = model.image
        cardLabel.text = model.name
    }
}

extension MainCell: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        ScaleTransformViewOptions(
            minScale: 0.55, maxScale: 0.85, scaleRatio: 0.6, translationRatio: CGPoint(x: 0.73, y: 0.2), maxTranslationRatio: CGPoint(x: 2, y: 0), keepVerticalSpacingEqual: false, keepHorizontalSpacingEqual: false, scaleCurve: .linear, translationCurve: .linear
        )
    }
}
