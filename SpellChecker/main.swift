//
//  main.swift
//  SpellChecker
//
//  Created by Zan Kavtaskin on 20/06/2025.
//

import Foundation

let arguments = CommandLine.arguments

let wordDictionary = try WordDictionary(absoluteFilePath: arguments[1])

let wordToCheck: String = arguments[2]

let cpuSearch = CPUSearch(dictionary: wordDictionary)
let cpuStartTime = CFAbsoluteTimeGetCurrent()
let cpuMatch = await cpuSearch.Match(input: wordToCheck) ?? "<NONE>"
let cpuElapsedTime = CFAbsoluteTimeGetCurrent() - cpuStartTime

print("CPU: For word \(wordToCheck), found \(cpuMatch), time taken \(String(format: "%.05f", cpuElapsedTime)) seconds")


let gpuSearch = try GPUSearch(dictionary: wordDictionary)
let gpuStartTime = CFAbsoluteTimeGetCurrent()
let gpuMatch = try await gpuSearch.Match(input: wordToCheck) ?? "<NONE>"
let gpuElapsedTime = CFAbsoluteTimeGetCurrent() - gpuStartTime

print("GPU: For word \(wordToCheck), found \(gpuMatch), time taken \(String(format: "%.05f", gpuElapsedTime)) seconds")

print("GPU vs CPU: GPU is \(String(format: "%.02f", cpuElapsedTime / gpuElapsedTime))x faster")
