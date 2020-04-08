

import UIKit

class TableMemeViewController: UITableViewController{
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        self.tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeIdentifier") as! MemeTableViewCell
        let meme = self.memes[indexPath.row]
        
        cell.memeImage.image = meme.memeImage
        cell.topTextLabel.text = meme.topText
        cell.bottomTextLabel.text = meme.bottomText
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = storyboard!.instantiateViewController(identifier: "DetailIdentifier") as! DetailMemeViewController
        let meme = memes[indexPath.row]
        
        detailController.meme = meme
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    @IBAction func showMemeEditor(_ sender: Any) {
        self.performSegue(withIdentifier: "tableToEditor", sender: self)
    }
}

