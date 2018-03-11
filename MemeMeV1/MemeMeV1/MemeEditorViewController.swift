//
//  ViewController.swift
//  MemeMeV1
//
//  Created by Jan Skála on 10.03.18.
//  Copyright © 2018 Jan Skála. All rights reserved.
//

import UIKit
import Foundation

class MemeEditorViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton2: UIButton!
    
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var bottomField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var noImageOverview: UIView!
    enum TextTypes: Int{
        case top = 0, bottom
    }
    
    let memeTextAttributes: [String : Any] = [
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -1.5]
    
    let defaultTexts = [
        TextTypes.top: "TOP",
        TextTypes.bottom: "BOTTOM"
    ]
    
    lazy var texts = [
        TextTypes.top: topField,
        TextTypes.bottom: bottomField
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        if !hasDeviceCamera(){
            cameraButton.isEnabled = false
            cameraButton2.isEnabled = false
        }
        subscribeToKeyboardShowStateChangedNotification()
    }
    
    func hasDeviceCamera() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewDidLoad() {
        texts.forEach { (key, view) in
            view?.delegate = self
            view?.defaultTextAttributes = memeTextAttributes
            view?.textColor = UIColor.white
            view?.textAlignment = .center
            view?.text = defaultTexts[key]
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToKeyboardShowStateChangedNotification()
    }
    
    func createMeme() -> Meme{
        let memedImage = generateMemedImage()
        let meme = Meme(topText: topField?.text ?? "", bottomText: bottomField?.text ?? "", originalImage: imageView.image!, memedImage: memedImage)
        
        return meme
    }
    
    func generateMemedImage() -> UIImage {
        bottomBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        bottomBar.isHidden = false
        
        return memedImage
    }
    
    func hideNoImageOverlay(){
        let view = noImageOverview
        UIView.animate(withDuration: 0.5, animations: {
            view?.alpha = 0.0
            return
        })
    }
    
    @IBAction func shareClicked(_ sender: Any) {
        let meme = createMeme()
        
        let sharingItems = [ meme ]
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
    
    /// Called when image is picked.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = image
        
        dismiss(animated: true, completion: hideNoImageOverlay)
    }
    
    
    /// Called when image picker is canceled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension MemeEditorViewController: UITextFieldDelegate{
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

// MARK: Keyboard state change
extension MemeEditorViewController{
    func subscribeToKeyboardShowStateChangedNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardShowStateChangedNotification(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)

    }
    
    @objc func keyboardWillShow(_ notification : Notification){
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification : Notification){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification : Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}

