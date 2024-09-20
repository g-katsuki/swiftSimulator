//
//  GameState.swift
//  puyoSimulator
//
//  Created by Katsuki Go on 2024/09/18.
//

import Foundation

class GameState {
    var grid: [[String?]] = Array(repeating: Array(repeating: nil, count: 6), count: 12)
    var currentPuyos = (puyo1: Puyo(color: "red", x: 2, y: 0), puyo2: Puyo(color: "blue", x: 3, y: 0))
    var nextPuyos = [Puyo(color: "green", x: 0, y: 0), Puyo(color: "yellow", x: 1, y: 0)]
    
    // Puyoを移動
    func movePuyos(x: Int, y: Int) {
        currentPuyos.puyo1.x += x
        currentPuyos.puyo1.y += y
        currentPuyos.puyo2.x += x
        currentPuyos.puyo2.y += y
    }
    
    // Puyoを落下
    func dropPuyos() {
        movePuyos(x: 0, y: 1)
    }
    
    // Puyoを左に回転
    func rotatePuyosLeft() {
        // 回転ロジック
    }
    
    // Puyoを右に回転
    func rotatePuyosRight() {
        // 回転ロジック
    }
    
    // 直前の動作を元に戻す
    func undoMove() {
        // アンドゥロジック
    }
    
    // ゲームをリセット
    func resetGame() {
        grid = Array(repeating: Array(repeating: nil, count: 6), count: 12)
        currentPuyos = (puyo1: Puyo(color: "red", x: 2, y: 0), puyo2: Puyo(color: "blue", x: 3, y: 0))
        nextPuyos = [Puyo(color: "green", x: 0, y: 0), Puyo(color: "yellow", x: 1, y: 0)]
    }
}
