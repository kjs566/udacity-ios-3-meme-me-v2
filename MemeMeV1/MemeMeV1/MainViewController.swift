//
//  ViewController.swift
//  MemeMeV1
//
//  Created by Jan Skála on 10.03.18.
//  Copyright © 2018 Jan Skála. All rights reserved.
//

import UIKit
import Foundation

class MainViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    enum TextTypes: Int{
        case top = 0, bottom
    }
    
    let memeTextAttributes: [String : Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: 1.5]
    
    let defaultTexts = [
        TextTypes.top: "TOP",
        TextTypes.bottom: "BOTTOM"
    ]
    
    lazy var texts = [
        TextTypes.top: topText,
        TextTypes.bottom: bottomText
    ]
    
    let defaultTop = ""
    let defaultBottom = ""
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewDidLoad() {
        texts.forEach { (key, view) in
            view?.text = defaultTexts[key]
            view?.delegate = self
            view?.defaultTextAttributes = memeTextAttributes
            view?.textAlignment = .center
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
    
    /// Called when image is picked.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = image
        
        dismiss(animated: true, completion: nil)
    }
    
    
    /// Called when image picker is canceled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let type = TextTypes(rawValue: textField.tag) ?? .top
        if textField.text == defaultTexts[type] {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

