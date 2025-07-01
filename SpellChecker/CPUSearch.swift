//
//  CPUSearch.swift
//  SpellChecker
//
//  Created by Zan Kavtaskin on 20/06/2025.
//

class CPUSearch : Search {
    private  var wordDictionary: WordDictionary
    required init(dictionary: WordDictionary) {
        self.wordDictionary = dictionary
    }
    
    func Match(input: String) async -> String? {
        await withTaskGroup(of: (String, Int)?.self) { group in
            for dicWord in self.wordDictionary.Words {
                group.addTask {
                    let distance = self.levenshteinDistance(input, dicWord)
                    return (dicWord, distance)
                }
            }

            var bestMatch: String? = nil
            var minDistance = input.count

            for await result in group {
                if let (dicWord, distance) = result, distance < minDistance {
                    minDistance = distance
                    bestMatch = dicWord
                }
            }

            return bestMatch
        }
    }
    
    private func levenshteinDistance(_ lhs: String, _ rhs: String) -> Int {
        let lhsChars = Array(lhs)
        let rhsChars = Array(rhs)
        let lhsLength = lhsChars.count
        let rhsLength = rhsChars.count
        
        var matrix = Array(repeating: Array(repeating: 0, count: rhsLength + 1), count: lhsLength + 1)
        
        for i in 0...lhsLength {
            matrix[i][0] = i
        }
        
        for j in 0...rhsLength {
            matrix[0][j] = j
        }
        
        for i in 1...lhsLength {
            for j in 1...rhsLength {
                if lhsChars[i - 1] == rhsChars[j - 1] {
                    matrix[i][j] = matrix[i - 1][j - 1]
                } else {
                    matrix[i][j] = min(matrix[i - 1][j - 1] + 1, min(matrix[i][j - 1] + 1, matrix[i - 1][j] + 1))
                }
            }
        }
        
        return matrix[lhsLength][rhsLength]
    }
}
