import Foundation
import RealmSwift

protocol CharactersDatabase: AnyObject {
    func saveToAllCharactersCollection(id: Int, name: String, imageUrl: String)
    func saveToDetailsCharactersCollection(id: Int, name: String, imageUrl: String, details: String)
    func getAllCharacters() -> [CharacterModel]
    func getOneCharacters(id: Int) -> CharacterDetailsModel?
}

final class DBManager {
    private let realm = try? Realm()
    
    func save<T: Object>(object: T) {
        try? realm?.write {
            realm?.add(object, update: .modified)
        }
    }
    
    func getById<T: Object>(by id: Int) -> T? {
        guard let objectRealm = realm?.object(ofType: T.self, forPrimaryKey: id) else {
            return nil
        }
        return objectRealm
    }
    
    func getAll<T: Object>() -> [T] {
        var objects: [T] = []
        let objectsRealms = realm?.objects(T.self)
        guard let objectsRealms = objectsRealms else { return [] }
        for objectRealm in objectsRealms {
            objects.append(objectRealm)
        }
        return objects
    }
}

extension DBManager: CharactersDatabase {
    func saveToAllCharactersCollection(id: Int, name: String, imageUrl: String) {
        let character = CharacterModel(id: id, name: name, imageUrl: imageUrl)
        save(object: character)
    }
    
    func saveToDetailsCharactersCollection(id: Int, name: String, imageUrl: String, details: String) {
        let character = CharacterDetailsModel(id: id, name: name, imageUrl: imageUrl, details: details)
        save(object: character)
    }
    
    func getAllCharacters() -> [CharacterModel] {
        let result: [CharacterModel] = getAll()
        return result
    }
    
    func getOneCharacters(id: Int) -> CharacterDetailsModel? {
        let result: CharacterDetailsModel? = getById(by: id)
        guard let result = result else { return nil }
        return result
    }
}
