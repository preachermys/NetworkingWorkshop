//
//  EmptyCell.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 05.04.2021.
//

import UIKit

final class EmptyCell: UITableViewCell, ReuseIdentifying {
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var emptyIcon: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func prepareView(title: String, imageName: String, description: String) {
        emptyLabel.text = title
        emptyIcon.image = UIImage(named: imageName)
        descriptionLabel.text = description
    }
}

