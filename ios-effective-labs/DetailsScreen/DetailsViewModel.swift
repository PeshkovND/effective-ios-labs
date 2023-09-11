import Foundation
import Alamofire

protocol DetailsViewModel: AnyObject {
    var onChangeViewState: ((DetailsViewState) -> Void)? { get set }
    func start()
    func onRetryButtonClick()
}

final class DetailsViewModelImpl: DetailsViewModel {
    
    var onChangeViewState: ((DetailsViewState) -> Void)?
    
    private let repository: CharactersRepository
    private let id: Int
    
    init(id: Int, repository: CharactersRepository) {
        self.repository = repository
        self.id = id
    }
    
    func onRetryButtonClick() {
        fetchCharacter()
    }
    
    func start() {
        fetchCharacter()
    }
    
    private func fetchCharacter() {
        onChangeViewState?(.loading)
        repository.fetchOneCharacter(id: self.id)
        {[weak self] result in
            switch result {
            case .success(let results):
                self?.onChangeViewState?(.loaded(results))
            case .failure(let error as MyCustomError):
                switch error {
                case .offlineMainViewData(_):
                    break
                case .offlineDetailsViewData(let result):
                    self?.onChangeViewState?(.offline(result))
                }
            case .failure(_):
                self?.onChangeViewState?(.error)
            }
        }
    }
}
