import UIKit
import CollectionViewPagingLayout

final class MainCell: UICollectionViewCell {
    
    public lazy var dominantColor: UIColor? = {
        return cardImageView.image?.averageColor
    }()
    
    struct Model {
        let name: String
        let imageUrl: URL?
        let downloadImageComplition: ((UIImage) -> Void)?
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
        cardContainerView.backgroundColor = .gray
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
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setupLayout(){
        contentView.addSubview(cardContainerView)
        cardContainerView.addSubview(cardImageView)
        cardImageView.addSubview(cardLabel)
        
        cardContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        cardContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        cardContainerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cardContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        cardImageView.topAnchor.constraint(equalTo: cardContainerView.topAnchor).isActive = true
        cardImageView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor).isActive = true
        cardImageView.leftAnchor.constraint(equalTo: cardContainerView.leftAnchor).isActive = true
        cardImageView.rightAnchor.constraint(equalTo: cardContainerView.rightAnchor).isActive = true
        
        cardLabel.bottomAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: Layout.cardLabelBottomConstraintValue).isActive = true
        cardLabel.leftAnchor.constraint(equalTo: cardImageView.leftAnchor, constant: Layout.cardLabelLeftConstraintValue).isActive = true
        cardLabel.rightAnchor.constraint(equalTo: cardImageView.rightAnchor, constant: Layout.cardLabelRightConstraintValue).isActive = true
        
    }

    func setup(_ model: Model) {
        self.cardImageView.setImageUrl(url: model.imageUrl, complition: model.downloadImageComplition)
        self.cardLabel.text = model.name
    }
}

extension MainCell: ScaleTransformView {
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
