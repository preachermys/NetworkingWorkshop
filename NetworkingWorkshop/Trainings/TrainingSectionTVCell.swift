//
//  TrainingSectionTVCell.swift
//  Rubilix
//
//  Created by Sergiy Sobol on 21.01.18.
//  Copyright © 2018 Andersen. All rights reserved.
//

import UIKit

final class TrainingSectionTVCell: UITableViewCell {
    private enum Constants {
        enum Image {
            static let selectedStar = "star_selected"
            static let unselectedStar = "Star"
        }
    }

	typealias AddFavoritesCallback = (Bool, Int) -> Void
    typealias ShareCompletion = (Int) -> Void
	@IBOutlet private weak var shadowView: UIView!
	@IBOutlet private weak var avatarImage: UIImageView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var descriptionLabel: AttributedLabel!
	@IBOutlet private weak var cardsCount: UILabel!
	@IBOutlet private weak var containerView: UIView!
//    @IBOutlet private weak var tagView: HTagView!
//	@IBOutlet private weak var addToFavoriteView: AddToFavoriteView!
//	@IBOutlet private weak var addToWishListImage: UIImageView!
	@IBOutlet private weak var progressLabel: GradientLabel!
//	@IBOutlet private weak var feedTypeIcon: GradientImage!
//	@IBOutlet private weak var taskProgressView: TaskProgressView!
    @IBOutlet private weak var ratingImage: UIImageView!
    @IBOutlet private weak var ratingDescription: UILabel!
    
	var taskEntity: TaskEntity?
    var trainingModel: TrainingEntity?
    let cornerRadius: CGFloat = 10
    var cellIndex: Int?
    var addFavoritesCallback: AddFavoritesCallback?
    var shareCompletion: ShareCompletion?
    let secondsInMinute: Int16 = 60
    var tags: [String]?
    
    weak var reloadDelegate: RowReloaderProtocol?
//    weak var openDelegate: OpenCardProtocol?

    func prepareView(
        trainingModel: TrainingEntity,
        cellIndex: Int
//        addFavoritesCallback: @escaping AddFavoritesCallback,
//        moreWasTapped: Bool,
//        tapOnLink: @escaping (URL) -> Void
    ) {
        avatarImage.setSuitableImage(from: trainingModel)
        self.tags = trainingModel.tags?.components(separatedBy: " ")
        self.trainingModel = trainingModel
        titleLabel.text = trainingModel.title
		
        var text = (trainingModel.descr ?? "").personalize
        let textWithBullets = text.convertBullets()
        
        descriptionLabel.attributedText = textWithBullets.style(tags: Style.textStyle())
        descriptionLabel.onClick = { [weak self] _, detection in
            
            if detection.style.name == "z" {
                self?.reloadDescription(sender: nil)
            }

            switch detection.type {
            case .tag(let tag):
                if
                    tag.name == "a",
                    let href = tag.attributes["href"],
                    let url = href.createUrlFromString() {
//                    tapOnLink(url)
                }
            default:
                break
            }
        }
        
        if descriptionLabel.labelLines() > 2 {
            let recognizerThree = UITapGestureRecognizer(target: self, action: #selector(reloadDescription(sender:)))
            descriptionLabel.addGestureRecognizer(recognizerThree)
            recognizerThree.delegate = self
            descriptionLabel.isUserInteractionEnabled = true
        }
        
//        moreWasTapped
//            ? (descriptionLabel.numberOfLines = 0)
//            : (descriptionLabel.numberOfLines = 2)
        
        descriptionLabel.truncatedText(cardText: (trainingModel.descr ?? "").personalize)
        cardsCount.text = "\(trainingModel.cardIds.count)"
		containerView.clipsToBounds = true
		containerView.layer.cornerRadius = cornerRadius
		shadowView.layer.cornerRadius = cornerRadius
		shadowView.dropShadow()
        
//        if taskEntity != nil {
//            addToFavoriteView.isHidden = true
//            addToFavoriteView.heightAnchor.constraint(equalToConstant: 0).isActive = true
//        } else {
//            addToFavoriteView.delegate = self
//            addToFavoriteView.hideLikeButton = true
//            addToFavoriteView.favoritedCount = Int(trainingModel.favoritesCount)
//            addToFavoriteView.isFavorited = trainingModel.isFavorited
//
//            addToFavoriteView.configureSharing(
//                isHidden: !trainingModel.isShareable,
//                isShare: trainingModel.isShare,
//                sharesCount: trainingModel.referralSharesCount
//            )
//
//            self.addFavoritesCallback = addFavoritesCallback
//            addToFavoriteView.likesCount = Int(trainingModel.likesCount)
//            addToFavoriteView.isLiked = trainingModel.isLiked
//        }

		self.cellIndex = cellIndex
//		addToWishListImage.isHidden = true
//
//        setTagView()
        setProgress()

//        feedTypeIcon.applyGradient(colors:
//            [UIColor(red: 1, green: 0.47, blue: 0.47, alpha: 1).cgColor,
//             UIColor(red: 1, green: 0.31, blue: 0.31, alpha: 1).cgColor])
 
//		if taskEntity != nil {
//			taskProgressView.isHidden = false
//			taskProgressView.update(task: taskEntity!)
//		} else {
//			taskProgressView.isHidden = true
//		}
        
//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
//        let recognizerTwo = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
//        avatarImage.addGestureRecognizer(recognizerTwo)
//        titleLabel.addGestureRecognizer(recognizer)
//        avatarImage.isUserInteractionEnabled = true
//        titleLabel.isUserInteractionEnabled = true
        
        setRating()
	}
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isKind(of: UIControl.self))! && (touch.view as? AttributedLabel.DetectionAreaButton)?.detection.style.name != "z" {
            return false
        } else {
            return true
        }
    }
    
    private func setRating() {
        if let ratingCount = trainingModel?.ratingCount, Int(ratingCount) >= 3,
            let rating = trainingModel?.rating {
            
            let pluralString = "marks_count_key".makePluralString(with: Int(ratingCount))
            
            ratingImage.image = UIImage(named: Constants.Image.selectedStar)
            ratingDescription.text = String(format: "%.1lf", rating) + " " + "(\(pluralString))"
        } else {
            ratingImage.image = UIImage(named: Constants.Image.unselectedStar)
            ratingDescription.text = "not_enough_grades"
        }
    }
    
//    private func setTagView() {
//        tagView.tagFont = UIFont(name: "SFUIText-Regular", size: 15)!
//        tagView.marg = 0
//        tagView.btwTags = 0
//        tagView.btwLines = -20
//
//        tagView.tagSecondTextColor = UIColor.colorWithRedValue(
//            redValue: 16,
//            greenValue: 127, blueValue: 255,
//            alpha: 1.0
//        )
//
//        tagView.tagSecondBackColor = UIColor.clear
//        tagView.tagMainTextColor = UIColor.colorWithRedValue(redValue: 16, greenValue: 127, blueValue: 255, alpha: 1.0)
//        tagView.tagContentEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 5)
//        tagView.tagMainBackColor = UIColor.clear
//        tagView.tagCornerRadiusToHeightRatio = 0
//        tagView.delegate = self
//        tagView.dataSource = self
//        tagView.multiselect = false
//        tagView.reloadData()
//
//        tagView.selectedIndices.forEach({ (index) in
//            tagView.deselectTagAtIndex(index)
//        })
//    }
    
    private func setProgress() {
        guard let trainingModel = trainingModel else {
            return
        }
        
        var progress = 0
        
        if trainingModel.cardsFinishedIds.count != 0 && trainingModel.cardIds.count != 0 {
            progress = Int(round((Float((Set(trainingModel.cardsFinishedIds).count)) /
                Float((trainingModel.cardIds.count))) * 100))
        }

        if progress > 100 {
            progress = 100
        }
        
        if progress > 0 && taskEntity == nil {
            progressLabel.alpha = 1
            progressLabel.text = "  " + "ПРОЙДЕНО" + ": \(progress)%  "
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

//    @objc func handleTap(sender: UITapGestureRecognizer?) {
//        openDelegate?.open(row: cellIndex!, taskId: taskEntity?.id, trainingId: trainingModel?.id)
//    }

    @objc func reloadDescription(sender: UITapGestureRecognizer?) {
        descriptionLabel.numberOfLines = descriptionLabel.numberOfLines == 0 ? 2 : 0
        descriptionLabel.truncatedText(cardText: (trainingModel?.descr ?? "").personalize)
        reloadDelegate?.updateRow(row: cellIndex!)
    }
    
    @IBAction func moreTapped(_ sender: UIButton) {
        descriptionLabel.numberOfLines = descriptionLabel.numberOfLines == 0 ? 2 : 0
        reloadDelegate?.updateRow(row: cellIndex!)
    }
}

// MARK: - HTagViewDataSource
//extension TrainingSectionTVCell: HTagViewDelegate, HTagViewDataSource {
//    func numberOfTags(_ tagView: HTagView) -> Int {
//        return tags != nil ?  tags != nil ?  tags!.count : 0 : 0
//    }
//
//    func tagView(_ tagView: HTagView, titleOfTagAtIndex index: Int) -> String {
//        if tags?.isEmpty ?? true || tags?.first?.isEmpty ?? true {
//            return .emptyLine
//        }
//
//        return "#" + String(tags![index])
//    }
//
//    func tagView(_ tagView: HTagView, tagTypeAtIndex index: Int) -> HTagType {
//        return .select
//    }
//
//    func tagView(_ tagView: HTagView, tagWidthAtIndex index: Int) -> CGFloat {
//        return .HTagAutoWidth
//    }
//
//    func tagView(_ tagView: HTagView, didCancelTagAtIndex index: Int) {
//        tagView.reloadData()
//    }
//}

//extension TrainingSectionTVCell: AddToFavoriteViewDelegate {
//	func addToFavorite() {
//		if let favoriteButtonTap = addFavoritesCallback {
//            favoriteButtonTap(true, cellIndex!)
//		}
//	}
//
//	func removeFromFavorite() {
//		if let favoriteButtonTap = addFavoritesCallback {
//			favoriteButtonTap(false, cellIndex!)
//		}
//	}
//
//    func shareCard() {
//        guard let cellIndex = cellIndex else { return }
//        shareCompletion?(cellIndex)
//    }
//}

extension TrainingSectionTVCell: ReuseIdentifying { }
