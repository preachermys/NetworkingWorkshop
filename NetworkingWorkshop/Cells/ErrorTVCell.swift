//
//  ErrorTVCell.swift
//  Rubilix
//
//  Created by Val Bratkevich on 06.04.2020.
//  Copyright © 2020 Andersen. All rights reserved.
//

import UIKit

final class ErrorTVCell: UITableViewCell {
    private enum Constants {
        static let cornerRadius: CGFloat = 10
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    
    func prepareView(title: String?, feedType: String?) {
        titleLabel.text = title
        typeLabel.text = "  " + NSLocalizedString(FeedType(string: feedType ?? "").rawValue, comment: "") + "  "
    }
}

extension ErrorTVCell: ReuseIdentifying { }
