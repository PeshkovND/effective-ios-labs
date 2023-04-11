import Foundation
import RealmSwift

class DBManager {
    let realm = try! Realm(configuration: RealmSwift.Realm.Configuration(
        schemaVersion: 1), queue: nil)
    func save(id: Int, name: String, imageUrl: String) {
        let character = CharacterModel(id: id, name: name, imageUrl: imageUrl)
        try! realm.write{
            realm.add(character, update: .modified)
        }
    }
    
    func getAllCharacters() -> [CharacterModel] {
        let result = realm.objects(CharacterModel.self)
        return Array(result)
    }
}
