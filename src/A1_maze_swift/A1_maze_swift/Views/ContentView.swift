//
//  ContentView.swift
//  A1_maze_swift
//
//  Created by Anton Krivonozhenkov on 12.03.2024.
//

import SwiftUI

struct ContentView: View {
    // Модальное представление для лабиринта
    @State private var mazeStruct: mazeContent? = nil
    @State private var isMazeGenerationModalPresented = false
    // Модальное представление для пещер
    @State private var cavesStruct: cavesContent? = nil
    @State private var isCaveGenerationModalPresented = false
    // Переменные для ввода размера
    @State private var inputValueCols: String = ""
    @State private var inputValueRows: String = ""
    // Переменные для ввода жизненных циклов
    @State private var  inputBirthСycle: String = ""
    @State private var  inputDeathСycle: String = ""
    
    @State private var  operaitonId: String = ""
    
    @State private var x1: CGFloat = -1
    @State private var y1: CGFloat = -1
    @State private var x2: CGFloat = -1
    @State private var y2: CGFloat = -1
    
    @State private var dot1: Bool = false
    @State private var dot2: Bool = false
    @State private var solution: Bool = false
    
    // Рекурсивная функция для обновления пещеры
    func updateCave(cave: cavesContent, birthLimit: Int, deathLimit: Int, cyclesLeft: Int) {
        var updatedCave = cave
        
        if cyclesLeft == 0 {
            return
        }
        
        // Обновляем состояние пещеры с заданными параметрами
        updatedCave.update(birthLimit: birthLimit, deathLimit: deathLimit)
        cavesStruct = updatedCave
        
        // После обновления вызываем перерисовку пещеры
        operaitonId = UUID().uuidString
        // Проверяем, остались ли еще циклы
        if cyclesLeft > 1 {
            // Запускаем таймер для следующего обновления через 1 секунды
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                updateCave(cave: updatedCave, birthLimit: birthLimit, deathLimit: deathLimit, cyclesLeft: cyclesLeft - 1)
            }
        }
    }
    
    let canvasWidth: Double = 500
    let canvasHeight: Double = 500
    
    @State private var mazee = EllersGenerator(rows: 1, cols: 1)
    
    var body: some View {
        VStack {
            HStack {
                buttonOpenMaze
                buttonOpenCaves
                buttonGenerateMaze
                buttonGenerateCave
            }
            
            if let maze = mazeStruct {
                Canvas { context, size in
                    let cellWidth = size.width / CGFloat(maze.wallsRight[0].count)
                    let cellHeight = size.height / CGFloat(maze.wallsBottom.count)
                    
                    context.fill(Path(roundedRect: CGRect(origin: .zero, size: size), cornerSize: CGSize(width: 0, height: 0)), with: .color(.white))
                    
                    for i in 0..<maze.wallsRight.count {
                        for j in 0..<maze.wallsRight[i].count {
                            if maze.wallsRight[i][j] == 1 {
                                let x = CGFloat(j) * cellWidth
                                let y = CGFloat(i) * cellHeight
                                context.fill(Rectangle().path(in: CGRect(x: x + cellWidth, y: y, width: 1, height: cellHeight)), with: .color(.black))
                            }
                        }
                    }
                    
                    for i in 0..<maze.wallsBottom.count {
                        for j in 0..<maze.wallsBottom[i].count {
                            if maze.wallsBottom[i][j] == 1 {
                                let x = CGFloat(j) * cellWidth
                                let y = CGFloat(i) * cellHeight
                                context.fill(Rectangle().path(in: CGRect(x: x, y: y + cellHeight - 1, width: cellWidth, height: 1)), with: .color(.black))
                            }
                        }
                    }
                    
                    if dot1 {
                        context.stroke(
                            Path(ellipseIn: CGRect(origin: CGPoint(x: x1-2, y: y1-2), size: CGSize(width: 4, height: 4))),
                            with: .color(.red),
                            lineWidth: 4)
                        
                        let dot1 = EllersGenerator.someDot(x: Int(x1 / cellWidth),
                                                           y: Int(y1 / cellHeight))
                        
                        
                        
                        context.fill(Path(CGRect(x: CGFloat(CGFloat(dot1.x) * cellWidth),
                                                 y: CGFloat(CGFloat(dot1.y) * cellHeight),
                                                 width: cellWidth,
                                                 height: cellHeight)),
                                     with: .color(.red.opacity(0.5)))
                        
                        
                    }
                    
                    if dot2 {
                        context.stroke(
                            Path(ellipseIn: CGRect(origin: CGPoint(x: x2-2, y: y2-2), size: CGSize(width: 4, height: 4))),
                            with: .color(.yellow),
                            lineWidth: 4)
                        
                        let dot2 = EllersGenerator.someDot(x: Int(x2 / cellWidth),
                                                           y: Int(y2 / cellHeight))
                        
                        
                        
                        context.fill(Path(CGRect(x: CGFloat(CGFloat(dot2.x) * cellWidth),
                                                 y: CGFloat(CGFloat(dot2.y) * cellHeight),
                                                 width: cellWidth,
                                                 height: cellHeight)),
                                     with: .color(.yellow.opacity(0.5)))
                    }
                    
                    if solution {
                        var path = Path()
                        
                        let squareWidth: Double = canvasWidth / Double(mazee.numCols)
                        let squareHeight: Double = canvasHeight / Double(mazee.numRows)
                        
                        for i in 0..<mazee.findPath.count - 1 {
                            let x1 = Double(mazee.findPath[i].x) * squareWidth + squareWidth / 2
                            let y1 = Double(mazee.findPath[i].y) * squareHeight + squareHeight / 2
                            path.move(to: CGPoint(x: x1, y: y1))
                            
                            let x2 = Double(mazee.findPath[i + 1].x) * squareWidth + squareWidth / 2
                            let y2 = Double(mazee.findPath[i + 1].y) * squareHeight + squareHeight / 2
                            path.addLine(to: CGPoint(x: x2, y: y2))
                            
                            context.stroke(path, with: .color(.green), lineWidth: 2)
                        }
                    }
                }
                .frame(width: canvasWidth, height: canvasHeight)
                .border(Color.black, width: 2)
                .overlay(content: {
                    //                    if !inputValueCols.isEmpty && !inputValueRows.isEmpty {
                    VStack {
                        buttonSolveMaze
                        buttonStartOver
                            .opacity((dot1 || dot2) ? 1 : 0)
                    }.offset(x: canvasWidth / 2 + 75, y: -canvasHeight/2 + 40)
                    //                    }
                })
                
                .onHover { hover in
                    if hover { NSCursor.crosshair.push() } else { NSCursor.pop() }
                }
                .onContinuousHover { phase in
                    switch phase {
                    case .active(let location):
                        //  print("---> location: \(location)")
                        
                        if !dot1 && !dot2 {
                            x1 = location.x
                            y1 = location.y
                        } else  if dot1 && !dot2  {
                            x2 = location.x
                            y2 = location.y
                        }
                        
                    case .ended:
                        break
                    }
                }
                .onTapGesture { if !dot1 && !dot2  { dot1 = true } else
                    if dot1 && !dot2 { dot2 = true } }
                
            } else if let caves = cavesStruct {
                Canvas { context, size in
                    let cellWidth = size.width / CGFloat(caves.cells[0].count)
                    let cellHeight = size.height / CGFloat(caves.cells.count)
                    
                    // Отрисовка фона
                    context.fill(Path(roundedRect: CGRect(origin: .zero, size: size), cornerSize: CGSize(width: 0, height: 0)), with: .color(.white))
                    
                    // Отрисовка пещер
                    for i in 0..<caves.cells.count {
                        for j in 0..<caves.cells[i].count {
                            if caves.cells[i][j] == 1 {
                                let x = CGFloat(j) * cellWidth
                                let y = CGFloat(i) * cellHeight
                                context.fill(Rectangle().path(in: CGRect(x: x, y: y, width: cellWidth, height: cellHeight)), with: .color(.black))
                            }
                        }
                    }
                }
                .frame(width: canvasWidth, height: canvasHeight)
                .border(Color.black, width: 2)
            } else {                VStack {}
                    .frame(width: canvasWidth, height: canvasHeight)
            }
        }
        
        .sheet(isPresented: $isMazeGenerationModalPresented) {
            ModalView(isPresented: $isMazeGenerationModalPresented,
                      mazeWidth: $inputValueCols,
                      mazeHeight: $inputValueRows)
        }
        
        .sheet(isPresented: $isCaveGenerationModalPresented) {
            CavesModalView(isPresented: $isCaveGenerationModalPresented,
                           inputValueCols: $inputValueCols,
                           inputValueRows: $inputValueRows, inputBirthСycle: $inputBirthСycle, inputDeathСycle: $inputDeathСycle)
        }
        
        .padding()
    }
    
    var buttonOpenMaze: some View {
        Button(action: {
            restartMaze()
            inputValueCols = ""
            inputValueRows = ""
            
            let panel = NSOpenPanel()
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = false
            if panel.runModal() == .OK, let fileURL = panel.url {
                do {
                    let text = try String(contentsOf: fileURL, encoding: .utf8)
                    
                    let mazeContent = parseMazeFile(fileContent: text)
                    self.cavesStruct = nil
                    self.mazeStruct = mazeContent
                    
                    if mazeContent != nil {
                        inputValueRows = String(mazeContent?.x ?? 1)
                        inputValueCols = String(mazeContent?.y ?? 1)
                        
                        mazee.numCols = Int(inputValueCols) ?? 1
                        mazee.numRows = Int(inputValueRows) ?? 1
                        
                        mazee.BottomWallsArray = (mazeContent?.wallsBottom.map { row in
                            row.map { value in
                                value == 1 ? true : false
                            }
                        })!
                        
                        mazee.rightWallsArray = (mazeContent?.wallsRight.map { row in
                            row.map { value in
                                value == 1 ? true : false
                            }
                        })!
                    }
                }
                catch {
                    print("Error reading file:", error.localizedDescription)
                }
            }
        }, label: {
            Text("Open maze file")
        })
    }
    
    var buttonOpenCaves: some View {
        Button(action: {
            let panel = NSOpenPanel()
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = false
            if panel.runModal() == .OK, let fileURL = panel.url {
                do {
                    let text = try String(contentsOf: fileURL, encoding: .utf8)
                    
                    let cavesContent = parseCavesFile(fileContent: text)
                    self.mazeStruct = nil
                    self.cavesStruct = cavesContent
                    //                            print(self.cavesStruct)
                }
                catch {
                    print("Error reading file:", error.localizedDescription)
                }
            }
        }, label: {
            Text("Open caves file")
        })
    }
    
    var buttonGenerateMaze: some View {
        Button(action: {
            restartMaze()
            isMazeGenerationModalPresented.toggle()
        }, label: {
            Text("Generate perfect maze")
        })
        .onChange(of: isMazeGenerationModalPresented) { oldValue, newValue in
            if newValue == false {
                
                guard let localX = Int(inputValueCols), localX > 1,
                      let localY = Int(inputValueRows), localY > 1
                else {
                    return
                }
                
                mazee = EllersGenerator(rows: localX,
                                        cols: localY)
                mazee.generateMaze()
                let text = mazee.convertBoolToIntToString()
                
                let mazeContent = parseMazeFile(fileContent: text)
                self.cavesStruct = nil
                self.mazeStruct = mazeContent
            }
        }
    }
    
    var buttonSolveMaze: some View {
        Button(action: {
            
            let squareWidth = canvasWidth / Double(inputValueRows)!
            let squareHeight = canvasHeight / Double(inputValueCols)!
            
            let dot1 = EllersGenerator.someDot(x: Int(x1 / squareWidth),
                                               y: Int(y1 / squareHeight))
            
            let dot2 = EllersGenerator.someDot(x: Int(x2 / squareWidth),
                                               y: Int(y2 / squareHeight))
            
            mazee.findWay(begin: dot2, end: dot1)
            solution = true
            
        }, label: {
            Text("Solving the maze")
        })
        .disabled((dot1 && dot2) ? false : true)
    }
    
    var buttonGenerateCave: some View {
        Button(action: {
            isCaveGenerationModalPresented.toggle()
        }, label: {
            Text("Cave Generation")
        })
        .onChange(of: isCaveGenerationModalPresented) { oldValue, newValue in
            if newValue == false {
                guard var caveWidth = Int(inputValueCols), caveWidth > 0,
                      var caveHeight = Int(inputValueRows), caveHeight > 0,
                      let birthLimit = Int(inputBirthСycle),
                      let deathLimit = Int(inputDeathСycle)
                else {
                    return
                }
                
                caveWidth *= 10
                caveHeight *= 10
                
                var cave = cavesContent(x: caveWidth, y: caveHeight)
                cave.generateInitial()
                cavesStruct = cave
                mazeStruct = nil
                restartMaze()
                updateCave(cave: cave, birthLimit: birthLimit, deathLimit: deathLimit, cyclesLeft: 20)
                cavesStruct = cave
            }
        }
    }
    
    var buttonStartOver: some View {
        Button(action: { restartMaze() }, label: { Text("Start over")  }) }
    
    private func restartMaze() {
        x1 = -1
        y1 = -1
        x2 = -1
        y2 = -1
        
        dot1 = false
        dot2 = false
        solution = false
    }
}


#Preview {
    ContentView()
}
