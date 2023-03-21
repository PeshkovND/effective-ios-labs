import Foundation
import Alamofire

final class DetailsViewModel {

    struct Model {
        let imageUrl: URL?
        let name: String
        let description: String
    }

    var data: Model? = nil

    func fetchOneCharacter(id: Int, completition: @escaping ((Model)-> Void)){

        let login = ApiParams(ts: "1", apikey: "9e1625adec3543f712c47407f1c3e422", hash: "33421d5e5ba0b96d2f20d5777a2d3a5a", limit: "1")
        AF.request("https://gateway.marvel.com/v1/public/characters/\(id)", parameters: login).responseDecodable(of: ApiResponce.self) { response in
            switch response.result {
            case .success(_):
                if let response = response.value?.data.results[0] {
                    let character = Character(id: response.id, name: response.name, imageUrl: URL(string: "\(response.thumbnail.path).\(response.thumbnail.ext)"), description: response.description)
                    self.data = Model(imageUrl: character.imageUrl, name: character.name, description: character.description)
                    guard let data = self.data else { return }
                    completition(data)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
