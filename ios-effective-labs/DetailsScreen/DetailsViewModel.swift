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
        repository.fetchOneCharacter(id: self.id, closure:
                                        {[weak self] result in
                                            switch result {
                                                case .success(let results):
                                                    if (results.isOnline){
                                                        self?.onChangeViewState?(.loaded(results.data))}
                                                    else {
                                                        self?.onChangeViewState?(.offline(results.data))
                                                    }
                                                case .failure:
                                                    self?.onChangeViewState?(.error)
                                            }
        })
    }
}
