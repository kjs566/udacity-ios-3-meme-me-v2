//
//  MemeTexts.swift
//  MemeMeV1
//
//  Created by Jan Skála on 26/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class MemeText : NSCopying{
    let viewIdentifier: String
    let position : MemeTextPosition
    let defaultText: String?
    var text: String?
    var borderColor: MemeColor
    var textColor: MemeColor
    var font: UIFont
    var borderWidth = -1.5
    
    init(viewIdentifier: String, position: MemeTextPosition) {
        self.viewIdentifier = viewIdentifier
        self.position = position
        self.defaultText = position.rawValue
        self.text = self.defaultText
        self.borderColor = MemeColor.availableColors[.black]!
        self.textColor = MemeColor.availableColors[.white]!
        self.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
    }
    
    private init(viewIdentifier: String, position: MemeTextPosition, text: String?, defaultText: String?, borderColor: MemeColor, textColor: MemeColor, font: UIFont, borderWidth: Double){
        self.viewIdentifier = viewIdentifier
        self.position = position
        self.defaultText = defaultText
        self.text = text
        self.borderColor = borderColor
        self.font = font
        self.borderWidth = borderWidth
        self.textColor = textColor
    }
    
    func createTextAttributes(overrideFont: UIFont? = nil) -> [NSAttributedString.Key: Any]{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return [
            .foregroundColor: self.textColor.color,
            .strokeColor: self.borderColor.color,
            .font: overrideFont ?? self.font,
            .strokeWidth: self.borderWidth,
            .paragraphStyle: paragraphStyle
        ]
    }
    
    func asAttributedText(overrideFontSize: CGFloat? = nil) -> NSAttributedString{
        let attributed = NSAttributedString(string: text ?? "", attributes: createTextAttributes(overrideFont: UIFont(name: font.fontName, size: overrideFontSize ?? font.pointSize)))
        return attributed
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return MemeText(viewIdentifier: viewIdentifier, position: position, text: text, defaultText: defaultText, borderColor: borderColor, textColor: textColor, font: UIFont(name: font.fontName, size: font.pointSize)!, borderWidth: borderWidth)
    }
}
