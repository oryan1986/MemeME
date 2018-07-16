//
//  DetailMemesViewController.swift
//  MemeME
//
//  Created by L3GB4 on 2018-07-10.
//  Copyright © 2018 L3GB4. All rights reserved.
//

import UIKit

class DetailMemesViewController: UIViewController {

    @IBOutlet weak var detailImage: UIImageView!
    var memes: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailImage.image = memes.memeImage
    }
}
