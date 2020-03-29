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
    
    var backgroundColor = MemeColor.availableColors[.white]!
    var editingTopField = false
    
    
    lazy var defaultMemeTexts: [MemeText] = [
        MemeText(viewIdentifier: "top", position: .top),
        MemeText(viewIdentifier: "bottom", position: .bottom)
    ]
    lazy var defaultMeme = Meme(texts: defaultMemeTexts, originalImage: nil, memedImage: nil)
    
    var originalMeme : Meme? = nil
    var meme : Meme!
    
    lazy var memeTextViews = [ topField, bottomField ]
    
    lazy var memeTextPositionViews : [MemeTextPosition: UITextField] = [
        .top: topField,
        .bottom : bottomField
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        if !hasDeviceCamera(){
            cameraButton.isEnabled = false
            cameraButton2.isEnabled = false
        }
        subscribeKeyboardShowHide()
    }
    
    override func viewDidLoad() {
        if(meme == nil){
            meme = defaultMeme
        }
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeKeyboardShowHide()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is ChooseColorViewController && sender is
            MemeColor.ColorFor){
            let vc = segue.destination as! ChooseColorViewController
            let colorFor = sender as! MemeColor.ColorFor
            var selectedColor : MemeColor.ColorIdentifier = .white
            switch colorFor {
            case .background:
                selectedColor = backgroundColor.identifier
            case .fontColor(texts: let memeTexts):
                selectedColor = memeTexts.first!.textColor.identifier
            case .fontBorder(texts: let memeTexts):
                selectedColor = memeTexts.first!.borderColor.identifier
            }
            
            vc.delegate = self
            vc.setArguments(colorFor: colorFor, currentColor: selectedColor);
        }
    }
    
    func setupViews(){
        cancelEditing()
        meme.texts.forEach { (memeText) in
            updateMemeTextView(memeText)
        }
        memeTextViews.forEach { (field: UITextField?) in
            field?.delegate = self
            field?.autocapitalizationType = .allCharacters
        }
        updateBackgroundColor()
        updateBackgroundImage()
        updateNoImageOverlay()
        shareButton.isEnabled = meme.originalImage != nil
    }
    
    func setArguments(meme: Meme?){
        self.originalMeme = meme
        self.meme = (meme ?? defaultMeme).copy() as? Meme
    }
    
    func isEditing() -> Bool{
        return self.originalMeme != nil
    }
    
    func hasDeviceCamera() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func createMeme() -> Meme?{
        let memedImage = generateMemedImage()
        if(memedImage == nil || meme.originalImage == nil){
            return nil
        }
        meme.memedImage = memedImage!
        return meme
    }
    
    func generateMemedImage() -> UIImage? {
        bottomBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        bottomBar.isHidden = false
        
        return memedImage
    }
    

    func updateNoImageOverlay(){
        noImageOverview.isHidden = meme.originalImage != nil
    }
    
    func startOverClicked(){
        let startOverAlert = UIAlertController(title: "Do you realy want to start over?", message: "Your current progress will be deleted.", preferredStyle: .alert)
    
        let startOverAction = UIAlertAction(title: "Start over", style: .destructive) { (UIAlertAction) in
            self.setupViews()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        startOverAlert.addAction(cancelAction)
        startOverAlert.addAction(startOverAction)
        self.present(startOverAlert, animated: true, completion: nil)
    }
    
    
    func chooseBackgroundColor(){
        performSegue(withIdentifier: "chooseColorSegue", sender: MemeColor.ColorFor.background)
    }
    
    func chooseTextBorderColor(){
        performSegue(withIdentifier: "chooseColorSegue", sender: MemeColor.ColorFor.fontBorder(texts: Array(meme.texts))) // Change all texts for now
    }
    
    func chooseTextColor(){
        performSegue(withIdentifier: "chooseColorSegue", sender: MemeColor.ColorFor.fontColor(texts: Array(meme.texts))) // Change all texts for now
    }
    
    func changeBackgroundColor(_ color: MemeColor?){
        meme.backgroundColor = color
        updateBackgroundColor()
    }
    
    func updateBackgroundColor(){
        view.backgroundColor = meme.backgroundColor?.color ?? UIColor.lightGray
    }
    
    func changeTextColor(color: MemeColor, memeText: MemeText){
        memeText.textColor = color
        updateMemeTextView(memeText)
    }
    
    func changeTextBorder(color: MemeColor, memeText: MemeText){
        memeText.borderColor = color
        updateMemeTextView(memeText)
    }
    
    func updateMemeTextView(_ memeText: MemeText){
        let view = memeTextViews.first { (field: UITextField?) -> Bool in // Overkill for now - but allows changing colors for one field at a time for future
            field?.accessibilityIdentifier == memeText.viewIdentifier
        }!!
        updateTextAttributes(view: view, memeText: memeText)
        view.autocapitalizationType = .allCharacters
    }
    
    func changeBackgroundImage(_ image: UIImage?){
        meme.originalImage = image
        updateBackgroundImage()
    }
    
    func updateBackgroundImage(){
        imageView.image = meme.originalImage
    }
    
    
    func showAbout(){
        performSegue(withIdentifier: "showAboutSegue", sender: nil)
    }
    
    
    func updateTextAttributes(view: UITextField, memeText: MemeText){
        let textAttributes = memeText.createTextAttributes()        
        let attributedString = NSAttributedString(string: memeText.text ?? memeText.defaultText ?? "", attributes: textAttributes)

        view.defaultTextAttributes = textAttributes
        view.attributedText = attributedString
    }
    
    func cancelEditing(){
        memeTextViews.forEach { (field: UITextField!) in
            field.endEditing(true)
        }
    }
    
    
    func getAppDelegate() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func save(){
        meme.memedImage = generateMemedImage()
        if let oldMeme = originalMeme{
            getAppDelegate().replaceMeme(oldMeme: oldMeme, newMeme: meme)
        }else{
            saveAsNew()
        }
    }
    
    func saveAsNew(){
        meme.memedImage = generateMemedImage()
        getAppDelegate().addMeme(meme)
    }
    
    func pop(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        if(meme.originalImage == nil){
            pop()
        }else{
            let alert = UIAlertController()
            alert.title = "Save or discart changes?"
            
            let discartAction = UIAlertAction(title: "Discart", style: .destructive) { (UIAlertAction) in
                self.pop()
            }
            
            let saveAsNewAction = UIAlertAction(title: "Save as new", style: .default){
                (UIAlertAction) in
                self.saveAsNew()
                self.pop()
            }
            
            let saveAction = UIAlertAction(title: "Save", style: .default){
                (UIAlertAction) in
                self.save()
                self.pop()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(discartAction)
            alert.addAction(saveAction)
            
            if(isEditing()){
                alert.addAction(saveAsNewAction)
            }
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareClicked(_ sender: Any) {
        cancelEditing()
        let meme = createMeme()
        
        if(meme == nil){
            let alert = UIAlertController(title: "Something went wrong - image couldn't be generated", message: "Try again...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        }else{
            let sharingItems = [ meme ]
            let activityViewController = UIActivityViewController(activityItems: sharingItems as [Any], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func showMore(_ sender: Any) {
        cancelEditing()
        let moreMenu = UIAlertController(title: nil, message: "Choose action", preferredStyle: .actionSheet)
        let clearAction = UIAlertAction(title: "Start over", style: .destructive, handler:{ (UIAlertAction)in
            self.startOverClicked()
        })
        let chooseBackgroundColor = UIAlertAction(title: "Choose background color", style: .default, handler: {(UIAlertAction)in
            self.chooseBackgroundColor()
        })
        
        let chooseBorderColor = UIAlertAction(title: "Choose text border color", style: .default, handler: {(UIAlertAction)in
            self.chooseTextBorderColor()
        })
        
        let chooseTextColor = UIAlertAction(title: "Choose text color", style: .default, handler: {(UIAlertAction)in
            self.chooseTextColor()
        })
        
        let about = UIAlertAction(title: "About me and app", style: .default, handler: {(UIAlertAction)in
            self.showAbout()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
    
        moreMenu.addAction(clearAction)
        moreMenu.addAction(chooseBackgroundColor)
        moreMenu.addAction(chooseBorderColor)
        moreMenu.addAction(chooseTextColor)
        moreMenu.addAction(about)
        moreMenu.addAction(cancel)
        
        self.present(moreMenu, animated: true, completion: nil)
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        changeBackgroundImage(image)
        
        dismiss(animated: true, completion: updateNoImageOverlay)
    }
    
    
    /// Called when image picker is canceled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension MemeEditorViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let memeText = meme.texts.first { (text: MemeText) in
            textField.accessibilityIdentifier == text.viewIdentifier
        }
        if(memeText?.defaultText == textField.text){
            textField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())

        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        let memeText = meme.texts.first { (text: MemeText) in
            textField.accessibilityIdentifier == text.viewIdentifier
        }
        memeText!.text = textField.text
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

// MARK: Keyboard state change
extension MemeEditorViewController{
    func subscribeKeyboardShowHide(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        topField.addTarget(self, action: #selector(topFieldEditingStarted), for: .editingDidBegin)
        topField.addTarget(self, action: #selector(topFieldEditingEnded), for: .editingDidEnd)
    }
    
    @objc func topFieldEditingStarted(){
        editingTopField = true
        resetFrameOrigin()
    }
    
    @objc func topFieldEditingEnded(){
        editingTopField = false
    }
    
    func unsubscribeKeyboardShowHide(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc func keyboardWillShow(_ notification : Notification){
        if(!editingTopField){
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification : Notification){
        resetFrameOrigin()
    }
    
    func resetFrameOrigin(){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification : Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}

// MARK: ChooseColorDelegate
extension MemeEditorViewController: ChooseColorDelegate{
    func colorChosen(colorFor: MemeColor.ColorFor, newColor: MemeColor) {
            switch(colorFor){
            case .background:
                    changeBackgroundColor(newColor)
            case .fontColor(texts: let texts):
                texts.forEach { (text: MemeText) in
                    changeTextColor(color: newColor, memeText: text)
                }
            case .fontBorder(texts: let texts):
                texts.forEach { (text: MemeText) in
                    changeTextBorder(color: newColor, memeText: text)
                }
        }
    }
}
