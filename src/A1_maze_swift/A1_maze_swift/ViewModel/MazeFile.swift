//
//  MazeFile.swift
//  A1_maze_swift
//
//  Created by Anton Krivonozhenkov on 13.03.2024.
//

import Foundation

struct mazeContent {
    var x: Int = 0 // количество ячеек по x
    var y: Int = 0 // количество ячеек по y
    
    var wallsRight: [[Int]] = [] // Двумерный массив для стен справа
    var wallsBottom: [[Int]] = [] // Двумерный массив для стен снизу
}

func parseMazeFile(fileContent: String) -> mazeContent? {
    var content = mazeContent()
    var correctMaze: Bool = false
    
    var allLines = fileContent.components(separatedBy: "\n")
    allLines = allLines.filter { !$0.isEmpty }
    
    if allLines.count > 0 {
        let dimensions = allLines[0].components(separatedBy: " ")
        if dimensions.count == 2, let x = Int(dimensions[0]), let y = Int(dimensions[1]) {
            content.x = x
            content.y = y
            
            content.wallsRight = Array(repeating: Array(repeating: 0, count: content.y), count: content.x)
            content.wallsBottom = Array(repeating: Array(repeating: 0, count: content.y), count: content.x)
            
            if allLines.count == (x + x + 1) {
                for lineIndex in 1..<content.x + 1 {
                    let wallIndices = allLines[lineIndex].components(separatedBy: " ").compactMap { Int($0) }
                    content.wallsRight[lineIndex - 1] = wallIndices
                }
                
                for lineIndex in content.x + 1..<allLines.count - 1 {
                    let wallIndices = allLines[lineIndex].components(separatedBy: " ").compactMap { Int($0) }
                    content.wallsBottom[lineIndex - content.x - 1] = wallIndices
                }
                
                correctMaze = true
            }
        } else { correctMaze = false}
    }
    
    return correctMaze ? content : nil
}

//extension Collection {
//    subscript (safe index: Index) -> Element? {
//        return indices.contains(index) ? self[index] : nil
//    }
//}
