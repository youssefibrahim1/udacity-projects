//
//  DetailMemeViewController.swift
//  memeOne
//
//  Created by Youssef Ibrahim on 2020-04-07.
//  Copyright © 2020 Youssef Ibrahim. All rights reserved.
//

import UIKit

class DetailMemeViewController: UIViewController {
    
    @IBOutlet weak var historyMemeView: UIImageView!
    
    var meme: Meme = Meme(topText: "", bottomText: "", originalImage: UIImage(named: "") ?? #imageLiteral(resourceName: "index")
        , memeImage: UIImage(named: "") ?? #imageLiteral(resourceName: "index") )
    
    override func viewDidLoad() {
        historyMemeView.image = meme.memeImage
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    


}
