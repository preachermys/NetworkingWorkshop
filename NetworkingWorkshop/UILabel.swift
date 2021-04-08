//
//  UILabel.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 05.04.2021.
//

import Foundation
import UIKit

extension UILabel {
    func labelLines(maxWidth: CGFloat = UIScreen.main.bounds.width - 100.0) -> Int {
        let maxSize = CGSize(width: maxWidth, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        var counter = 0
        
        var searchRange = NSRange(location: 0, length: text.length)
        
        while true {
            let range = text.range(of: "\n", options: .literal, range: searchRange)
            if range.location != NSNotFound {
            
                let index = range.location + range.length
                searchRange.location = index
                searchRange.length = text.length - index
                
                counter += 1
            } else {
                break
            }
        }
        let textSize = text.boundingRect(with: maxSize,
                                         options: .usesLineFragmentOrigin, attributes: [.font: font as Any],
                                         context: nil)
        let lines = Int(textSize.height/charSize)
        return lines > counter ? lines : counter
    }
}

extension AttributedLabel {
    func labelLines(in string: NSString? = nil) -> Int {
        let maxSize = CGSize(width: UIScreen.main.bounds.width - 100.0, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        
        let text = string != nil
                        ? string
                        : (self.attributedText?.string ?? "") as NSString
        
        guard let textForCalculating = text else { return 0 }
        
        var counter = 0
        
        var searchRange = NSRange(location: 0, length: textForCalculating.length)
        
        while true {
            let range = textForCalculating.range(of: "\n", options: .literal, range: searchRange)
            if range.location != NSNotFound {
                
                let index = range.location + range.length
                searchRange.location = index
                searchRange.length = textForCalculating.length - index
                
                counter += 1
            } else {
                break
            }
        }
        let textSize = textForCalculating.boundingRect(with: maxSize,
                                                       options: .usesLineFragmentOrigin, attributes: [.font: font],
                                                       context: nil)
        let lines = Int(textSize.height / charSize)
        return lines > counter ? lines : counter
    }
    
    func truncatedText(cardText: String) {
        let symbolArray = ["/", "\\", ".", ",", "-", "_", "—", "", "'", "]", "[", "`", "<", ">", "=", "+"]
        
        if cardText.isEmpty || labelLines(in: cardText as NSString) < 3 {
            return
        }
        var string: String = ""
        let label = UILabel()
        label.text = self.attributedText?.string
        if numberOfLines == 2 {
            let oneLineTextCount = (self.attributedText?.string.count ?? 0) / label.labelLines()
            let moreLess = "" + NSLocalizedString("еще", comment: "")
            if cardText.convertFromHTML().hasPrefix("<a"),
                !cardText.convertFromHTML().hasSuffix("</a>") {
                
                string = cardText.convertFromHTML()
                let index = string.components(separatedBy: "</a>")[0].count
                string.insert(contentsOf: moreLess, at: string.index(string.startIndex, offsetBy: index))
                
                string = string.components(separatedBy: NSLocalizedString("еще", comment: ""))[0]
                if symbolArray.contains(String(string.last ?? " ")) {
                    string.removeLast()
                }
                
                string += NSLocalizedString("еще", comment: "")
            } else {
                string = String(cardText.convertFromHTML().prefix(Int(Double(oneLineTextCount) * 1.7)))
                if symbolArray.contains(String(string.last ?? " ")) {
                    string.removeLast()
                }

                string.append(moreLess)
            }
        } else {
            let moreLess = " " + NSLocalizedString("скрыть", comment: "")
            string = cardText.convertFromHTML()
            string.append(moreLess)
        }
        
        let textWithBullets = string.convertBullets()
        
        let tagsString = textWithBullets.style(tags: Style.textStyle() + [Style.linkGray])
        if let range = tagsString.string.range(of: NSLocalizedString("еще", comment: "")
                        .style(tags: Style.textStyle() + [.linkGray]).string) {
            
            self.attributedText = tagsString.style(range: range, style: .linkGray)
        } else {
            self.attributedText = tagsString
        }
    }
}

extension Style {
    static var link: Style {
        return Style("a")
                .foregroundColor(.blue, .normal)
                .foregroundColor(.brown, .highlighted)
    }
    
    static var linkGray: Style {
        return Style("z")
                .foregroundColor(.gray, .normal)
                .foregroundColor(.gray, .highlighted)
    }
    
    static var underline: Style {
        return Style("u")
                .underlineStyle(.single)
    }
    
    static var bold: Style {
        return Style("b")
                .font(.boldSystemFont(ofSize: 16))
    }
    
    static var italic: Style {
        return Style("i")
                .obliqueness(0.2)
    }
    
    static func textStyle() -> [Style] {
        return [.link, .underline, .bold, .italic]
    }
}
