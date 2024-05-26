//
//  A1_CavesGeneneratorTests.swift
//  A1_maze_swift_EllersGeneratorTests
//
//  Created by Knapptan on 02.05.2024.
//

import XCTest
@testable import A1_maze_swift

final class A1_CavesGeneneratorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Test empty initialization
    func testEmptyInitializationCaves() {
        let caves = cavesContent()
        XCTAssertEqual(caves.x, 0, "Incorrect number of rows")
        XCTAssertEqual(caves.y, 0, "Incorrect number of columns")
        XCTAssertEqual(caves.cells, [], "Cells should be empty")
    }
    
    // Test initialization with specified size
    func testInitializationCaves() {
        let caves = cavesContent(x: 10, y: 10)
        XCTAssertEqual(caves.x, 10, "Incorrect number of rows")
        XCTAssertEqual(caves.y, 10, "Incorrect number of columns")
        XCTAssertEqual(caves.cells.count, 10, "Incorrect number of rows in cells")
        for row in caves.cells {
            XCTAssertEqual(row.count, 10, "Incorrect number of columns in cells")
        }
    }
    
    // Test cave generation
    func testCaveGeneration() {
        var caves = cavesContent(x: 10, y: 10)
        caves.generateInitial()
        XCTAssertEqual(caves.cells.count, 10, "Incorrect number of rows in cells")
        for row in caves.cells {
            XCTAssertEqual(row.count, 10, "Incorrect number of columns in cells")
        }
    }
    
    // Test cave update
    func testCaveUpdate() {
        var caves = cavesContent(x: 10, y: 10)
        caves.generateInitial()
        let originalCells = caves.cells
        caves.update(birthLimit: 3, deathLimit: 2)
        XCTAssertNotEqual(caves.cells, originalCells, "Cells should be updated after update function")
    }
    
    func testCountAliveNeighbours() {
        var cave = cavesContent(x: 5, y: 5)
        // Установим некоторые клетки в состояние "живых" (1)
        cave.cells = [
            [0, 1, 0, 0, 1],
            [1, 1, 1, 0, 0],
            [0, 1, 0, 0, 0],
            [0, 0, 1, 0, 1],
            [1, 0, 0, 1, 1]
        ]
        
        // Проверим соседей для различных клеток
        XCTAssertEqual(cave.countAliveNeighborsForRow(0, col: 0), 8, "Incorrect count for (0,0)")
        XCTAssertEqual(cave.countAliveNeighborsForRow(1, col: 1), 4, "Incorrect count for (1,1)")
        XCTAssertEqual(cave.countAliveNeighborsForRow(2, col: 2), 4, "Incorrect count for (2,2)")
        XCTAssertEqual(cave.countAliveNeighborsForRow(3, col: 3), 4, "Incorrect count for (3,3)")
        XCTAssertEqual(cave.countAliveNeighborsForRow(4, col: 4), 7, "Incorrect count for (4,4)")
        // Также можно проверить граничные случаи
        XCTAssertEqual(cave.countAliveNeighborsForRow(0, col: 4), 5, "Incorrect count for (0,4)")
        XCTAssertEqual(cave.countAliveNeighborsForRow(4, col: 0), 5, "Incorrect count for (4,0)")
    }
    
    func testParseCavesFile() {
        let fileContent = "\n5 5\n0 1 0 0 1\n1 1 1 0 0\n0 1 0 0 0\n0 0 1 0 1\n1 0 0 1 1"
        let cave = parseCavesFile(fileContent: fileContent)
        XCTAssertEqual(cave.x, 5, "Incorrect number of rows")
        XCTAssertEqual(cave.y, 5, "Incorrect number of columns")
        XCTAssertEqual(cave.cells, [
            [0, 1, 0, 0, 1],
            [1, 1, 1, 0, 0],
            [0, 1, 0, 0, 0],
            [0, 0, 1, 0, 1],
            [1, 0, 0, 1, 1]
        ], "Incorrect cell states")
    }

}
