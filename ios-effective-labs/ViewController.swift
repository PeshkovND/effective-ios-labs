import UIKit
import CollectionViewPagingLayout

final class ViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    let charactersData = CharactersMocks()
    
    let colors: [UIColor] = [.yellow, .blue, .purple, .red, .orange, .green]
    
    var triangle: Triangle!
    
    private func setupCollectionView() {
        let layout = CollectionViewPagingLayout()
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .none
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: String(describing: MainCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    let logoView: UIImageView = {
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
        triangle = Triangle(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        triangle.backgroundColor = colors[0]
        view.addSubview(triangle)
        triangle.addSubview(logoView)
        triangle.addSubview(mainLabel)
        setupCollectionView()
        triangle.addSubview(collectionView)
        setupConstraints()
    }
    
    func findCenterIndex() -> IndexPath? {
        let center = self.view.convert(self.collectionView.center, to: self.collectionView)
        guard let collectionView = collectionView else { return nil }
        let index = collectionView.indexPathForItem(at: center)
        return index
    }

    func setupConstraints() {
        logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        logoView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        logoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        logoView.heightAnchor.constraint(equalTo: logoView.widthAnchor, multiplier: 303/1024).isActive = true
        
        mainLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 10).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 30).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
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
