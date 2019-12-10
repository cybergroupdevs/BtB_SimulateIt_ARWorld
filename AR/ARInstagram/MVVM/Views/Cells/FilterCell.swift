

import Foundation
import UIKit

class FilterCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    
    var representedAssetIdentifier: String!
    
    var hasBorder = false {
        didSet {
            hasBorder ? showBorder() : removeBorder()
        }
    }
    
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        removeBorder()
    }
}
