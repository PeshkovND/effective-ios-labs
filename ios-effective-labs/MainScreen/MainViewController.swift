import UIKit
import CollectionViewPagingLayout
import Alamofire


final class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    
    private enum Layout {
        static let logoWidthMultiplier = CGFloat(0.5)
        static let logoPngHeigh = CGFloat(303)
        static let logoPngWidth = CGFloat(1024)
        static let mainLabelTopConstraintValue = CGFloat(8)
        static let collectionViewTopConstraintValue = CGFloat(24)
        static let collectionViewBottomConstraintValue = CGFloat(-24)
    }
    
    private let layout = CollectionViewPagingLayout()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .none
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: String(describing: MainCell.self))
        return collectionView
    }()
    
    private var charactersData: [MainViewModel.Model] = []
    
    private let colors: [UIColor] = [.yellow, .blue, .purple, .red, .orange, .green]
    
    private let triangleView: TriangleView = {
        let triangleView = TriangleView()
        triangleView.translatesAutoresizingMaskIntoConstraints = false
        return triangleView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private let loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()
    
    private let logoImageView: UIImageView = {
        let logoView = UIImageView()
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.image = UIImage(named: "marvelLogo")
        return logoView
    }()
    
    private let mainLabel: UILabel = {
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
        triangleView.backgroundColor = colors[0]
        collectionView.dataSource = self
        collectionView.delegate = self
        loadingView.start()
        viewModel.fetchData(completition: {[weak self] items in
            self?.charactersData = items
            self?.collectionView.reloadData()
            self?.layout.setCurrentPage(0)
            self?.loadingView.stop()
        })
        setupLayout()
    }

    private func findCenterIndex() -> IndexPath? {
        let center = self.view.convert(self.collectionView.center, to: self.collectionView)
        let index = collectionView.indexPathForItem(at: center)
        return index
    }

    private func setupLayout() {
        view.addSubview(triangleView)
        triangleView.addSubview(logoImageView)
        triangleView.addSubview(mainLabel)
        triangleView.addSubview(collectionView)
        view.addSubview(loadingView)
        
        triangleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        triangleView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        triangleView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        triangleView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Layout.logoWidthMultiplier).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: Layout.logoPngHeigh/Layout.logoPngWidth).isActive = true
        
        mainLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: Layout.mainLabelTopConstraintValue).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: Layout.collectionViewTopConstraintValue).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Layout.collectionViewBottomConstraintValue).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loadingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loadingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MainCell.self), for: indexPath)
        guard let cell = cell as? MainCell else { return cell }
        let character = charactersData[indexPath.item]
        let model = MainCell.Model(name: character.name, imageUrl: character.imageUrl)
        cell.setup(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        charactersData.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else { return }
        let index = findCenterIndex()
        guard let index = index else { return }
        triangleView.backgroundColor = colors[index.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = charactersData[indexPath.item]
        let vc = DetailsViewController()
        vc.fetchCharacterData(id: character.id)
        navigationController?.pushViewController(vc, animated: true)
    }
}