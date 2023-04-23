import Foundation
import Alamofire

protocol CharactersRepository {
    func fetchCharactersList(offset: Int, closure: @escaping (Result<(data: [MainViewCharacter], isOnline: Bool, count: Int), Error>) -> Void)
    func fetchOneCharacter(id: Int, closure: @escaping (Result<(data: DetailsViewCharacter, isOnline: Bool), Error>) -> Void)
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
    func fetchOneCharacter(id: Int, closure: @escaping (Result<(data: DetailsViewCharacter, isOnline: Bool), Error>) -> Void){

        let login = ApiParams(ts: "1", apikey: "9e1625adec3543f712c47407f1c3e422", hash: "33421d5e5ba0b96d2f20d5777a2d3a5a", limit: "1", offset: "0")
        AF.request("https://gateway.marvel.com/v1/public/characters/\(id)", parameters: login).responseDecodable(of: ApiResponce.self) { response in
            switch response.result {
            case .success(_):
                if let response = response.value?.data.results[0] {
                    let url = "\(response.thumbnail.path).\(response.thumbnail.ext)"
                    self.db.saveToDetailsCharactersCollection(id: response.id, name: response.name, imageUrl: url, details: response.description)
                    let result = DetailsViewCharacter(imageUrl: URL(string: url), name: response.name, description: response.description)
                    closure(.success((data: result, isOnline: true)))
                }
            case let .failure(error):
                let dbData = self.db.getOneCharacters(id: id)
                if let dbData = dbData {
                    let result = DetailsViewCharacter(imageUrl: URL(string: dbData.imageUrl), name: dbData.name, description: dbData.details)
                    closure(.success((data: result, isOnline: false)))
                }
                else {
                    closure(.failure(error))
                }
            }
        }
    }
}

struct ApiResponce: Codable {

  var code            : Int
  var status          : String
  var data            : Data

  enum CodingKeys: String, CodingKey {

    case code            = "code"
    case status          = "status"
    case data            = "data"
  }

}

struct Data: Codable {

  var offset  : Int
  var limit   : Int
  var total   : Int
  var count   : Int
  var results : [Results]

  enum CodingKeys: String, CodingKey {

    case offset  = "offset"
    case limit   = "limit"
    case total   = "total"
    case count   = "count"
    case results = "results"
  
  }
}

struct Results: Codable {

  var id          : Int
  var name        : String
  var description : String
  var thumbnail   : Thumbnail

  enum CodingKeys: String, CodingKey {

    case id          = "id"
    case name        = "name"
    case description = "description"
    case thumbnail   = "thumbnail"
  
  }
}

struct Thumbnail: Codable {

  var path: String
  var ext: String

  enum CodingKeys: String, CodingKey {
    case path      = "path"
    case ext = "extension"
  }
}

struct ApiParams: Encodable {
    let ts: String
    let apikey: String
    let hash: String
    let limit: String
    let offset: String
}

