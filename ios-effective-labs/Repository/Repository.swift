import Foundation
import Alamofire

protocol CharactersRepository {
    func fetchCharactersList(offset: Int, closure: @escaping (Result<(data: [MainViewCharacter], isOnline: Bool, count: Int), Error>) -> Void)
//    func fetchCharactersDetail(insectId: Int, closure: @escaping ((Result<MainViewCharacter, Error>) -> Void))
}

final class CharactersRepositoryImpl: CharactersRepository {
    
    let db = DBManager()
    
    func fetchCharactersList(offset: Int, closure: @escaping (Result<(data: [MainViewCharacter], isOnline: Bool, count: Int), Error>) -> Void) {
        let login = ApiParams(ts: "1", apikey: "9e1625adec3543f712c47407f1c3e422", hash: "33421d5e5ba0b96d2f20d5777a2d3a5a", limit: "10", offset: String(offset))
        
        AF.request("https://gateway.marvel.com/v1/public/characters", parameters: login).responseDecodable(of: ApiResponce.self) { response in
            switch response.result {
            case .success(_):
                if let response = response.value {
                    let result = response.data.results.map { (elem) -> MainViewCharacter in
                        let url = "\(elem.thumbnail.path).\(elem.thumbnail.ext)"
                        self.db.saveToAllCharactersCollection(id: elem.id, name: elem.name, imageUrl: url)
                        return MainViewCharacter(id: elem.id, imageUrl: URL(string: url), name: elem.name)
                    }
                    closure(.success((data: result, isOnline: true, count: response.data.total)))
                }
            case let .failure(error):
                let dbData = self.db.getAllCharacters()
                if dbData.isEmpty {
                    closure(.failure(error))
                    return
                }
                let result = dbData.map { (elem) -> MainViewCharacter in
                    MainViewCharacter(id: elem.id, imageUrl: URL(string: elem.imageUrl), name: elem.name)
                }
                closure(.success((data: result, isOnline: false, count: result.count)))
            }
        }
}
}
