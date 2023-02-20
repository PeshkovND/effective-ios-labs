import Foundation

final class CharactersMocks {
    var characters = [Character]()
    
    init() {
        setupCharacters()
    }
    
    private func setupCharacters() {
        let ch1 = Character(name: "Iron Man", photo: "ironMan")
        let ch2 = Character(name: "Thor", photo: "thor")
        let ch3 = Character(name: "Thanos", photo: "thanos")
        let ch4 = Character(name: "Spider-Man", photo: "spiderMan")
        let ch5 = Character(name: "Rocket", photo: "rocket")
        let ch6 = Character(name: "Hulk", photo: "hulk")
        self.characters = [ch1, ch2, ch3, ch4, ch5, ch6]
    }
}
