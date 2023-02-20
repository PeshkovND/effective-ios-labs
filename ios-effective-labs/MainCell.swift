import UIKit
import CollectionViewPagingLayout

final class MainCell: UICollectionViewCell {
    
    var cardContainerView: UIView = {
        let cardContainerView = UIView()
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardContainerView.layer.cornerRadius = 30
        cardContainerView.clipsToBounds = true
        return cardContainerView
    }()
    
    var cardImageView: UIImageView = {
        let cardImageView = UIImageView()
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.contentMode = .scaleAspectFill
        return cardImageView
    }()
    
    var cardLabel: UILabel = {
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
        
        cardLabel.bottomAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: -15).isActive = true
        cardLabel.leftAnchor.constraint(equalTo: cardImageView.leftAnchor, constant: 15).isActive = true
        cardLabel.rightAnchor.constraint(equalTo: cardImageView.rightAnchor, constant: -15).isActive = true
    }

    
    func setup(name: String, image: String) {
        cardImageView.image = UIImage(named: image)
        cardLabel.text = name
    }
}

extension MainCell: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        ScaleTransformViewOptions(
            minScale: 0.55, maxScale: 0.85, scaleRatio: 0.6, translationRatio: CGPoint(x: 0.73, y: 0.2), maxTranslationRatio: CGPoint(x: 2, y: 0), keepVerticalSpacingEqual: false, keepHorizontalSpacingEqual: false, scaleCurve: .linear, translationCurve: .linear
        )
    }
}
