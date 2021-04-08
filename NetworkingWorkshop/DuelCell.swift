//
//  DuelCell.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 26.03.2021.
//

import UIKit

class DuelCell: UITableViewCell, ReuseIdentifying {

    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var duelLabel: UILabel!
    @IBOutlet weak var detailView: AttributedLabel!
    
    var cellIndex: Int?
    var duel: DuelEntity?
    
    func prepareView(
        duel: DuelEntity,
        cellIndex: Int
    ) {
        self.duel = duel
        nameLabel.text = duel.title
        
        let link = Style("a")
            .foregroundColor(.blue, .normal)
            .foregroundColor(.brown, .highlighted)
        
        let text = (duel.descr ?? "").personalize.convertFromHTML()
        
//        detailView.attributedText = text.style(tags: link)
//        
//        detailView.truncatedText(cardText: (duel.descr ?? "").personalize)
        
        self.cellIndex = cellIndex
        
        duelLabel.text = "DUEL"
        
        mainImage.setSuitableImage(from: duel)
    }
}

