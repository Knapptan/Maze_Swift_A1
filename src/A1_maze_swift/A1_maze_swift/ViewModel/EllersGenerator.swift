//
//  EllersGenerator.swift
//  A1_maze_swift
//
//  Created by Anton Krivonozhenkov on 13.03.2024.
//

import Foundation

/// A struct representing an Ellers Maze Generator and Solver as Path Finder
struct EllersGenerator {
    
    struct someDot: Equatable {
        var x: Int;
        var y: Int;
    }
    
    /// The number of rows in the maze.
    var numRows: Int
    
    /// The number of columns in the maze.
    var numCols: Int
    
    /// Initializes an Ellers Maze Generator with the specified number of rows and columns.
    ///
    /// - Parameters:
    ///   - rows: The number of rows in the maze.
    ///   - cols: The number of columns in the maze.
    init(rows: Int, cols: Int) {
        self.numRows = rows
        self.numCols = cols
    }
    
    var findPath: [someDot] = []
    
    internal var map  = [[Int]]()
    internal let zero: Int = 0;
    internal var setsCounter: Int = 1;
    internal var currentLine = [Int]();
    internal var rightWallsArray  = [[Bool]]()
    internal var BottomWallsArray  = [[Bool]]()
    
    mutating func generateMaze() {
        rightWallsArray = Array(repeating: Array(repeating: false, count: numCols), count: numRows)
        BottomWallsArray = Array(repeating: Array(repeating: false, count: numCols), count: numRows)
        
        fillEmptyValue()
        for j in 0..<numRows-1 {
            assignUniqueSet();
            addingVerticalWalls(row: j);
            addingHorizontalWalls(row: j);
            checkedHorizontalWalls(row: j);
            preparatingNewLine(row: j);
        }
        addingEndLine();
    }
    
    func convertBoolToIntToString() -> String {
        var vertWalls = [[Int]]()
        var horizWalls = [[Int]]()
        
        for row in rightWallsArray {
            var newRow = [Int]()
            for element in row {
                newRow.append(element ? 1 : 0)
            }
            vertWalls.append(newRow)
        }
        
        for row in BottomWallsArray {
            var newRow = [Int]()
            for element in row {
                newRow.append(element ? 1 : 0)
            }
            horizWalls.append(newRow)
        }
        
        let rightWallOutput = vertWalls.map { $0.map { String($0) }.joined(separator: " ") }.joined(separator: "\n")
        let bottomWallOutput = horizWalls.map { $0.map { String($0) }.joined(separator: " ") }.joined(separator: "\n")
        
        let result = String(numRows) + " " + String(numCols) + "\n" + rightWallOutput + "\n\n" + bottomWallOutput
        
        let data = Data(result.utf8)
        let url = URL.downloadsDirectory.appending(path: generateFileName())
        
        do {
            try data.write(to: url, options: [.atomic, .completeFileProtection])
        } catch {
            print(error.localizedDescription)
        }
        
        return result
    }
    
    func generateFileName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let currentDateTime = Date()
        let formattedDate = dateFormatter.string(from: currentDateTime)
        let fileName = "file_\(formattedDate).txt"
        return fileName
    }
    
    /// Fills the current line with empty values.
    internal mutating func fillEmptyValue() {
        for _ in 0..<numCols {
            currentLine.append(zero)
        }
    }
    
    /// Assigns unique sets to elements in the current line.
    internal mutating func assignUniqueSet() {
        for i in 0..<numCols {
            if currentLine[i] == zero {
                currentLine[i] = setsCounter
                setsCounter += 1
            }
        }
    }
    
    internal mutating func addingVerticalWalls(row: Int) {
        for i in 0..<(numCols - 1) {
            let choice = Bool.random()
            if choice == true || currentLine[i] == currentLine[i + 1] {
                rightWallsArray[row][i] = true
            } else {
                mergeSet(index: i, element: currentLine[i])
            }
        }
        rightWallsArray[row][numCols - 1] = true
    }
    
    internal mutating func addingHorizontalWalls(row: Int) {
        for i in 0..<numCols {
            let choice = Bool.random()
            if calculateUniqueSet(currentLine[i]) != 1 && choice {
                BottomWallsArray[row][i] = true
            }
        }
    }
    
    private func calculateUniqueSet(_ element: Int) -> Int {
        var countUniqSet = 0
        for i in 0..<numCols {
            if currentLine[i] == element {
                countUniqSet += 1
            }
        }
        return countUniqSet
    }
    
    private mutating func checkedHorizontalWalls(row: Int) {
        for i in 0..<numCols {
            if calculateHorizontalWalls(currentLine[i], row) == 0 {
                BottomWallsArray[row][i] = false
            }
        }
    }
    
    private func calculateHorizontalWalls(_ element: Int, _ row: Int) -> Int {
        var countHorizontalWalls = 0
        for i in 0..<numCols {
            if currentLine[i] == element && BottomWallsArray[row][i] == false {
                countHorizontalWalls += 1
            }
        }
        return countHorizontalWalls
    }
    
    private mutating func preparatingNewLine(row: Int) {
        for i in 0..<numCols {
            if BottomWallsArray[row][i] == true {
                currentLine[i] = zero
            }
        }
    }
    
    private mutating func addingEndLine() {
        assignUniqueSet();
        addingVerticalWalls(row: numRows - 1);
        checkedEndLine();
    }
    
    private mutating func checkedEndLine() {
        for i in 0..<(numCols - 1) {
            if currentLine[i] != currentLine[i + 1] {
                rightWallsArray[numRows - 1][i] = false
                mergeSet(index: i, element: currentLine[i])
            }
            BottomWallsArray[numRows - 1][i] = true
        }
        BottomWallsArray[numRows - 1][numCols - 1] = true
    }
    
    private mutating func mergeSet(index: Int, element: Int) {
        let mutableSet = currentLine[index + 1]
        for j in 0..<numCols {
            if currentLine[j] == mutableSet {
                currentLine[j] = element
            }
        }
    }
    
    
    internal func changeTheCell(value: Int, cell: Int) -> Int {
        var updatedCell = cell
        if updatedCell == -1 {
            updatedCell = value
        } else {
            updatedCell = min(updatedCell, value)
        }
        return updatedCell
    }
    
    internal mutating func takePossibleSteps(step: Int) -> Int {
        var result = 0
        
        for i in 0..<numRows {
            for j in 0..<numCols {
                if map[i][j] == step {
                    result += 1
                    
                    if i < numRows - 1 && !BottomWallsArray[i][j] {
                        map[i + 1][j] = changeTheCell(value: step + 1, cell: map[i + 1][j])
                    }
                    
                    if i > 0 && !BottomWallsArray[i - 1][j] {
                        map[i - 1][j] = changeTheCell(value: step + 1, cell: map[i - 1][j])
                    }
                    
                    if j < numCols - 1 && !rightWallsArray[i][j] {
                        map[i][j + 1] = changeTheCell(value: step + 1, cell: map[i][j + 1])
                    }
                    
                    if j > 0 && !rightWallsArray[i][j - 1] {
                        map[i][j - 1] = changeTheCell(value: step + 1, cell: map[i][j - 1])
                    }
                }
            }
        }
        
        return result
    }
    
    mutating func findWay(begin: someDot, end: someDot) {
        
        map.removeAll()
        findPath.removeAll()
        
        map = [[Int]](repeating: [Int](repeating: -1, count: numCols), count: numRows)
        
        var y = end.y
        var x = end.x
        var count = 1
        var step = 0
        
        map[begin.y][begin.x] = 0
        
        while count > 0 && map[y][x] == -1 {
            count = takePossibleSteps(step: step)
            step += 1
        }
        
        if map[y][x] != -1 {
            step = map[y][x]
            findPath.append(someDot(x: x, y: y))
            
            while y != begin.y || x != begin.x {
                if y < numRows - 1 && !BottomWallsArray[y][x] && map[y + 1][x] == step - 1 {
                    y += 1
                } else if y > 0 && !BottomWallsArray[y - 1][x] && map[y - 1][x] == step - 1 {
                    y -= 1
                } else if x < numCols - 1 && !rightWallsArray[y][x] && map[y][x + 1] == step - 1 {
                    x += 1
                } else if x > 0 && !rightWallsArray[y][x - 1] && map[y][x - 1] == step - 1 {
                    x -= 1
                }
                findPath.append(someDot(x: x, y: y))
                step -= 1
            }
        }
    }
}
