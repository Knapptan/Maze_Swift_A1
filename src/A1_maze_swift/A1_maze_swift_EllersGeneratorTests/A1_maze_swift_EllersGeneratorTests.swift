//
//  A1_maze_swift_EllersGeneratorTests.swift
//  A1_maze_swift_EllersGeneratorTests
//
//  Created by Anton Krivonozhenkov on 27.03.2024.
//

import XCTest
@testable import A1_maze_swift

final class A1_maze_swift_EllersGeneratorTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testInitialization() {
        let generator = EllersGenerator(rows: 10, cols: 10)
        
        XCTAssertEqual(generator.numRows, 10, "Incorrect number of rows")
        XCTAssertEqual(generator.numCols, 10, "Incorrect number of columns")
    }
    
    
    func testMazeGeneration() {
        var generator = EllersGenerator(rows: 5, cols: 5)
        generator.generateMaze()
        
        XCTAssertEqual(generator.rightWallsArray.count, 5, "Incorrect number of rows in rightWallsArray")
        XCTAssertEqual(generator.rightWallsArray[0].count, 5, "Incorrect number of columns in rightWallsArray")
        XCTAssertEqual(generator.BottomWallsArray.count, 5, "Incorrect number of rows in BottomWallsArray")
        XCTAssertEqual(generator.BottomWallsArray[0].count, 5, "Incorrect number of columns in BottomWallsArray")
        
        
    }
    
    
    func testConvertBoolToIntToString() {
        var generator = EllersGenerator(rows: 3, cols: 3)
        generator.rightWallsArray = [[false, true, false],
                                     [true, false, true],
                                     [false, true, false]]
        generator.BottomWallsArray = [[true, false, true],
                                      [false, true, false],
                                      [true, false, true]]
        
        let expectedOutput = "3 3\n0 1 0\n1 0 1\n0 1 0\n\n1 0 1\n0 1 0\n1 0 1"
        XCTAssertEqual(generator.convertBoolToIntToString(), expectedOutput, "Incorrect conversion")
    }
    
    func testFillEmptyValue() {
        var generator = EllersGenerator(rows: 3, cols: 3)
        generator.fillEmptyValue()
        
        XCTAssertEqual(generator.currentLine, [0, 0, 0], "Incorrect filling of empty value")
    }
    
    func testAddingVerticalWalls() {
        var generator = EllersGenerator(rows: 3, cols: 3)
        generator.currentLine = [0, 0, 0]
        generator.rightWallsArray = [[false, false, false], [false, false, false], [false, false, false]]
        
        generator.addingVerticalWalls(row: 0)
        
        XCTAssertTrue(generator.rightWallsArray[0].contains(true))
    }
    
    func testChangeTheCell() {
        let generator = EllersGenerator(rows: 3, cols: 3)
        
        let updatedCell1 = generator.changeTheCell(value: 5, cell: -1)
        XCTAssertEqual(updatedCell1, 5)
        
        let updatedCell2 = generator.changeTheCell(value: 10, cell: 8)
        XCTAssertEqual(updatedCell2, 8)
        
        
        let updatedCell3 = generator.changeTheCell(value: 3, cell: 7)
        XCTAssertEqual(updatedCell3, 3)
    }
    
    func testTakePossibleSteps() {
        var generator = EllersGenerator(rows: 3, cols: 3)
        generator.BottomWallsArray = [[false, false, false], [false, false, false], [false, false, false]]
        generator.rightWallsArray = [[false, false, false], [false, false, false], [false, false, false]]
        generator.map = [[-1, -1, -1], [-1, -1, -1], [-1, -1, -1]]
        
        let result = generator.takePossibleSteps(step: 0)
        
        
        XCTAssertEqual(result, 0)
    }
    
    func testFindWay() {
        var generator = EllersGenerator(rows: 3, cols: 3)
        generator.BottomWallsArray = [[false, false, false], [false, false, false], [false, false, false]]
        generator.rightWallsArray = [[false, false, false], [false, false, false], [false, false, false]]
        
        let begin = EllersGenerator.someDot(x: 0, y: 0)
        let end = EllersGenerator.someDot(x: 2, y: 2)
        
        generator.findWay(begin: begin, end: end)
        
        
        XCTAssertEqual(generator.findPath, [EllersGenerator.someDot(x: 2, y: 2),
                                            EllersGenerator.someDot(x: 2, y: 1),
                                            EllersGenerator.someDot(x: 2, y: 0),
                                            EllersGenerator.someDot(x: 1, y: 0),
                                            EllersGenerator.someDot(x: 0, y: 0)])
    }
}
