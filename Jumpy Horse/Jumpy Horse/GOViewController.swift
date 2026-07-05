//
//  GOViewController.swift
//  Jumpy Horse
//
//  Created by student on 12/12/22.
//

import UIKit

class GOViewController: UIViewController {
    var numberToDisplay = 0
    @IBOutlet var score: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        score.text="Your Score: \(numberToDisplay)"
        super.viewWillAppear(animated)
    }
    
    @IBAction func playAgain(_ sender: Any) {
        performSegue(withIdentifier: "PlayAgain", sender: self)
    }
}
