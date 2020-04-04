

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

 
    @IBOutlet weak var memeHolder: UIImageView!
    
    var imagePickerControl : UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func pickFromAlbum(_ sender: Any) {
        let pickImage = UIImagePickerController()
        pickImage.delegate = self
        pickImage.sourceType = .photoLibrary
        present(pickImage, animated: true, completion: nil)
    }
    
    
    
    @IBAction func takePicture(_ sender: Any) {
        
        print("About to test camera")
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

