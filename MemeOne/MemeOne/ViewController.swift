

// The completionHandler has been deprecated, that's why it wasn't included

import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var memeHolder: UIImageView!
    
    @IBOutlet weak var topStack: UIStackView!
    
    @IBOutlet weak var bottomStack: UIStackView!
    
    var activeTextField = UITextField()
    
    
    var imagePickerControl : UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topText.delegate = self
        self.bottomText.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.white,
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -3,
            NSAttributedString.Key.paragraphStyle: paragraph
            
        ]
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
    }
    
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    @IBAction func cancelMemeSelection(_ sender: Any) {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
    }
    
    
    
    @IBAction func shareMeme(_ sender: Any) {
        let meme = generateMemedImage()
        save(memeImageSave: meme)
        let vc = UIActivityViewController(activityItems: [meme], applicationActivities: [])
        present(vc, animated: true)
        
    }
    
    func save(memeImageSave: UIImage){
        let saveMeme = Meme(topText: topText.text ?? "TOP", bottomText: bottomText.text ?? "BOTTOM", originalImage: memeHolder.image!, memeImage: memeImageSave)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    
    func hideKeyboard(){
        topText.resignFirstResponder()
        bottomText.resignFirstResponder()
    }
    
    
    func generateMemedImage() -> UIImage {


        let imageSize = CGSize(width: topStack.frame.size.width , height: self.view.frame.height ?? 511)


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
        
        if let activeText = self.activeTextField.placeholder {
            if notification.name == UIResponder.keyboardWillShowNotification && activeText == "BOTTOM" {
                view.frame.origin.y = -keyboardRect.height
                
            } else {
                view.frame.origin.y = 0

            }

        }
        
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
    

    
    @IBAction func pickFromAlbum(_ sender: Any) {
        let pickImage = UIImagePickerController()
        pickImage.delegate = self
        pickImage.sourceType = .photoLibrary
        present(pickImage, animated: true, completion: nil)
    }
    
    
    
    @IBAction func takePicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("enters here")
            let pickImage = UIImagePickerController()
            pickImage.delegate = self
            pickImage.sourceType = .camera
            present(pickImage, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "Your device doesn't seem to have a camera", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        memeHolder.image = image
        dismiss(animated: true, completion: nil)
    }
    
    
}

