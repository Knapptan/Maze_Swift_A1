//
//  CavesFile.swift
//  A1_maze_swift
//
//  Created by Knapptan on 13.03.2024.
//

import Foundation

func parseCavesFile(fileContent: String?) -> cavesContent {
    var content = cavesContent()
    
    guard let fileContent = fileContent else {
        return content // Вернуть пустой контент, если входная строка равна nil
    }
    
    var allLines = fileContent.components(separatedBy: "\n")
    allLines = allLines.filter { !$0.isEmpty }
    
    if allLines.count > 0 {
        let dimensions = allLines[0].components(separatedBy: " ")
        guard dimensions.count == 2, let x = Int(dimensions[0]), let y = Int(dimensions[1]) else {
            print("Invalid dimensions")
            return cavesContent()
        }
        
        content.x = x
        content.y = y
        
        content.cells = Array(repeating: Array(repeating: 0, count: content.y), count: content.x)
        
        for lineIndex in 1..<content.x + 1 {
            let wallIndices = allLines[lineIndex].components(separatedBy: " ").compactMap { Int($0) }
            content.cells[lineIndex - 1] = wallIndices
        }
    }
    
    return content
}
