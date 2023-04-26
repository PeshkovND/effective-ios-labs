import UIKit
import CollectionViewPagingLayout
import Alamofire
import Kingfisher

enum MainViewState {
    case loading
    case loaded(MainViewController.Model)
    case updating
    case updated(MainViewController.Model)
    case updatingError
    case error
    case offline(MainViewController.Model)
}

struct MainViewCharacter: Hashable {
    let id: Int
    let imageUrl: URL?
    let name: String
}

final class MainViewController: UIViewController {
    
    struct Model {
        let characters: [MainViewCharacter]
        let count: Int
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    private let viewModel: MainViewModel
    
    private enum Layout {
        static let logoWidthMultiplier = CGFloat(0.5)
        static let logoPngHeigh = CGFloat(303)
        static let logoPngWidth = CGFloat(1024)
        static let mainLabelTopConstraintValue = CGFloat(8)
        static let collectionViewTopBottomConstraintValue = CGFloat(24)
        
    }
    
    private let layout = CollectionViewPagingLayout()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .none
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(
            MainCell.self,
            forCellWithReuseIdentifier: String(describing: MainCell.self)
        )
        collectionView.register(
            LoadingCell.self,
            forCellWithReuseIdentifier: String(describing: LoadingCell.self)
        )
        return collectionView
    }()
    
    private let triangleView: TriangleView = {
        let triangleView = TriangleView()
        triangleView.backgroundColor = .red
        triangleView.translatesAutoresizingMaskIntoConstraints = false
        return triangleView
    }()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        refreshControl.tintColor = .red
        return refreshControl
    }()
    
    @objc private func didRefresh(_ sender: UIRefreshControl) {
        viewModel.onPullToRefresh()
    }
    
    @objc private func didButtonClick(_ sender: UIButton) {
        viewModel.onRetryButtonClick()
    }
    
    @objc private func didCellButtonClick(sender: UIButton) {
        viewModel.onCellButtonClick()
    }
    
    private let loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.reloadButton.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
        return loadingView
    }()
    
    private let logoImageView: UIImageView = {
        let logoView = UIImageView()
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.image = UIImage(named: "marvelLogo")
        return logoView
    }()
    
    private let connectionErrorLabel: ConnectionErrorLabel = {
        let connectionErrorLabel = ConnectionErrorLabel()
        connectionErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        return connectionErrorLabel
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
        collectionView.dataSource = self
        collectionView.delegate = self
        viewModel.onChangeViewState = { [weak self] state in
            switch state {
            case .loading:
                self?.connectionErrorLabel.hide()
                self?.loadingView.start()
            case .loaded(let data):
                self?.setupData(data: data)
                if !data.characters.isEmpty {
                    self?.changeBackgroundColor(elem: data.characters.first!)
                }
            case .offline(let data):
                self?.setupData(data: data)
                self?.connectionErrorLabel.show()
                if !data.characters.isEmpty {
                    self?.changeBackgroundColor(elem: data.characters.first!)
                }
            case .updated(let data):
                guard let self = self else { return }
                self.setupData(data: data)
                self.changeBackgroundColor(elem: data.characters[self.layout.currentPage])
            case .updating:
                let loadingCellType: SectionItem = .loading
                let cell = self?.collectionView.cellForItem(at: IndexPath(row: 0, section: loadingCellType.rawValue))
                guard let cell = cell as? LoadingCell else { return }
                cell.start()
            case .updatingError:
                let loadingCellType: SectionItem = .loading
                let cell = self?.collectionView.cellForItem(at: IndexPath(row: 0, section: loadingCellType.rawValue))
                guard let cell = cell as? LoadingCell else { return }
                cell.showError()
            case .error:
                self?.refreshControl.endRefreshing()
                self?.loadingView.showError()
            }
        }
        viewModel.start()
        setupLayout()
    }
    
    private func setupData(data: Model) {
        self.collectionView.reloadData()
        self.collectionView.performBatchUpdates({
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
        self.loadingView.stop()
        self.refreshControl.endRefreshing()
        //        let character = data.characters[self.layout.currentPage]
        //        self.changeBackgroundColor(elem: character)
    }
    
    private func changeBackgroundColor(elem: MainViewCharacter) {
        guard let imageUrl = elem.imageUrl else { return }
        KingfisherManager.shared.retrieveImage(with: imageUrl, options: nil,  completionHandler: {
            result in
            switch result {
            case .success(let result):
                self.triangleView.backgroundColor = result.image.averageColor
            case .failure(_):
                self.triangleView.backgroundColor = .red
            }
        })
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
        view.addSubview(connectionErrorLabel)
        triangleView.refreshControl = refreshControl
        
        triangleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        triangleView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        triangleView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        triangleView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        connectionErrorLabel.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor
        ).isActive = true
        connectionErrorLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        connectionErrorLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        logoImageView.topAnchor.constraint(equalTo: connectionErrorLabel.bottomAnchor).isActive = true
        logoImageView.centerXAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.centerXAnchor
        ).isActive = true
        logoImageView.widthAnchor.constraint(
            equalTo: view.widthAnchor,
            multiplier: Layout.logoWidthMultiplier
        ).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: Layout.logoPngHeigh/Layout.logoPngWidth).isActive = true
        
        mainLabel.topAnchor.constraint(
            equalTo: logoImageView.bottomAnchor,
            constant: Layout.mainLabelTopConstraintValue
        ).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: Layout.collectionViewTopBottomConstraintValue).isActive = true
        collectionView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -Layout.collectionViewTopBottomConstraintValue
        ).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loadingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loadingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }
}

enum SectionItem: Int, CaseIterable {
    case item
    case loading
    
    init(index: Int) {
        switch index {
        case 0:
            self = .item
        case 1:
            self = .loading
        default:
            assertionFailure("Unexpected index: \(index)")
            self = .item
        }
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        SectionItem.allCases.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch SectionItem(index: indexPath.section) {
        case .item:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: MainCell.self),
                for: indexPath
            )
            guard let cell = cell as? MainCell else { return cell }
            let character = viewModel.getHeroes()[indexPath.item]
            let model = MainCell.Model(name: character.name, imageUrl: character.imageUrl)
            cell.setup(model)
            return cell
        case .loading:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: LoadingCell.self),
                for: indexPath)
            guard let cell = cell as? LoadingCell else { return cell }
            cell.start()
            cell.reloadButton.addTarget(self, action: #selector(didCellButtonClick), for: .touchUpInside)
            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let localCount = viewModel.getLocalDataCount()
        let allCount = viewModel.getAllDataCount()
        switch SectionItem(index: section) {
        case .item:
            return localCount
        case .loading:
            return localCount == 0 || localCount == allCount ? 0 : 1
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else { return }
        let index = findCenterIndex()
        guard let index = index else { return }
        if SectionItem(index: index.section) == .loading {
            viewModel.onLastCellVisible()
        }
        else {
            let character = viewModel.getHeroes()[index.row]
            changeBackgroundColor(elem: character)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard SectionItem(index: indexPath.section) == .item else { return }
        let character = viewModel.getHeroes()[indexPath.item]
        let viewModel = DetailsViewModelImpl(id: character.id, repository: CharactersRepositoryImpl())
        let vc = DetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
