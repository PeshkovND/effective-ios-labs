import Foundation
import RealmSwift

class DBManager {
    let realm = try! Realm(configuration: RealmSwift.Realm.Configuration(
        schemaVersion: 1), queue: nil)
    func saveToAllCharactersCollection(id: Int, name: String, imageUrl: String) {
        let character = CharacterModel(id: id, name: name, imageUrl: imageUrl)
        try! realm.write{
            realm.add(character, update: .modified)
        }
    }
    
    func saveToDetailsCharactersCollection(id: Int, name: String, imageUrl: String, details: String) {
        let character = CharacterDetailsModel(id: id, name: name, imageUrl: imageUrl, details: details)
        try! realm.write{
            realm.add(character, update: .modified)
        }
    }
    
    func getAllCharacters() -> [CharacterModel] {
        let result = realm.objects(CharacterModel.self)
        return Array(result)
    }
    
    func getOneCharacters(id: Int) -> CharacterDetailsModel? {
        let result = realm.object(ofType: CharacterDetailsModel.self, forPrimaryKey: id)
        return result
    }
}
