//
//  MemeTexts.swift
//  MemeMeV1
//
//  Created by Jan Skála on 26/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

struct MemeText : Hashable{
    let viewIdentifier: String
    let position : TextPosition
    var text: String?
    var defaultText: String?
    var borderColor: MemeColor = MemeColor.availableColors[.black]!
    var textColor: MemeColor = MemeColor.availableColors[.white]!
    var font: UIFont = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
    var borderWidth = -1.5
    
    init(viewIdentifier: String, position: TextPosition) {
        self.viewIdentifier = viewIdentifier
        self.position = position
        self.defaultText = position.rawValue
        self.text = self.defaultText
    }
    
    func createTextAttributes() -> [NSAttributedString.Key: Any]{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return [
            .foregroundColor: self.textColor.color,
            .strokeColor: self.borderColor.color,
            .font: self.font,
            .strokeWidth: self.borderWidth,
            .paragraphStyle: paragraphStyle
        ]
    }
    
    static func == (lhs: MemeText, rhs: MemeText) -> Bool {
        return lhs.position == rhs.position
    }
}
