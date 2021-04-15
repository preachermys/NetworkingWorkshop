//
//  FeedTimeLineTVCell.swift
//  Rubilix
//
//  Created by Sergiy Sobol on 02.01.18.
//  Copyright © 2018 Andersen. All rights reserved.
//

import UIKit

final class FeedVideoTVCell: FeedTVCell {
    
	@IBOutlet weak var detailLabel: UILabel!
	
    override func prepareView(
        cardModel: CardEntity,
        cellIndex: Int) {
        
        super.prepareView(
            cardModel: cardModel,
            cellIndex: cellIndex)
	}
}
