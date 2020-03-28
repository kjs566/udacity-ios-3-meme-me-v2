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
    let originalImage : UIImage
    let memedImage : UIImage
    
    init(texts: [MemeText], originalImage: UIImage, memedImage: UIImage){
        self.texts = texts
        self.memedImage = memedImage
        self.originalImage = originalImage
        super.init()
    }
    
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return memedImage
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return memedImage
    }
}
