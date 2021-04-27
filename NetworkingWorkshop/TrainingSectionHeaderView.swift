//
//  TrainingSectionHeaderView.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 16.04.2021.
//

import UIKit

final class TrainingSectionHeaderView: UIView {

    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var accessoryImage: UIImageView
    var tapButton: UIButton

    var headerTap: ((Int) -> Void)?

    override init(frame: CGRect) {
        titleLabel = UILabel(frame: CGRect(x: 20, y: Int(frame.height - 50), width: Int(frame.width - 100), height: 40))
        subtitleLabel = UILabel(frame: CGRect(x: Int(frame.width - 100), y: Int(frame.height - 60), width: 140, height: 40))
        subtitleLabel.textAlignment = .right
        subtitleLabel.textColor = UIColor.lightGray
        accessoryImage = UIImageView(image: UIImage.init(named: "greyOpenArrowIcon"))
        tapButton = UIButton()

//        guard let customFont = UIFont(name: "SFUIText-Semibold", size: 19) else {
//            fatalError("Failed to load the CustomFont-Light font. Make sure the font file is included in the project and the font name is spelled correctly")
//        }
//        titleLabel.font = customFont
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(accessoryImage)
        addSubview(tapButton)
        self.backgroundColor = UIColor.white
        tapButton.addTarget(self, action: #selector(TrainingSectionHeaderView.tapOnHeader), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        titleLabel.frame = CGRect(x: 20, y: Int(frame.height - 50), width: Int(frame.width - 100), height: 40)
        subtitleLabel.frame = CGRect(x: Int(frame.width - 100), y: Int(frame.height - 47), width: 60, height: 40)
        accessoryImage.frame = CGRect(x: Int(frame.width - 28), y: Int(frame.height - 34), width: 8, height: 14)
        tapButton.frame = self.bounds
    }

    @objc func tapOnHeader() {
        if let headerTap = headerTap {
            headerTap(tag)
        }
    }
}
