import UIKit
import CollectionViewPagingLayout

class MainCell: UICollectionViewCell {
    
    var card: UIView!
    var cardImage: UIImageView!
    var cardLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 30
        card.clipsToBounds = true
        contentView.addSubview(card)
        
        cardImage = UIImageView()
        cardImage.translatesAutoresizingMaskIntoConstraints = false
        cardImage.contentMode = .scaleAspectFill
        card.addSubview(cardImage)
        
        cardLabel = UILabel()
        cardLabel.translatesAutoresizingMaskIntoConstraints = false
        cardLabel.textColor = .white
        cardLabel.font = UIFont.boldSystemFont(ofSize: 24)
        cardLabel.numberOfLines = 0
        cardImage.addSubview(cardLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setupConstraints(){
        card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        card.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        card.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        
        cardImage.topAnchor.constraint(equalTo: card.topAnchor, constant: 0).isActive = true
        cardImage.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: 0).isActive = true
        cardImage.centerXAnchor.constraint(equalTo: card.centerXAnchor, constant: 0).isActive = true
        cardImage.widthAnchor.constraint(equalTo: card.widthAnchor, multiplier: 1).isActive = true
        
        cardLabel.bottomAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: -15).isActive = true
        cardLabel.leftAnchor.constraint(equalTo: cardImage.leftAnchor, constant: 15).isActive = true
        cardLabel.rightAnchor.constraint(equalTo: cardImage.rightAnchor, constant: -15).isActive = true
    }

    
    func setup(name: String, image: String) {
        cardImage.image = UIImage(named: image)
        cardLabel.text = name
    }
}

extension MainCell: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        .layout(.linear)
    }
}
