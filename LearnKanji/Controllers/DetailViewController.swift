//
//  DetailViewController.swift
//  LearnKanji
//
//  Created by Sora on 11.07.2022.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var kanjiNameLabel: UILabel!
    @IBOutlet weak var jlptLabel: UILabel!
    @IBOutlet weak var strokeLabel: UILabel!
    @IBOutlet weak var unicodeLabel: UILabel!
    
    
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var onLabel: UILabel!
    @IBOutlet weak var kunLabel: UILabel!
    @IBOutlet weak var nameReadLabel: UILabel!
    
    var kanjiObjectManager = KanjiManager()
    var kanji: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kanjiObjectManager.kanjiDelegate = self
        
        if let kanji = kanji {
            navigationItem.title = "Kanji \(kanji)"
            kanjiNameLabel.text = kanji
            kanjiObjectManager.fetchKanjiUrl(char: kanji)
            
        }
    }
}

//MARK: - KanjiManagerProtcol

extension DetailViewController: KanjiDetailProtocol {
    func sendKanjiData(_ kanjiManager: KanjiManager, kanji: KanjiModal) {
        DispatchQueue.main.async {
            if kanji.jlpt != nil {
                let jlpt = kanji.jlpt!
                self.jlptLabel.text = "N\(String(jlpt))"
            } else {
                self.jlptLabel.text = "-"
            }
            self.strokeLabel.text = String(kanji.strokeCount)
            self.unicodeLabel.text = kanji.unicode
            self.meaningLabel.text = self.kanjiObjectManager.meanings(kanji.meanings)
            self.kunLabel.text = self.kanjiObjectManager.kun(kanji.kun)
            self.onLabel.text = self.kanjiObjectManager.on(kanji.on)
            self.nameReadLabel.text = self.kanjiObjectManager.nameReading(kanji.on)
                                                        
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

