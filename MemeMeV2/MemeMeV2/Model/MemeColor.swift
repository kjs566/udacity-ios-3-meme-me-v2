//
//  MemeColor.swift
//  MemeMeV1
//
//  Created by Jan Skála on 27/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

struct MemeColor: Hashable{
    let identifier: ColorIdentifier
    var color: UIColor
    
    enum ColorIdentifier: String{
        case black;
        case white;
        case blue;
        case green;
        case yellow;
        case pink;
    }
    
    enum ColorFor{
        case fontColor(texts: [MemeText])
        case fontBorder(texts: [MemeText])
        case background
    }
    
    static let availableColors : [ColorIdentifier: MemeColor] = [
        .black : MemeColor(identifier: .black, color: UIColor.black),
        .white : MemeColor(identifier: .white, color: UIColor.white),
        .blue : MemeColor(identifier: .blue, color: UIColor.blue),
        .green : MemeColor(identifier: .green, color: UIColor.green),
        .yellow : MemeColor(identifier: .yellow, color: UIColor.yellow),
        .pink : MemeColor(identifier: .pink, color: UIColor.systemPink)
    ]
    
    static func == (lhs: MemeColor, rhs: MemeColor) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.color == rhs.color
    }
}
