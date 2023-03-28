import Foundation
import Alamofire

final class MainViewModel {
    
    struct Model {
        let id: Int
        let imageUrl: URL?
        let name: String
    }

    var data: [Model]? = nil
    
    func fetchData(completition: @escaping (([Model])-> Void)){
        let login = ApiParams(ts: "1", apikey: "9e1625adec3543f712c47407f1c3e422", hash: "33421d5e5ba0b96d2f20d5777a2d3a5a", limit: "10")
        
        AF.request("https://gateway.marvel.com/v1/public/characters", parameters: login).responseDecodable(of: ApiResponce.self) { response in
            switch response.result {
            case .success(_):
                if let response = response.value {
                    self.data = response.data.results.map { (elem) -> Model in
                        Model(id: elem.id, imageUrl: URL(string: "\(elem.thumbnail.path).\(elem.thumbnail.ext)"), name: elem.name)
                    }
                    guard let data = self.data else { return }
                    completition(data)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
