//
//  Untitled.swift
//  SpellChecker
//
//  Created by Zan Kavtaskin on 20/06/2025.
//

import Foundation

class WordDictionary {
    public private(set) var Words: [String] = []
    init (absoluteFilePath: String) throws  {
        let contents = try String(contentsOfFile: absoluteFilePath, encoding: .utf8)
        let data = contents.data(using: .utf8)!
        self.Words  = try JSONDecoder().decode([String].self, from: data)
    }

    func GetStartingIndex() -> [Int32] {
        var result: [Int32] = []
        var counter: Int32 = 0
        for i in 0..<self.Words.count {
            result.append(counter)
            counter += Int32(self.Words[i].count)
        }
        return result
    }
    
    func GetAsSingleString() -> String {
        return self.Words.joined(separator: "")
    }
}
