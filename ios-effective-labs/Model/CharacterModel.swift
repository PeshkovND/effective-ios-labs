import Foundation
import RealmSwift

@objcMembers
class CharacterModel: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var imageUrl: String
    
    convenience init(id: Int, name:String, imageUrl: String) {
        self.init()
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }}
