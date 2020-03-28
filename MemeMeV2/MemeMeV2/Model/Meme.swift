//
//  Meme.swift
//  MemeMeV1
//
//  Created by Jan Skála on 10.03.18.
//  Copyright © 2018 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class Meme : NSObject, UIActivityItemSource{
    let texts: [MemeText]
    var originalImage : UIImage?
    var memedImage : UIImage?
    var backgroundColor : MemeColor?
    
    init(texts: [MemeText], originalImage: UIImage? = nil , memedImage: UIImage? = nil, backgroundColor: MemeColor? = nil){
        self.texts = texts
        self.memedImage = memedImage
        self.originalImage = originalImage
        self.backgroundColor = backgroundColor
        super.init()
    }
    
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return memedImage ?? UIImage()
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return memedImage  
    }
}
