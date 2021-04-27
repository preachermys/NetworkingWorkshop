//
//  TrainingCVCell.swift
//  Rubilix
//
//  Created by Sergiy Sobol on 19.01.18.
//  Copyright © 2018 Andersen. All rights reserved.
//

import UIKit

final class TrainingCVCell: UICollectionViewCell {
    
	@IBOutlet private weak var hoverView: UIView!
	@IBOutlet private weak var topImage: UIImageView!
	@IBOutlet private weak var shadowView: UIView!
	@IBOutlet private weak var containerView: UIView!
	@IBOutlet private weak var subtitleLabel: UILabel!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var progressLabel: GradientLabel!
	@IBOutlet private weak var cardsCount: UILabel!
	
	func prepareCell(trainingModel: TrainingEntity?) {
                
        topImage?.setSuitableImage(from: trainingModel)
		subtitleLabel.text = trainingModel?.description
		titleLabel.text = trainingModel?.title
        cardsCount.text = "\(trainingModel?.cardIds.count ?? 0)"
		shadowView.dropShadow()
		shadowView.layer.cornerRadius = 10
		containerView.layer.cornerRadius = 10

        let progress = Int(trainingModel?.progress ?? 0)
        if progress > 0 {
            progressLabel.alpha = 1
            progressLabel.text = "   " + "\(progress)%" + "   "
            if progress != 100 {
            progressLabel.applyGradient(colors:
				[UIColor(red: 0.37, green: 0.78, blue: 1, alpha: 1).cgColor,
				 UIColor(red: 0.19, green: 0.58, blue: 1, alpha: 1).cgColor])
            } else {
                progressLabel.applyGradient(colors:
                    [UIColor(red: 0.54, green: 0.91, blue: 0.52, alpha: 1).cgColor,
                     UIColor(red: 0.32, green: 0.79, blue: 0.3, alpha: 1).cgColor])
            }
		} else {
			progressLabel.alpha = 0
		}
	}
}

extension TrainingCVCell: ReuseIdentifying { }

extension UIView {
    // swiftlint:enable valid_ibinspectable

    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 5
    }
}
