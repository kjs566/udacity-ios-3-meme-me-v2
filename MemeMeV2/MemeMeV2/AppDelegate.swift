//
//  AppDelegate.swift
//  MemeMeV1
//
//  Created by Jan Skála on 10.03.18.
//  Copyright © 2018 Jan Skála. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var sharedData : [Meme] = []
    
    func deleteMeme(_ meme: Meme) -> Int?{
        if let index = sharedData.firstIndex(of: meme){
            sharedData.remove(at: index)
            return index
        }
        return nil
    }
    
    func replaceMeme(oldMeme: Meme, newMeme: Meme){
        if let deletedIndex = deleteMeme(oldMeme){
            sharedData.insert(newMeme, at: deletedIndex)
        }
    }
    
    func addMeme(_ meme: Meme){
        sharedData.append(meme)
    }
}

