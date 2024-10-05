//
//  PuyoGrid.swift
//  puyoSimulator
//
//  Created by Katsuki Go on 2024/09/20.
//

struct PuyoGrid {
    let width: Int
    let height: Int
    var grid: [[Puyo?]]

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.grid = Array(repeating: Array(repeating: nil, count: width), count: height)
    }

    mutating func addPuyo(_ puyo: Puyo) {
        let x = puyo.position.x
        let y = puyo.position.y
        if x >= 0 && x < width && y >= 0 && y < height {
            grid[y][x] = puyo
        }
    }

    mutating func removePuyo(at position: (Int, Int)) {
        let (x, y) = position
        if x >= 0 && x < width && y >= 0 && y < height {
            grid[y][x] = nil
        }
    }
}
