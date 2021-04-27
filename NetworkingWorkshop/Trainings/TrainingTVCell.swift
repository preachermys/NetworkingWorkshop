//
//  TrainingTVCell.swift
//  Rubilix
//
//  Created by Sergiy Sobol on 19.01.18.
//  Copyright © 2018 Andersen. All rights reserved.
//

import UIKit

final class IndexedCollectionView: UICollectionView {

	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}

let collectionViewCellIdentifier = "TrainingCVCell"

final class TrainingTVCell: UITableViewCell {

	var collectionView: IndexedCollectionView!

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
		layout.minimumLineSpacing = 0

		var cellWidth = 210

		if UIScreen.main.bounds.width > 320 {
			cellWidth = 170
		}
		layout.itemSize = CGSize(width: cellWidth, height: 204)
		layout.scrollDirection = .horizontal

		collectionView = IndexedCollectionView(frame: CGRect.zero, collectionViewLayout: layout)

		let nib = UINib(nibName: collectionViewCellIdentifier, bundle: nil)
		collectionView?.register(nib, forCellWithReuseIdentifier: collectionViewCellIdentifier)
//        collectionView.register(cellType: TrainingMoreCell.self)
		collectionView.backgroundColor = UIColor.clear//.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
		collectionView.showsHorizontalScrollIndicator = false

		contentView.addSubview(self.collectionView)
		layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		let frame = self.contentView.bounds
		collectionView.frame = CGRect(x: 0, y: 0.5, width: frame.size.width, height: frame.size.height - 1)
	}

	func setCollectionViewDataSourceDelegate(
        dataSourceDelegate delegate: UICollectionViewDelegate & UICollectionViewDataSource,
        index: NSInteger
    ) {
		collectionView.dataSource = delegate
		collectionView.delegate = delegate
		collectionView.tag = index
		collectionView.reloadData()
	}

	func setCollectionViewDataSourceDelegate(
        dataSourceDelegate delegate: UICollectionViewDelegate & UICollectionViewDataSource,
        indexPath: IndexPath
    ) {
		collectionView.dataSource = delegate
		collectionView.delegate = delegate
		collectionView.tag = indexPath.section
		collectionView.reloadData()
	}
}

extension TrainingTVCell: ReuseIdentifying { }
