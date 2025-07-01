//
//  GPUSearch.swift
//  SpellChecker
//
//  Created by Zan Kavtaskin on 20/06/2025.
//

import Foundation
import Metal

class GPUSearch : Search {
    
    private var wordDictionary: WordDictionary
    
    required init(dictionary: WordDictionary) throws {
        self.wordDictionary = dictionary
    }
    
    func Match(input: String) async throws -> String? {
        
        let device = MTLCreateSystemDefaultDevice()
        let commandQueue = device?.makeCommandQueue()
        let gpuFunctionLibrary = device?.makeDefaultLibrary()
        let gpuFunc = gpuFunctionLibrary?.makeFunction(name: "levenshteinDistance")
        
        let computePipelineState = try await device?.makeComputePipelineState(function: gpuFunc!)

        /*
         Cannot pass [String] to C++, due to this I have converted
         the entire dictionary to single contiguous string "somewordsalltogether..."
        */
        let dicAsSingleString = self.wordDictionary.GetAsSingleString()
        let wordCount = self.wordDictionary.Words.count
        
        let dicBuffer = device?.makeBuffer(bytes: dicAsSingleString,
                                                  length: dicAsSingleString.count,
                                          options: .storageModeShared)
    
        /*
         Given dicAsSingleString is just bunch of strings joined together
         you need to know where one string starts and ends. For this I have
         created index array [0, 4, 9...]
        */
        let dicIndxs = self.wordDictionary.GetStartingIndex()
        let dicIndxsBuffer = device?.makeBuffer(bytes: dicIndxs,
                                                      length: MemoryLayout<Int32>.size * wordCount,
                                          options: .storageModeShared)

        //input, word you want to spell check, in this case sesquipedalianism
        let inputBuff = device?.makeBuffer(bytes: input,
                                          length: MemoryLayout<String>.size * input.count,
                                          options: .storageModeShared)


        var inputSize : Int32 = Int32(input.count);
        let inputSizeBuff = device?.makeBuffer(bytes: &inputSize, length: MemoryLayout<Int32>.size, options: .storageModeShared);

        //Store results for later processing.
        let outputBuff = device?.makeBuffer(length: MemoryLayout<Int32>.size * wordCount,
                                            options: .storageModeShared)

        
        let commandBuffer = commandQueue?.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeComputeCommandEncoder()
        commandEncoder?.setComputePipelineState(computePipelineState!)
        commandEncoder?.setBuffer(inputBuff, offset: 0, index: 0)
        commandEncoder?.setBuffer(inputSizeBuff, offset: 0, index: 1) // <- notice the index locations
        commandEncoder?.setBuffer(dicBuffer, offset: 0, index: 2)
        commandEncoder?.setBuffer(dicIndxsBuffer, offset: 0, index: 3)
        commandEncoder?.setBuffer(outputBuff, offset: 0, index: 4)
        
        let threadsPerGrid = MTLSize(width: wordCount, height: 1, depth: 1)
        let maxThreadsPerThreadgroup = computePipelineState!.maxTotalThreadsPerThreadgroup
        let threadsPerThreadgroup = MTLSize(width: maxThreadsPerThreadgroup, height: 1, depth: 1)
        commandEncoder?.dispatchThreads(threadsPerGrid,
                                        threadsPerThreadgroup: threadsPerThreadgroup)
        
        
        commandEncoder?.endEncoding()
        commandBuffer?.commit()
        commandBuffer?.waitUntilCompleted()
        
        var min_value: Int32 = Int32(input.count)
        var min_index: Int32 = -1
        
        var resultBufferPointer = outputBuff?.contents().bindMemory(to: Int32.self,
                                                                    capacity: MemoryLayout<Int32>.size * wordCount)
        
        for i in 0..<wordCount {
            if min_value > Int32(resultBufferPointer!.pointee)   {
                min_value = Int32(resultBufferPointer!.pointee)
                min_index = Int32(i)
            }
            resultBufferPointer = resultBufferPointer?.advanced(by: 1)
        }
        
        if min_index != -1 {
            return self.wordDictionary.Words[Int(min_index)]
        }
        
        return nil
    }
    
}
