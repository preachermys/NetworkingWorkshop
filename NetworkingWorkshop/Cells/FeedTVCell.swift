//
//  FeedTVCell.swift
//  Rubilix
//
//  Created by Sergiy Sobol on 05.01.18.
//  Copyright © 2018 Andersen. All rights reserved.
//

import UIKit

protocol RowReloaderProtocol: class {
    func updateRow(row: Int)
}

class FeedTVCell: UITableViewCell {
    
	@IBOutlet private weak var shadowView: UIView!
	@IBOutlet private weak var containerView: UIView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var feedTypeLabel: UILabel!
	@IBOutlet private weak var addToWishListView: UIImageView!
    @IBOutlet private weak var detailView: AttributedLabel!
    @IBOutlet private weak var favoriteViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mainImage: UIImageView!
    
	var cellIndex: Int!
	var cardModel: CardEntity?
	
    weak var reloadDelegate: RowReloaderProtocol?
	
	var taskEntity: TaskEntity?
	
	func prepareView(
        cardModel: CardEntity,
        cellIndex: Int) {
		self.cardModel = cardModel
		titleLabel.text = cardModel.title
        
        var text = (cardModel.descr ?? "").personalize
        let textWithBullets = text.convertBullets()
        
        detailView.attributedText = textWithBullets.style(tags: Style.textStyle())
        
        if detailView.numberOfLines == 2 {
            detailView.truncatedText(cardText: textWithBullets.style(tags: Style.textStyle()).string)
        }
        
        mainImage.setSuitableImage(from: cardModel)

        feedTypeLabel.text = "  " + NSLocalizedString(FeedType(string: cardModel.type ?? "").rawValue, comment: "") + "  "
		
		self.cellIndex = cellIndex
	}
}

extension FeedTVCell: ReuseIdentifying { }
