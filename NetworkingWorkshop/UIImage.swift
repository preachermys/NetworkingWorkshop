//
//  UIImage.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 05.04.2021.
//

import UIKit
import SDWebImage

extension UIImage {
    static var playVideoImage: UIImage {
        return UIImage(named: "playVideo")!
    }

    static var lowLevelFullImage: UIImage {
        return UIImage(named: "lowLevelFull")!
    }

    static var heightLevelFullImage: UIImage {
        return UIImage(named: "heightLevelFull")!
    }

    static var tagUnselectedImage: UIImage {
        return UIImage(named: "tag_unselected")!
    }

    static var tagSelectedImage: UIImage {
        return UIImage(named: "tag_selected")!
    }
    
    enum AudioPlayer {
        static var playButton: UIImage = UIImage(named: "play_audio")!
        static var pauseButton: UIImage = UIImage(named: "pause")!
    }
}

extension UIImage {
    public func base64() -> String {
        var imageData: Data
        imageData = self.jpegData(compressionQuality: 0.8)!
        return imageData.base64EncodedString()
    }
}

extension UIImageView {
    public func sd_setImageWithURLWithFade(url: URL!, placeholderImage placeholder: UIImage!) {

        self.sd_setImage(with: url, placeholderImage: placeholder, options: []) { (image, _, cacheType, _) -> Void in

            if let downLoadedImage = image {
                if cacheType == .none {
                    self.alpha = 0
                    UIView.transition(with: self, duration: 0.7,
                                      options: UIView.AnimationOptions.transitionCrossDissolve, animations: { () -> Void in
                        self.image = downLoadedImage
                        self.alpha = 1
                    }, completion: nil)

                }
            } else {
                self.image = placeholder
            }
        }
    }
}
