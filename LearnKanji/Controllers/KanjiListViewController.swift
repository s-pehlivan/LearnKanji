//
//  KanjiListViewController.swift
//  LearnKanji
//
//  Created by Sora on 10.07.2022.
//

import UIKit

class KanjiListViewController: UIViewController {
        
    @IBOutlet weak var kanjiCollectionView: UICollectionView!
    
    var kanjiManager = KanjiManager()
    
    var kanjiArray = [""]
    
    var gradeUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kanjiManager.kanjiGradeDelegate = self
        kanjiCollectionView.delegate = self
        kanjiCollectionView.dataSource = self
        
        navigationItem.backButtonTitle = ""
        
        if let grade = gradeUrl {
            kanjiManager.fetchURL(grade: grade)
        }
        
        // CollectionView Cell Layout
        let cellWidth = view.width / 4

        var design: UICollectionViewFlowLayout {
            let design = UICollectionViewFlowLayout()
            design.itemSize = CGSize(width: cellWidth, height: cellWidth + 10)
            design.minimumLineSpacing = 30
            design.minimumInteritemSpacing = view.width / 10
            return design
        }
        
        kanjiCollectionView.collectionViewLayout = design
        
        kanjiCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        kanjiCollectionView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kanjiToDetail" {
            let kanji = sender
            let vc = segue.destination as! DetailViewController
            vc.kanji = kanji as? String
        }
    }
   
}

//MARK: - KanjiManagerProtocol

extension KanjiListViewController: KanjiManagerProtocol {
    func sendGradeKanjiList(_ kanjiManager: KanjiManager, kanjiList: [String]) {
        kanjiArray = kanjiList
        DispatchQueue.main.async {
            self.kanjiCollectionView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
   

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension KanjiListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kanjiArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kanjiCell", for: indexPath) as! KanjiListCollectionViewCell
        let number = indexPath.row + 1
        let kanji = kanjiArray[indexPath.row]
        cell.numberLabel.text = String(number)
        cell.KanjiLabel.text = kanji
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let kanji = kanjiArray[indexPath.row]
        performSegue(withIdentifier: "kanjiToDetail", sender: kanji)
    }
    
    
}



