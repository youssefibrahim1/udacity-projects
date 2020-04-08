//
//  MemeOne.swift
//  memeOne
//
//  Created by Youssef Ibrahim on 2020-04-04.
//  Copyright © 2020 Youssef Ibrahim. All rights reserved.
//

import UIKit

struct Meme{
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memeImage: UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memeImage: UIImage){
        
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memeImage = memeImage
    }
}


