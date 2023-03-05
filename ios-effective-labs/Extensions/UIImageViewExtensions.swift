import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setImageUrl(url: URL?) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url,
                         options: [
                        .cacheOriginalImage,
                        ])
    }
}
