//
//  MemeCollectionViewController.swift
//  MemeMeV2
//
//  Created by Jan Skála on 28/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController : BaseMemeListViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getItemsCount() + 1 // Always show add in the list as last item
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let item = getItem(atIndexPath: indexPath){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionViewCell
            cell.setImage(item.memedImage)
            return cell
        }else{
            return collectionView.dequeueReusableCell(withReuseIdentifier: "AddCollectionCell", for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if let item = getItem(atIndexPath: indexPath){
            showMemeDetail(item)
        }else{
            createMeme()
        }
    }
}
