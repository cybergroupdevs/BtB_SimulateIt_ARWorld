
import Foundation
import UIKit
import PhotosUI
import Gallery
import Lightbox
import SVProgressHUD

extension TilesLayoutViewController: GalleryControllerDelegate, LightboxControllerDismissalDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        //controller.dismiss(animated: true, completion: nil)
        
        Image.resolve(images: images) { [weak self ] uiimages in
            self?.processImages(images: uiimages)
        }
    }
    
    func processImages(images: [UIImage?]) {
        
        self.selectedImages = images
        
        switch topSelectedCellItem {
        case is SingleTileCell:
            if let image = images[0] {
                (topSelectedCellItem as? SingleTileCell)?.set(image: image)
            }
            if images.count == 1 {
                    goARTapped(UIBarButtonItem())
            }
        case is DiagonalTilesCell:
            (topSelectedCellItem as? DiagonalTilesCell)?.set(images: images)
            if images.count == 3 {
                    goARTapped(UIBarButtonItem())
            }
        default:
            break
        }
    }
    
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        LightboxConfig.DeleteButton.enabled = true
        
        SVProgressHUD.show()
        Image.resolve(images: images, completion: { [weak self] resolvedImages in
            SVProgressHUD.dismiss()
            self?.showLightbox(images: resolvedImages.compactMap({ $0 }))
        })
    }
    
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        gallery?.dismiss(animated: true)
        topSelectedCellItem?.removeFromSuperview()
        blockingWhiteView?.alpha = 0
    }
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        gallery?.dismiss(animated: true)
        topSelectedCellItem?.removeFromSuperview()
        blockingWhiteView?.alpha = 0
    }
    
    // MARK: - Helper
    
    func showLightbox(images: [UIImage]) {
        guard images.count > 0 else {
            return
        }
        
        let lightboxImages = images.map({ LightboxImage(image: $0) })
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        lightbox.dismissalDelegate = self
        
        gallery?.present(lightbox, animated: true, completion: nil)
    }
}
