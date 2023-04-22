import Foundation
import Alamofire

protocol MainViewModel: AnyObject {
    
    var onChangeViewState: ((MainViewState) -> Void)? { get set }
    func start()
    func paggingUpdate()
    func onPullToRefresh()
    func onCellButtonClick()
    func onRetryButtonClick()
}

final class MainViewModelImpl: MainViewModel {
    var offset = 0
    var heroes: [MainViewCharacter] = []
    var allCount = 0
    
    var onChangeViewState: ((MainViewState) -> Void)?
    
    private let repository: CharactersRepository
    
    init(repository: CharactersRepository) {
        self.repository = repository
    }
    
    func start() {
        fetchCharacters()
    }
    
    func paggingUpdate() {
        fetchCharacters()
    }
    
    func onPullToRefresh() {
        self.offset = 0
        self.heroes = []
        self.allCount = 0
        fetchCharacters()
    }
    
    func onCellButtonClick() {
        fetchCharacters()
    }
    
    func onRetryButtonClick() {
        fetchCharacters()
    }
    
    private func fetchCharacters() {
        if offset == 0 {
            onChangeViewState?(.loading)
        } else {
            onChangeViewState?(.updating)
        }
        repository.fetchCharactersList(offset: self.offset, closure:
                                        {[weak self] result in
                                            switch result {
                                                case .success(let results):
                                                    self?.allCount = results.count
                                                    guard let heroes = self?.heroes else { return }
                                                    guard let allCount = self?.allCount else { return }
                                                    guard let offset = self?.offset else { return }
                                                    let resData = heroes + results.data
                                                    if (results.isOnline){
                                                        if(offset != 0) {
                                                            self?.heroes = resData
                                                            self?.onChangeViewState?(.updated(data: resData, allDataCount: allCount, localDataCount: resData.count))
                                                        }
                                                        else {
                                                            self?.heroes = resData
                                                            self?.onChangeViewState?(.loaded(data: resData, allDataCount: allCount, localDataCount: resData.count))}
                                                    }
                                                    else {
                                                        if (offset != 0) {
                                                            print("erorred")
                                                            self?.onChangeViewState?(.updatingError)
                                                            self?.offset -= 10
                                                        }
                                                        else {
                                                            self?.heroes = resData
                                                            self?.onChangeViewState?(.offline(data: resData, allDataCount: allCount, localDataCount: resData.count))
                                                        }
                                                    }
                                                    self?.offset += 10
                                                case .failure:
                                                    guard let offset = self?.offset else { return }
                                                    if offset <= 10 {
                                                        self?.onChangeViewState?(.error)
                                                    }
                                                else {
                                                    self?.onChangeViewState?(.updatingError)
                                                }
                                            }
        })
    }
}
