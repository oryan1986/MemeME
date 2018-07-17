//
//  MemeMeViewController.swift
//  MemeME
//
//  Created by L3GB4 on 2018-05-22.
//  Copyright © 2018 L3GB4. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController, UINavigationControllerDelegate ,UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    //MARK:- Properties
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        inputFor(textField: topTextField, defaultText: "TOP")
        inputFor(textField: bottomTextField, defaultText: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        noImageToShare()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    //MARK:- Text Attributes
    let memeTextAttributes: [String: Any] = [NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
                                             NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
                                             NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                                             NSAttributedStringKey.strokeWidth.rawValue: -3]
    
    //MARK:- UIImagePickerControllerDelegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        imagePickerView.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text! == "TOP" || textField.text! == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Putting the text field into one function
    func inputFor(textField: UITextField, defaultText: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultText
        textField.textAlignment = .center
    }
    
    //MARK:- Keyboard will show and hide
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = 0
        }
        
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memeImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func hideTopAndBottomBars(_ hide: Bool) {
        topToolBar.isHidden = hide
        bottomToolBar.isHidden = hide
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        hideTopAndBottomBars(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        hideTopAndBottomBars(false)
        
        return memedImage
    }
    
    //disable the activity button when there no image to share.
    func noImageToShare() {
        if imagePickerView.image == nil {
            shareButton.isEnabled = false
        } else {
            shareButton.isEnabled = true
        }
    }
    
    //Chose a source type to be used. Camera or photo library
    func choseAnImage(from: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if from == .camera {
            imagePicker.sourceType = .camera
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:- Action buttons
    @IBAction func pickAnImage(_ sender: Any) {
        choseAnImage(from: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        choseAnImage(from: .camera)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success && items == nil {
                self.save()
                self.dismiss(animated: true, completion: nil);
            }
            else if (error != nil){
                let alert = UIAlertController(title: "Error", message: "Could not save image.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil
        noImageToShare()
        dismiss(animated: true, completion: nil)
    }
    
}
