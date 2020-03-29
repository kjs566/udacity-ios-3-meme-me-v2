//
//  MemeTableViewController.swift
//  MemeMeV2
//
//  Created by Jan Skála on 28/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: BaseMemeListViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getItemsCount() + 1 // Always show add in the list as last item
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = getItem(atIndexPath: indexPath){
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell", for: indexPath) as! MemeTableViewCell
            cell.memeImage?.image = item.memedImage
            cell.memeText?.attributedText = concatTexts(texts: item.texts)
            return cell
        }else{
            return tableView.dequeueReusableCell(withIdentifier: "AddTableCell", for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let item = getItem(atIndexPath: indexPath){
            showMemeDetail(item)
        }else{
            createMeme()
        }
    }
}
