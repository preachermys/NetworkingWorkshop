//
//  FeedTimeLineTVCell.swift
//  Rubilix
//
//  Created by Sergiy Sobol on 02.01.18.
//  Copyright © 2018 Andersen. All rights reserved.
//

import UIKit
import AVFoundation

final class FeedAudioTVCell: FeedTVCell, AVAudioPlayerDelegate {
    private enum Status {
        case opened
        case completed
    }
    
    @IBOutlet private weak var detailLabel: AttributedLabel!
    @IBOutlet private weak var audioSlider: UISlider!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var maxTimeLabel: UILabel!
    @IBOutlet private weak var playerView: UIView!

    var isPost: Bool = true
    
    override func prepareView(cardModel: CardEntity,
                              cellIndex: Int) {
        
        super.prepareView(cardModel: cardModel,
                          cellIndex: cellIndex)
    }
}
