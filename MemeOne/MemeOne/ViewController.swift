

// The completionHandler has been deprecated, that's why it wasn't included

import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    // PART 1 DECLARING OUTLETS AND VARIABLES
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var memeHolder: UIImageView!
    
    @IBOutlet weak var topStack: UIStackView!
    
    @IBOutlet weak var bottomStack: UIStackView!
    
    @IBOutlet weak var cameraButton: UIButton!
    

    var imagePickerControl : UIImagePickerController!
    
    
    // PART 2 INITIALIZATION AND DEINITIALIZATION

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topText.attributedPlaceholder = placeholderText(textDisplayed:  "TOP")
        bottomText.attributedPlaceholder = placeholderText(textDisplayed:  "BOTTOM")

        
        textConfiguration(textField: topText)
        textConfiguration(textField: bottomText)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = true
        } else {
            cameraButton.isEnabled = false
        }

        subscribeToKeyboardNotification()
        
     
        
     
        
    }
    
    
    deinit {
        unsubscribeToKeyboardNotification()
    }
    
    
    
    // PART 3 ADDING AND REMOVING OBSERVERS

    func subscribeToKeyboardNotification(){
             NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
             NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
             NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // PART 4 TEXT CONFIGURATIONS
    
    func placeholderText(textDisplayed: String) -> NSAttributedString {
        return NSAttributedString(string: textDisplayed, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.strokeColor: UIColor.black,                  NSAttributedString.Key.strokeWidth: -3,
        ])
    }
    
    func textConfiguration(textField: UITextField){
        textField.delegate = self
        
        let paragraph = NSMutableParagraphStyle()
             paragraph.alignment = .center
             
             let memeTextAttributes: [NSAttributedString.Key: Any] = [
                 NSAttributedString.Key.strokeColor: UIColor.black,
                 NSAttributedString.Key.foregroundColor: UIColor.white,
                 NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                 NSAttributedString.Key.strokeWidth: -3,
                 NSAttributedString.Key.paragraphStyle: paragraph
                 
             ]
             
        textField.defaultTextAttributes = memeTextAttributes
    }
    
    
    // PART 5 BUTTON ACTIONS

    
    @IBAction func cancelMemeSelection(_ sender: Any) {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
    }
    
    
    
    @IBAction func shareMeme(_ sender: Any) {
        let meme = generateMemedImage()
        let vc = UIActivityViewController(activityItems: [meme], applicationActivities: [])
        vc.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed:
        Bool, arrayReturnedItems: [Any]?, error: Error?) in
            self.save(memeImageSave: meme)
            
        }
        present(vc, animated: true)
        
    }
    

    
    @IBAction func pickFromAlbum(_ sender: Any) {
        let pickImage = UIImagePickerController()
        pickImageFrom(chooseImage: pickImage, chooseType: "album")
        present(pickImage, animated: true, completion: nil)
    }
    
    
    
    @IBAction func takePicture(_ sender: Any) {
            let pickImage = UIImagePickerController()
            pickImageFrom(chooseImage: pickImage, chooseType: "Camera")

            present(pickImage, animated: true, completion: nil)
    }
    
    
    // PART 6 KEYBOARD CONFIGURATIONS AND MEME GENERATION

    
    func pickImageFrom(chooseImage: UIImagePickerController, chooseType: String){
        chooseImage.delegate = self
        if chooseType == "Camera" {
            chooseImage.sourceType = .camera
        } else if chooseType == "album" {
            chooseImage.sourceType = .photoLibrary
        }
    }
    
    func generateMemedImage() -> UIImage {

        let imageSize = CGSize(width: topStack.frame.size.width , height: self.view.frame.height)

        let coordinates = CGRect(x: 0, y: bottomStack.frame.size.height, width: topStack.frame.size.width, height: memeHolder.frame.size.height)

        UIGraphicsBeginImageContext(imageSize)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
            
        let new = memedImage.cgImage?.cropping(to:coordinates)

        if let finalImage = new {
            return UIImage(cgImage:finalImage)
        } else {
            return #imageLiteral(resourceName: "index")
        }
        
    }
    
    
    
    @objc func keyboardWillChange(notification: Notification){
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification && bottomText.isFirstResponder {
                view.frame.origin.y = -keyboardRect.height
                
            } else {
                view.frame.origin.y = 0

            }

        
        
    }
    
    func save(memeImageSave: UIImage){
         let saveMeme = Meme(topText: topText.text ?? "TOP", bottomText: bottomText.text ?? "BOTTOM", originalImage: memeHolder.image!, memeImage: memeImageSave)
     }
     
     
     
     func hideKeyboard(){
         topText.resignFirstResponder()
         bottomText.resignFirstResponder()
     }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        memeHolder.image = image
        dismiss(animated: true, completion: nil)
    }
    
    
}

