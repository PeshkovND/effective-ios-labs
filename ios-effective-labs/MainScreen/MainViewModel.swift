import Foundation
import Alamofire

protocol MainViewModel: AnyObject {
    
    var onChangeViewState: ((MainViewState) -> Void)? { get set }
    func start()
    func onLastCellVisible()
    func onPullToRefresh()
    func onCellButtonClick()
    func onRetryButtonClick()
    func getAllDataCount() -> Int
    func getLocalDataCount() -> Int
    func getHeroes() -> [MainViewCharacter]
}

final class MainViewModelImpl: MainViewModel {
    private var offset = 0
    private var heroes: [MainViewCharacter] = []
    private var allCount = 0
    
    var onChangeViewState: ((MainViewState) -> Void)?
    
    private let repository: CharactersRepository
    
    func getAllDataCount() -> Int {
        return self.allCount
    }
    
    func getLocalDataCount() -> Int {
        return self.heroes.count
    }
    
    func getHeroes() -> [MainViewCharacter] {
        return self.heroes
    }
    
    init(repository: CharactersRepository) {
        self.repository = repository
    }
    
    func start() {
        fetchCharacters()
    }
    
    func onLastCellVisible() {
        fetchCharacters()
    }
    
    func onPullToRefresh() {
        self.offset = 0
        self.heroes = []
        self.allCount = 0
        self.onChangeViewState?(.loaded(MainViewController.Model(characters: self.heroes,
                                                                 count: self.allCount)))
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
        repository.fetchCharactersList(offset: self.offset) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let results):
                self.allCount = results.count
                let resData = self.heroes + results.characters
                if(self.offset != 0) {
                    self.heroes = resData
                    self.onChangeViewState?(.updated(MainViewController.Model(characters: resData,
                                                                              count: self.allCount)))
                }
                else {
                    self.heroes = resData
                    self.onChangeViewState?(.loaded(MainViewController.Model(characters: resData,
                                                                             count: self.allCount)))}
                self.offset += 10
            case .failure(let error as MyCustomError):
                switch error {
                case .offlineMainViewData(let result):
                    let resData = self.heroes + result.characters
                    self.heroes = resData
                    self.allCount = resData.count
                    self.onChangeViewState?(.offline(
                        MainViewController.Model(characters: resData, count: resData.count)))
                case .offlineDetailsViewData(_):
                    break
                }
            case .failure(_):
                if self.heroes.count == 0 {
                    self.onChangeViewState?(.error)
                }
                else {
                    self.onChangeViewState?(.updatingError)
                }
            }
        }
    }
}
