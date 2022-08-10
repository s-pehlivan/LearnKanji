//
//  KanjiManager.swift
//  LearnKanji
//
//  Created by Sora on 10.07.2022.
//

import Foundation

protocol KanjiManagerProtocol {
    func sendGradeKanjiList(_ kanjiManager: KanjiManager, kanjiList: [String])
    func didFailWithError(error: Error)
}

protocol KanjiDetailProtocol {
    func sendKanjiData(_ kanjiManager: KanjiManager, kanji: KanjiModal)
    func didFailWithError(error: Error)
}

struct KanjiManager {
    
    let baseURL = "https://kanjiapi.dev/v1/kanji"
    
    var kanjiGradeDelegate: KanjiManagerProtocol?
    var kanjiDelegate: KanjiDetailProtocol?
        
    func fetchURL(grade: String) {
        var stringURL = ""
        if grade == "6+" {
            stringURL = "\(baseURL)/grade-8"
        } else {
            stringURL = "\(baseURL)/grade-\(grade)"
        }
        fetchGradeData(from: stringURL)
    }
    
    mutating func fetchKanjiUrl(char: String) {
        
        let itemString = char
        let itemEncodeString = itemString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        let urlString = "\(baseURL)/\(itemEncodeString!)"
        let url = URL(string: urlString)
        fetchKaniData(from: url)
        
    }
    
    func fetchGradeData(from stringURL: String) {
        if let url = URL(string: stringURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    kanjiGradeDelegate?.didFailWithError(error: error!)
                }
                guard let safeData = data else {return}
                do {
                    let dataList = try JSONSerialization.jsonObject(with: safeData, options: []) as? [String] ?? ["..."]
                    self.kanjiGradeDelegate?.sendGradeKanjiList(self, kanjiList: dataList)
                }catch {
                    self.kanjiGradeDelegate?.didFailWithError(error: error)
                }
                
            }
            task.resume()
        }
    }
    
    
    func fetchKaniData(from url: URL?) {
        if let safeURL = url {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: safeURL) { data, response, error in
                if error != nil {
                    kanjiDelegate?.didFailWithError(error: error!)
                }
                if let safeData = data {
                    if let kanji = parseJson(data: safeData) {
                        kanjiDelegate?.sendKanjiData(self, kanji: kanji)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(data: Data) -> KanjiModal? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(KanjiData.self, from: data)
            let kanji = decodedData.kanji
            let grade = decodedData.grade
            let strokeCount = decodedData.stroke_count
            let meanings = decodedData.meanings
            let kun = decodedData.kun_readings
            let on = decodedData.on_readings
            let nameReadings = decodedData.name_readings
            let jlpt = decodedData.jlpt
            let unicode = decodedData.unicode
            
            let kanjiModal = KanjiModal(kanji: kanji,
                                   grade: grade,
                                   strokeCount: strokeCount,
                                   meanings: meanings,
                                   kun: kun,
                                   on: on,
                                   nameReadings: nameReadings,
                                   jlpt: jlpt, unicode: unicode)
            return kanjiModal
        }catch {
            kanjiDelegate?.didFailWithError(error: error)
            return nil
        }
    }

}

//MARK: - ViewUpdateFunctions

extension KanjiManager {
    func meanings(_ values: [String]) -> String {
        var meaning = ""
        var count = 0
        let listAmount = values.count
        for value in values {
            meaning += " \(value)"
            count += 1
            if count != listAmount {
                meaning += ","
            }
        }
        return meaning
    }
    
    func kun(_ values: [String]) -> String {
        var kun = ""
        var count = 0
        let listAmount = values.count
        for value in values {
            kun += " \(value)"
            count += 1
            if count != listAmount {
                kun += ","
            }
        }
        return kun
    }
    
    func on(_ values: [String]) -> String {
        var on = ""
        var count = 0
        let listAmount = values.count
        for value in values {
            on += " \(value)"
            count += 1
            if count != listAmount {
                on += ","
            }
        }
        return on
    }
    
    func nameReading(_ values: [String]) -> String {
        var names = ""
        var count = 0
        let listAmount = values.count
        for value in values {
            names += " \(value)"
            count += 1
            if count != listAmount {
                names += ","
            }
        }
        return names
    }
}

