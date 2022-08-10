//
//  KanjiData.swift
//  LearnKanji
//
//  Created by Sora on 11.07.2022.
//

import Foundation

struct KanjiData: Decodable {
    let kanji: String
    let grade: Int
    let stroke_count: Int
    let meanings: [String]
    let kun_readings: [String]
    let on_readings: [String]
    let name_readings: [String]
    let jlpt: Int?
    let unicode: String
}

