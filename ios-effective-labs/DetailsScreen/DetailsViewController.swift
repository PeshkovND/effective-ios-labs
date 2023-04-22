import UIKit
import Alamofire

final class DetailsViewController: UIViewController {
    
    let viewModel = DetailsViewModel()
    private var id: Int? = nil
    
    private enum Layout {
        static let detailsLabelLeftConstraintValue = CGFloat(32)
        static let detailsLabelRightConstraintValue = CGFloat(-32)
        static let detailsDescriptionTextViewLeftConstraintValue = CGFloat(32)
        static let detailsDescriptionTextViewRightConstraintValue = CGFloat(-32)
        static let detailsDescriptionTextViewBottomConstraintValue = CGFloat(-16)
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
        loadingView.start()
        guard let id = self.id else { return }
        fetchCharacterData(id: id)
    }
    
    private func setupLayout() {
        view.addSubview(detailsImageView)
        view.clipsToBounds = true
        detailsImageView.addSubview(detailsLabel)
        detailsImageView.addSubview(detailsDescriptionTextView)
        view.addSubview(loadingView)
        view.addSubview(connectionErrorLabel)
        
        connectionErrorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        connectionErrorLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        connectionErrorLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        detailsImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        detailsImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        detailsImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        detailsImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        detailsDescriptionTextView.bottomAnchor.constraint(equalTo: detailsImageView.bottomAnchor, constant: Layout.detailsDescriptionTextViewBottomConstraintValue).isActive = true
        detailsDescriptionTextView.leftAnchor.constraint(equalTo: detailsImageView.leftAnchor, constant: Layout.detailsDescriptionTextViewLeftConstraintValue).isActive = true
        detailsDescriptionTextView.rightAnchor.constraint(equalTo: detailsImageView.rightAnchor, constant: Layout.detailsDescriptionTextViewRightConstraintValue).isActive = true
        detailsDescriptionTextView.heightAnchor.constraint(equalTo: detailsImageView.heightAnchor, multiplier: Layout.detailsDescriptionTextViewHeightConstraintMultiplier).isActive = true
        
        detailsLabel.leftAnchor.constraint(equalTo: detailsImageView.leftAnchor, constant: Layout.detailsLabelLeftConstraintValue).isActive = true
        detailsLabel.rightAnchor.constraint(equalTo: detailsImageView.rightAnchor, constant: Layout.detailsLabelRightConstraintValue).isActive = true
        detailsLabel.bottomAnchor.constraint(equalTo: detailsDescriptionTextView.topAnchor).isActive = true
        
        loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loadingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loadingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    private func setupData(_ model: DetailsViewModel.Model) {
        detailsImageView.setImageUrl(url: model.imageUrl)
        detailsLabel.text = model.name
        detailsDescriptionTextView.text = model.description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingView.start()
    }
    
    func fetchCharacterData(id: Int) {
        self.id = id
        viewModel.fetchOneCharacter(id: id,
            completition: {[weak self] item, isConnectionOk in
                self?.setupData(item)
                self?.loadingView.stop()
                if !isConnectionOk {
                    self?.connectionErrorLabel.show()
                }
                                    },
        failure: {[weak self] in
            self?.loadingView.showError()
         })
    }
}
