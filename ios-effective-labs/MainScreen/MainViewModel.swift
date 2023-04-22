import Foundation
import Alamofire

final class MainViewModel {
    
    struct Model {
        let id: Int
        let imageUrl: URL?
        let name: String
    }
    
    var db = DBManager()
    
    func fetchData(offset: Int, completition: @escaping (([Model], Int, Bool)-> Void), failure: @escaping (()-> Void)){ // closure parametrs
        let login = ApiParams(ts: "1", apikey: "9e1625adec3543f712c47407f1c3e422", hash: "33421d5e5ba0b96d2f20d5777a2d3a5a", limit: "10", offset: String(offset))
        
        AF.request("https://gateway.marvel.com/v1/public/characters", parameters: login).responseDecodable(of: ApiResponce.self) { response in
            switch response.result {
            case .success(_):
                if let response = response.value {
                    let result = response.data.results.map { (elem) -> Model in
                        let url = "\(elem.thumbnail.path).\(elem.thumbnail.ext)"
                        self.db.saveToAllCharactersCollection(id: elem.id, name: elem.name, imageUrl: url)
                        return Model(id: elem.id, imageUrl: URL(string: url), name: elem.name)
                    }
                    let count = response.data.total
                    completition(result, count, true)
                }
            case .failure(_):
                let dbData = self.db.getAllCharacters()
                if dbData.isEmpty {
                    failure()
                    return
                }
                let result = dbData.map { (elem) -> Model in
                    Model(id: elem.id, imageUrl: URL(string: elem.imageUrl), name: elem.name)
                }
                completition(result, result.count, false)
            }
        }
        
    }
}
