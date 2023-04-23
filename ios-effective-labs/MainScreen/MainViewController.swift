import UIKit
import CollectionViewPagingLayout
import Alamofire
import Kingfisher

enum MainViewState {
    case loading
    case loaded(data:[MainViewCharacter], allDataCount: Int, localDataCount: Int)
    case updating
    case updated(data:[MainViewCharacter], allDataCount: Int, localDataCount: Int)
    case updatingError
    case error
    case offline(data:[MainViewCharacter], allDataCount: Int, localDataCount: Int)
}

struct MainViewCharacter: Hashable {
    let id: Int
    let imageUrl: URL?
    let name: String
}

final class MainViewController: UIViewController {
    
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
        collectionView.register(LoadingCell.self, forCellWithReuseIdentifier: String(describing: LoadingCell.self))
        return collectionView
    }()
    
    private var charactersData: [MainViewCharacter] = []
    private var allDataCount: Int?
    private var localDataCount: Int?
    
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
                    break
                case .loaded(let data, let allDataCount, let localDataCount):
                    self?.setupData(data: data, allCount: allDataCount, localCount: localDataCount)
                    self?.layout.setCurrentPage(0)
                    break
                case .offline(let data, let allDataCount, let localDataCount):
                    self?.setupData(data: data, allCount: allDataCount, localCount: localDataCount)
                    self?.layout.setCurrentPage(0)
                    self?.connectionErrorLabel.show()
                    break
                case .updated(let data, let allDataCount, let localDataCount):
                    self?.setupData(data: data, allCount: allDataCount, localCount: localDataCount)
                    break
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
    
    private func setupData(data: [MainViewCharacter], allCount: Int, localCount: Int) {
        self.charactersData = data
        self.collectionView.reloadData()
        self.allDataCount = allCount
        self.localDataCount = localCount
        self.collectionView.performBatchUpdates({
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
        self.loadingView.stop()
        self.refreshControl.endRefreshing()
        let character = self.charactersData[self.layout.currentPage]
        self.changeBackgroundColor(elem: character)
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
        
        connectionErrorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        connectionErrorLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        connectionErrorLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        logoImageView.topAnchor.constraint(equalTo: connectionErrorLabel.bottomAnchor).isActive = true
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch SectionItem(index: indexPath.section) {
        case .item:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MainCell.self), for: indexPath)
            guard let cell = cell as? MainCell else { return cell }
            let character = charactersData[indexPath.item]
            let model = MainCell.Model(name: character.name, imageUrl: character.imageUrl)
            cell.setup(model)
            return cell
        case .loading:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LoadingCell.self), for: indexPath)
            guard let cell = cell as? LoadingCell else { return cell }
            cell.start()
            cell.reloadButton.addTarget(self, action: #selector(didCellButtonClick), for: .touchUpInside)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SectionItem(index: section) {
        case .item:
            guard let count = localDataCount else { return 0 }
            return count
        case .loading:
            return localDataCount == 0 || localDataCount == allDataCount ? 0 : 1
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else { return }
        let index = findCenterIndex()
        guard let index = index else { return }
        if SectionItem(index: index.section) == .loading {
            viewModel.paggingUpdate()
        }
        else {
            let character = charactersData[index.row]
            changeBackgroundColor(elem: character)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard SectionItem(index: indexPath.section) == .item else { return }
        let character = charactersData[indexPath.item]
        let viewModel = DetailsViewModelImpl(id: character.id, repository: CharactersRepositoryImpl())
        let vc = DetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
