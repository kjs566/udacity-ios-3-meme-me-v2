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
    
    open override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getAppDelegate() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func getData() -> [Meme] {
        return getAppDelegate().sharedData
    }
    
    func getItemsCount() -> Int{
        return getData().count
    }
    
    func getItemIndex(indexPath: IndexPath) -> Int{
        return indexPath.item
    }
    
    func getItem(atIndexPath: IndexPath) -> Meme?{
        let data = getData()
        let index = getItemIndex(indexPath: atIndexPath)
        if(data.count > index){
            return data[index]
        }else{
            return nil
        }
    }
    
    func showMemeDetail(_ meme: Meme){
        performSegue(withIdentifier: "memeDetailSegue", sender: meme)
    }
    
    func createMeme(){
        performSegue(withIdentifier: "editMemeSegue", sender: nil)
    }
    
    func concatTexts(texts: [MemeText], multipleLines: Bool = false) -> NSAttributedString{
        let text = NSMutableAttributedString()
        texts.forEach { (memeText: MemeText) in
            if(text.length != 0){
                if(multipleLines){
                    text.append(NSAttributedString(string: "\n"))
                }else{
                    text.append(NSAttributedString(string: "..."))
                }
            }
            text.append(memeText.asAttributedText(overrideFontSize: 25))
        }
        
        return text
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is MemeEditorViewController && sender is Meme){
            let vs = segue.destination as! MemeEditorViewController
            let meme = sender as! Meme
            vs.setArguments(meme: meme)
        }
        if(segue.destination is MemeDetailViewController && sender is Meme){
            let vs = segue.destination as! MemeDetailViewController
            let meme = sender as! Meme
            vs.setArguments(meme: meme)
        }
    }
}
