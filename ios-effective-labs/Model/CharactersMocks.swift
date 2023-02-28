import Foundation
import UIKit
import Kingfisher

final class CharactersMocks {
    var characters = [Character]()
    
    init() {
        setupCharacters()
    }
    
    private func setupCharacters() {
        let ch1 = Character(name: "Iron Man", image: UIImage(named: "ironMan"), description: "Anthony Edward \"Tony\" Stark was a billionaire industrialist, a founding member of the Avengers, and the former CEO of Stark Industries.")
        
        let ch2 = Character(name: "Thor", image: UIImage(named: "thor"), description: "Thor Odinson is the Asgardian God of Thunder, the former king of both Asgard and New Asgard, a founding member of the Avengers, and a former member of the Guardians of the Galaxy.")
        
        let ch3 = Character(name: "Thanos", image: UIImage(named: "thanos"), description: "Thanos was a genocidal warlord from Titan, whose objective was to bring stability to the universe by wiping out half of all life at every level, as he believed its massive population would inevitably use up the universe's entire supply of resources and perish.")
        
        let ch4 = Character(name: "Spider-Man", image: UIImage(named: "spiderMan"), description: "Peter Benjamin Parker is a former Midtown School of Science and Technology student who gained spider-like abilities, fighting crime across New York City as the superhero Spider-Man.")
        
        let ch5 = Character(name: "Rocket", image: UIImage(named: "rocket"), description: "Subject 89P13 is a creature who was genetically enhanced by the High Evolutionary. Dubbed Rocket Raccoon, he traveled the galaxy with his friend Groot, committing crimes and picking up bounties until they met Star-Lord, who convinced them to assist him in selling the Orb, which was being sought after by Ronan the Accuser, for a massive profit.")
        
        let ch6 = Character(name: "Hulk", image: UIImage(named: "hulk"), description: "Doctor Robert Bruce Banner, M.D., Ph.D., is a renowned scientist and a founding member of the Avengers. Highly respected for his work in biochemistry, nuclear physics and gamma radiation, Banner was tasked by Thaddeus Ross to recreate the Super Soldier Serum that created Captain America.")
        
        self.characters = [ch1, ch2, ch3, ch4, ch5, ch6]
    }
    
    private func downloadImage(with urlString : String) -> UIImage? {
        guard let url = URL.init(string: urlString) else { return nil }
        let resource = ImageResource(downloadURL: url)
        var image: UIImage = UIImage()
        
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                image = value.image
            case .failure(_):
                print("error")
            }
        }
        return image
    }
}
