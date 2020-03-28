//
//  BaseMemeListViewController.swift
//  MemeMeV2
//
//  Created by Jan Skála on 28/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

open class BaseMemeListViewController: UIViewController{
    
    func getAppDelegate() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func getData() -> [Meme] {
        return getAppDelegate().sharedData
    }
    
    func getItemsCount() -> Int{
        return getData().count
    }
    
    func editMeme(atIndex: IndexPath){
        let meme = getData().first!
        performSegue(withIdentifier: "editMemeSegue", sender: meme)
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is MemeEditorViewController && sender is Meme){
            var vs = segue.destination as! MemeEditorViewController
            var meme = sender as! Meme
            vs.setArguments(meme: meme)
        }
    }
}
