import UIKit
import CollectionViewPagingLayout

class MainCell: UICollectionViewCell {
    
    var card: UIView!
    var width: Float!
    var height: Float!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup() {
        card = UIView()
        card.backgroundColor = .systemOrange
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 30
        contentView.addSubview(card)
        
        card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        card.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        card.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        
    }
}

extension MainCell: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        .layout(.linear)
    }
}
