import UIKit
import CollectionViewPagingLayout

final class ViewController: UIViewController {
    
    private enum Layout: Double {
        case logoWidthMultiplier = 0.5
        case logoPngHeigh = 303
        case logoPngWidth = 1024
        case mainLabelTopConstraintValue = 10
        case collectionViewTopConstraintValue = 30
        case collectionViewBottomConstraintValue = -30
    }
    
    private let collectionView: UICollectionView = {
        let layout = CollectionViewPagingLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .none
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: String(describing: MainCell.self))
        return collectionView
    }()
    
    private let charactersData = CharactersMocks()
    
    private let colors: [UIColor] = [.yellow, .blue, .purple, .red, .orange, .green]
    
    private var triangle: TriangleView!
    
    
    let logoImageView: UIImageView = {
        let logoView = UIImageView()
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.image = UIImage(named: "marvelLogo")
        return logoView
    }()
    
    let mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.font = UIFont.boldSystemFont(ofSize: 24)
        mainLabel.textColor = .white
        mainLabel.textAlignment = .center
        mainLabel.text = "Choose your hero"
        return mainLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        setupLayout()
    }
    
    func findCenterIndex() -> IndexPath? {
        let center = self.view.convert(self.collectionView.center, to: self.collectionView)
        let index = collectionView.indexPathForItem(at: center)
        return index
    }

    func setupLayout() {
        
        triangle = TriangleView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        triangle.backgroundColor = colors[0]
        view.addSubview(triangle)
        triangle.addSubview(logoImageView)
        triangle.addSubview(mainLabel)
        triangle.addSubview(collectionView)
        
//        triangle.topAnchor.constraint(equalTo: view.topAnchor)
//        triangle.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        triangle.leftAnchor.constraint(equalTo: view.leftAnchor)
//        triangle.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Layout.logoWidthMultiplier.rawValue).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: Layout.logoPngHeigh.rawValue/Layout.logoPngWidth.rawValue).isActive = true
        
        mainLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: Layout.mainLabelTopConstraintValue.rawValue).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: Layout.collectionViewTopConstraintValue.rawValue).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Layout.collectionViewBottomConstraintValue.rawValue).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MainCell.self), for: indexPath)
        guard let cell = cell as? MainCell else { return cell }
        let character = charactersData.characters[indexPath.item]
        cell.setup(name: character.name, image: character.photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        charactersData.characters.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else { return }
        let index = findCenterIndex()
        guard let index = index else { return }
        triangle.backgroundColor = colors[index.item]
    }
}
