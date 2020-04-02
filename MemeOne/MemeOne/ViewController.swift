
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var CounterText: UILabel!
    
    var counter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CounterText.text = String(counter)
    }

    
    @IBAction func incrementButton(_ sender: Any) {
        counter += 1
        CounterText.text = String(counter)

    }
    
}

