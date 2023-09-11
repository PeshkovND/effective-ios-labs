//
//  CharacterDetailsModel.swift
//  ios-effective-labs
//
//  Created by test on 11.04.2023.
//

import Foundation
import RealmSwift

@objcMembers
class CharacterDetailsModel: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var imageUrl: String
    @Persisted var details: String
    
    convenience init(id: Int, name:String, imageUrl: String, details: String) {
        self.init()
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.details = details
    }}
