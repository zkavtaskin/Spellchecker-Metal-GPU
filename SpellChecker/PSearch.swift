//
//  Search.swift
//  SpellChecker
//
//  Created by Zan Kavtaskin on 20/06/2025.
//

protocol Search {
    init (dictionary: [WordDictionary])
    func Match(word: String) -> [String]
}
