import Foundation
import Alamofire

final class DetailsViewModel {

    struct Model {
        let imageUrl: URL?
        let name: String
        let description: String
    }

    let db = DBManager()
    
    func fetchOneCharacter(id: Int, completition: @escaping ((Model, Bool) -> Void), failure: @escaping (() -> Void)){

        let login = ApiParams(ts: "1", apikey: "9e1625adec3543f712c47407f1c3e422", hash: "33421d5e5ba0b96d2f20d5777a2d3a5a", limit: "1", offset: "0")
        AF.request("https://gateway.marvel.com/v1/public/characters/\(id)", parameters: login).responseDecodable(of: ApiResponce.self) { response in
            switch response.result {
            case .success(_):
                if let response = response.value?.data.results[0] {
                    let url = "\(response.thumbnail.path).\(response.thumbnail.ext)"
                    self.db.saveToDetailsCharactersCollection(id: response.id, name: response.name, imageUrl: url, details: response.description)
                    let result = Model(imageUrl: URL(string: url), name: response.name, description: response.description)
                    completition(result, true)
                }
            case .failure(_):
                let dbData = self.db.getOneCharacters(id: id)
                if let dbData = dbData {
                    let result = Model(imageUrl: URL(string: dbData.imageUrl), name: dbData.name, description: dbData.details)
                    completition(result, false)
                }
                else {
                    failure()
                }
            }
        }
    }
}
