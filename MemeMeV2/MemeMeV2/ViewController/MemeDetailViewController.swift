//
//  MemeDetailViewController.swift
//  MemeMeV2
//
//  Created by Jan Skála on 28/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController : UIViewController{
    var meme: Meme? = nil
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        setupView()
    }
    
    func setArguments(meme: Meme){
        self.meme = meme
    }
    
    func setupView(){
        imageView.image = meme?.memedImage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is MemeEditorViewController){
            let vc = segue.destination as! MemeEditorViewController
            vc.setArguments(meme: self.meme)
        }
    }
}
