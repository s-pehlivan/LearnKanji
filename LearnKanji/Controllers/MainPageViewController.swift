//
//  ViewController.swift
//  LearnKanji
//
//  Created by Sora on 10.07.2022.
//

import UIKit

class MainPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = ""

    }
   

    @IBAction func gradeButtonPressed(_ sender: UIButton) {
        if let title = sender.titleLabel?.text {
            performSegue(withIdentifier: "mainToList", sender: title)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToList" {
            let vc = segue.destination as! KanjiListViewController
            if let grade = sender {
                vc.gradeUrl = grade as? String ?? "1"
            }
        }
    }
    
}

    

