//
//  FeedTimeLineTVCell.swift
//  Rubilix
//
//  Created by Sergiy Sobol on 02.01.18.
//  Copyright © 2018 Andersen. All rights reserved.
//

import UIKit

final class FeedTimeLineTVC: FeedTVCell {
    
    @IBOutlet weak var detailLabel: AttributedLabel!
    
    override func prepareView(cardModel: CardEntity, cellIndex: Int) {
        super.prepareView(cardModel: cardModel, cellIndex: cellIndex)
    }
}
