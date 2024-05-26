//
//  CavesGenerator.swift
//  A1_maze_swift
//
//  Created by Knapptan on 02.05.2024.
//

import Foundation

struct cavesContent {
    var x: Int = 0 // количество ячеек по x
    var y: Int = 0 // количество ячеек по y
    var cells: [[Int]] = []  // 1 - стена, 0 - пусто
    
    // Инициализация пещеры с заданным размером
      init(x: Int, y: Int) {
          self.x = x
          self.y = y
          self.cells = Array(repeating: Array(repeating: 0, count: x), count: y)
      }
    
    // Пустая инициализация
    init() {}
    
    // Генерация начального состояния пещеры
    mutating func generateInitial() {
        for col in 0..<x {
            for row in 0..<y {
                // Случайно решаем, будет ли данная клетка стеной или пустой
                cells[row][col] = Int.random(in: 0...1)
            }
        }
    }
    
    // Обновление состояния пещеры по принципу клеточного автомата
    mutating func update(birthLimit: Int, deathLimit: Int) {
        var nextCells = cells

        for row in 0..<y {
            for col in 0..<x {
                let aliveNeighbours = countAliveNeighbours(row: row, col: col)

                if cells[row][col] == 1 {
                    if aliveNeighbours < deathLimit {
                        nextCells[row][col] = 0
                    }
                } else {
                    if aliveNeighbours > birthLimit {
                        nextCells[row][col] = 1
                    }
                }
            }
        }
        cells = nextCells
    }

    
    // Подсчет количества соседних живых клеток для клетки в заданной позиции
    private func countAliveNeighbours(row: Int, col: Int) -> Int {
        var count = 0
        for i in -1...1 {
            for j in -1...1 {
                let newRow = row + i
                let newCol = col + j
                // Проверка что новая позиция в пределах пещеры
                
                if newRow >= 0 && newRow < y && newCol >= 0 && newCol < x && !(i == 0 && j == 0) {
                    // Если соседняя клетка стена, увеличиваем счетчик
                    if cells[newRow][newCol] == 1 {
                        count += 1
                    }
                    // Если координаты на за перделами - клетки стены
                    // Текущие координаты пропускаем
                } else if !(i == 0 && j == 0) {
                    count += 1
                }
            }
        }
      return count
    }
 
    // Публичный метод для подсчета живых соседей для заданной клетки
    func countAliveNeighborsForRow(_ row: Int, col: Int) -> Int {
        // Вызов приватной функции для подсчета живых соседей
        return countAliveNeighbours(row: row, col: col)
    }
    
    
}
