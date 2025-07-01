//
//  Untitled.swift
//  SpellChecker
//
//  Created by Zan Kavtaskin on 20/06/2025.
//

import Foundation

class WordDictionary {
    public var Words: [String] = []
    init (path: String) throws  {
        do {
            let contents = try String(contentsOfFile: path, encoding: .utf8)
            let data = contents.data(using: .utf8)
            let dictionary = try JSONSerialization.jsonObject(with: data!) as? [String: String]
            self.Words = (dictionary?.keys.map { $0 })!
        } catch {
            throw error
        }
    }
}
