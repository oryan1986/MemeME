//
//  SentMemeCollectionViewController.swift
//  MemeME
//
//  Created by L3GB4 on 2018-07-09.
//  Copyright © 2018 L3GB4. All rights reserved.
//

import UIKit

class SentMemeCollectionViewController: UICollectionViewController {
    
    //MARK:- Properties
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var meme: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    //MARK:- Life Cyle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sent Memes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(memeMaker))
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    
    //presenting the Meme capture
    @objc func memeMaker() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "Meme") as! MemeMeViewController
        present(controller, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    //MARK:- Collection view data/delegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.meme.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! CustomMemeCollectionViewCell
        let meme = self.meme[(indexPath as NSIndexPath).row]
        
        //configer cell
        cell.memeImage.image = meme.memeImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailImage = storyboard?.instantiateViewController(withIdentifier: "detailViewController") as! DetailMemesViewController
        detailImage.memes = self.meme[(indexPath as NSIndexPath).row]
        detailImage.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailImage, animated: true)
    }

    

}
