import Foundation
import UIKit

final class CharactersMocks {
    var characters = [Character]()
    
    init() {
        setupCharacters()
    }
    
    private func setupCharacters() {
        let ch1 = Character(characterName: "Iron Man", characterImage: UIImage(named: "ironMan"))
        let ch2 = Character(characterName: "Thor", characterImage: UIImage(named: "thor"))
        let ch3 = Character(characterName: "Thanos", characterImage: UIImage(named: "thanos"))
        let ch4 = Character(characterName: "Spider-Man", characterImage: UIImage(named: "spiderMan"))
        let ch5 = Character(characterName: "Rocket", characterImage: UIImage(named: "rocket"))
        let ch6 = Character(characterName: "Hulk", characterImage: UIImage(named: "hulk"))
        self.characters = [ch1, ch2, ch3, ch4, ch5, ch6]
    }
}
