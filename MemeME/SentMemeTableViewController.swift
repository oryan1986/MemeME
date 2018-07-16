//
//  SentMemeTableViewController.swift
//  MemeME
//
//  Created by L3GB4 on 2018-06-20.
//  Copyright © 2018 L3GB4. All rights reserved.
//

import UIKit

class SentMemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- Properties
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
    }
    
    //Function for presenting the detail view controller
    @objc func memeMaker() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "Meme") as! MemeMeViewController
        present(controller, animated: true, completion: nil)
    }
    
    //MARK:- TableView Data/delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meme.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath) as! CustomMemeTableViewCell
        let meme = self.meme[(indexPath as NSIndexPath).row]
        
        //configer cell
        cell.tableImage.image = meme.memeImage
        cell.nameLabel.text = meme.topText
        cell.deatilName.text = meme.bottomText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = storyboard?.instantiateViewController(withIdentifier: "detailViewController") as! DetailMemesViewController
        detail.memes = self.meme[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(detail, animated: true)
    }
    
    
}
