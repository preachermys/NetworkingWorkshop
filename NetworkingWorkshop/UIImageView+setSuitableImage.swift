//
//  UIImageView+setSuitableImage.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 05.04.2021.
//

import UIKit

extension UIImageView {
    func setSuitableImage(from model: CardEntity?, needHighQuality: Bool = false, debugLabels: Bool = false) {
        if let images = model?.images,
            let imageUrl = MediaFormatService.getFormattedImage(from: images as [String],
                                                                needHighQuality: needHighQuality,
                                                                basedOn: self.bounds.width) {
            
            self.sd_setImageWithURLWithFade(url: imageUrl,
                                            placeholderImage: UIImage(named: "DefaultImage"))
            
            if debugLabels {
                self.subviews.forEach { ($0 as? UILabel)?.removeFromSuperview() }
                var versions: String = ""
                
                let suitableVersion = MediaFormatService.findSuitableVersion(in: MediaFormatService.getVersions(from: images as [String]),
                                                                             needHighQuality: needHighQuality,
                                                                             with: self.bounds.width)
                
                MediaFormatService.getVersions(from: images as [String]).forEach { version in
                    suitableVersion == version
                        ? (versions += "\(version)*\n")
                        : (versions += "\(version)\n")
                }
                versions += "image width = \(self.bounds.width * UIScreen.main.scale)"
                
                let diagnosticLabel = UILabel(frame: .zero)
                
                if (self.bounds.width * UIScreen.main.scale) > 500 {
                    diagnosticLabel.font = UIFont.systemFont(ofSize: 12)
                } else {
                    diagnosticLabel.font = UIFont.systemFont(ofSize: 10)
                }
                
                diagnosticLabel.textColor = .white
                diagnosticLabel.numberOfLines = 0
                diagnosticLabel.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(diagnosticLabel)
                
                diagnosticLabel.layer.shadowColor = UIColor.black.cgColor
                diagnosticLabel.layer.shadowRadius = 3.0
                diagnosticLabel.layer.shadowOpacity = 1.0
                diagnosticLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
                diagnosticLabel.layer.masksToBounds = false

                diagnosticLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
                diagnosticLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
                diagnosticLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
                diagnosticLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true

                diagnosticLabel.text = versions
            }
        }
    }
}

