import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setImageUrl(url: URL?, complition: ((UIImage) -> Void)? = nil) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url,
                         options: [
                        .cacheOriginalImage,
                        ],
                         completionHandler: { result in
                            switch result {
                            case .success(let value):
                                self.image = value.image
                            case .failure(let error):
                                self.image = UIImage(named: "error")
                                print(error)
                            }
                        })
    }
}
