//
//  GradientLabel.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 16.04.2021.
//

import UIKit

final class GradientLabel: UILabel {
    let gradient: CAGradientLayer = CAGradientLayer()
    func applyGradient(colors: [CGColor]) {

        self.backgroundColor = UIColor.clear
        gradient.colors = colors
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)

        superview?.layer.addSublayer(gradient)
        superview?.bringSubviewToFront(self)
    }
    
    func clear() {
        gradient.removeFromSuperlayer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.masksToBounds = true
        gradient.cornerRadius = frame.size.height / 2
        gradient.frame = CGRect(x: frame.origin.x, y: frame.origin.y,
                                width: frame.size.width, height: frame.size.height)
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.height = 18

        return intrinsicContentSize
    }
    
    
    override var alpha: CGFloat {

        didSet {
            if Float(alpha) <= 0 {
                gradient.removeFromSuperlayer()
            }
            
        }
    }
    
    override var isHidden: Bool {
        didSet {
            if isHidden {
                gradient.removeFromSuperlayer()
            } else {
                superview?.layer.addSublayer(gradient)
                superview?.bringSubviewToFront(self)
            }
        }
    }
}
