import UIKit
import Alamofire

enum DetailsViewState {
    case loading
    case loaded(DetailsViewController.Model)
    case error
    case offline(DetailsViewController.Model)
}

struct DetailsViewCharacter: Hashable {
    let imageUrl: URL?
    let name: String
    let description: String
}

final class DetailsViewController: UIViewController {
    
    struct Model {
        let character: DetailsViewCharacter
    }
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let viewModel: DetailsViewModel
    
    private enum Layout {
        static let labelAndTextLeftRightConstrintValue = CGFloat(32)
        static let detailsDescriptionTextViewBottomConstraintValue = CGFloat(16)
        static let detailsDescriptionTextViewHeightConstraintMultiplier = CGFloat(0.4)
    }
    
    private let detailsImageView: UIImageView = {
        let detailsImageView = UIImageView()
        detailsImageView.translatesAutoresizingMaskIntoConstraints = false
        detailsImageView.contentMode = .scaleAspectFill
        detailsImageView.isUserInteractionEnabled = true
        return detailsImageView
    }()
    
    private let connectionErrorLabel: ConnectionErrorLabel = {
        let connectionErrorLabel = ConnectionErrorLabel()
        connectionErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        return connectionErrorLabel
    }()
    
    private let loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.reloadButton.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
        return loadingView
    }()
    
    private let backBarButtonItem: UIBarButtonItem = {
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = ""
        return backBarButtonItem
    }()
    
    private let detailsLabel: UILabel = {
        let detailsLabel = UILabel()
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.textColor = .white
        detailsLabel.font = UIFont.boldSystemFont(ofSize: 32)
        detailsLabel.numberOfLines = 0
        return detailsLabel
    }()
    
    private let detailsDescriptionTextView: UITextView = {
        let detailsDescription = UITextView()
        detailsDescription.translatesAutoresizingMaskIntoConstraints = false
        detailsDescription.textColor = .white
        detailsDescription.font = UIFont.systemFont(ofSize: 24)
        detailsDescription.backgroundColor = .none
        detailsDescription.isScrollEnabled = true
        detailsDescription.isUserInteractionEnabled = true
        detailsDescription.isEditable = false
        
        return detailsDescription
    }()
    
    @objc private func didButtonClick(_ sender: UIButton) {
        viewModel.onRetryButtonClick()
    }
    
    private func setupLayout() {
        view.addSubview(detailsImageView)
        view.clipsToBounds = true
        detailsImageView.addSubview(detailsLabel)
        detailsImageView.addSubview(detailsDescriptionTextView)
        view.addSubview(loadingView)
        view.addSubview(connectionErrorLabel)
        
        connectionErrorLabel.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor
        ).isActive = true
        connectionErrorLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        connectionErrorLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        detailsImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        detailsImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        detailsImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        detailsImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        detailsDescriptionTextView.bottomAnchor.constraint(
            equalTo: detailsImageView.bottomAnchor,
            constant: -Layout.detailsDescriptionTextViewBottomConstraintValue
        ).isActive = true
        detailsDescriptionTextView.leftAnchor.constraint(
            equalTo: detailsImageView.leftAnchor,
            constant: Layout.labelAndTextLeftRightConstrintValue
        ).isActive = true
        detailsDescriptionTextView.rightAnchor.constraint(
            equalTo: detailsImageView.rightAnchor,
            constant: -Layout.labelAndTextLeftRightConstrintValue
        ).isActive = true
        detailsDescriptionTextView.heightAnchor.constraint(
            equalTo: detailsImageView.heightAnchor,
            multiplier: Layout.detailsDescriptionTextViewHeightConstraintMultiplier
        ).isActive = true
        
        detailsLabel.leftAnchor.constraint(
            equalTo: detailsImageView.leftAnchor,
            constant: Layout.labelAndTextLeftRightConstrintValue
        ).isActive = true
        detailsLabel.rightAnchor.constraint(
            equalTo: detailsImageView.rightAnchor,
            constant: -Layout.labelAndTextLeftRightConstrintValue
        ).isActive = true
        detailsLabel.bottomAnchor.constraint(
            equalTo: detailsDescriptionTextView.topAnchor
        ).isActive = true
        
        loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loadingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loadingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func setupData(_ model: DetailsViewCharacter) {
        detailsImageView.setImageUrl(url: model.imageUrl)
        detailsLabel.text = model.name
        detailsDescriptionTextView.text = model.description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
        setupLayout()
        viewModel.onChangeViewState = { [weak self] state in
            switch state {
            case .loading:
                self?.loadingView.start()
                self?.connectionErrorLabel.hide()
            case .loaded(let data):
                self?.setupData(data.character)
                self?.loadingView.stop()
            case .offline(let data):
                self?.setupData(data.character)
                self?.loadingView.stop()
                self?.connectionErrorLabel.show()
            case .error:
                self?.loadingView.showError()
            }
        }
        viewModel.start()
    }
}
