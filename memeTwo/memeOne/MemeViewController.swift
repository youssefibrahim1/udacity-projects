

// The completionHandler has been deprecated, that's why it wasn't included

import UIKit
import Foundation

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    // MARK: PART 1 DECLARING OUTLETS AND VARIABLES
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var memeHolder: UIImageView!
    @IBOutlet weak var topStack: UIStackView!
    @IBOutlet weak var bottomStack: UIStackView!
    @IBOutlet weak var cameraButton: UIButton!
    
    var imagePickerControl : UIImagePickerController!
    
    // MARk: PART 2 INITIALIZATION AND DEINITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textConfiguration(textField: topText, textDisplayed: "TOP")
        textConfiguration(textField: bottomText, textDisplayed: "BOTTOM")
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = true
        } else {
            cameraButton.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
        subscribeToKeyboardNotification()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    
    // MARK: PART 3 ADDING AND REMOVING OBSERVERS
    
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
    
    // MARK: PART 4 TEXT CONFIGURATIONS
    
    func textConfiguration(textField: UITextField, textDisplayed: String){
        
        textField.defaultTextAttributes =  [
            .strokeWidth: -4.0,
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .font: UIFont(name:"HelveticaNeue-CondensedBlack", size: 40)!
        ]
        
        textField.textAlignment = .center
        textField.autocapitalizationType = .allCharacters
        
        textField.attributedPlaceholder = NSAttributedString(string: textDisplayed, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.strokeColor: UIColor.black,                  NSAttributedString.Key.strokeWidth: -3,
        ])
        
        textField.delegate = self
        
    }
    
    // MARk: PART 5 BUTTON ACTIONS
    
    @IBAction func cancelMemeSelection(_ sender: Any) {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func shareMeme(_ sender: Any) {
        
        let  memedImage = generateMemedImage()
        let vc = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        
        vc.completionWithItemsHandler = {
            (activity, success, items, error) in
            self.save(memeImageSave: memedImage)
            self.dismiss(animated: true, completion: nil)
        }
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    func uponCompletion(memedImage: UIImage){
        self.save(memeImageSave: memedImage)
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
    
    
    // MARk: PART 6 KEYBOARD CONFIGURATIONS AND MEME GENERATION
    
    
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
        let saveMeme = Meme(topText: topText.text ?? "TOP", bottomText: bottomText.text ?? "BOTTOM", originalImage: memeHolder.image ?? UIImage(named: "trial")!, memeImage: memeImageSave)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(saveMeme)
        
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
        
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            memeHolder.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    
}

