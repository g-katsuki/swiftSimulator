//
//  PlacePuyos.swift
//  puyoSimulator
//
//  Created by Katsuki Go on 2024/12/30.
//

import Foundation

// ぷよを設置し、次のぷよを現在のぷよにする
func placePuyos(puyoGrid: inout PuyoGrid,
                currentPuyos: inout [Puyo],
                nextPuyos: inout [Puyo],
                nextdPuyos: inout [Puyo],
                nextPuyoHistory: inout [[Puyo]],
                currentHistoryIndex: inout Int)
{
    currentPuyos = nextPuyos  // ネクストぷよをcurrentPuyosに移動
    nextPuyos = nextdPuyos
    
    if (currentHistoryIndex == 0 || currentHistoryIndex == 1 || currentHistoryIndex == 2) &&
        currentHistoryIndex < nextPuyoHistory.count - 3 {
        nextdPuyos = nextPuyoHistory[currentHistoryIndex+3]
    }
    // ネクストぷよを履歴から復元するか、新しく生成
    else if currentHistoryIndex < nextPuyoHistory.count - 3 {
        // 履歴からネクストぷよを取得（次の履歴に進む）
        nextdPuyos = nextPuyoHistory[currentHistoryIndex+3]
    } else {
        // 履歴がない場合、新しくネクストぷよを生成
        let firstPuyo = Puyo(color: randomPuyoColor(), position: Position(x: 2, y:  0))
        let secondPuyo = Puyo(color: randomPuyoColor(), position: Position(x: 2, y:  1))
        nextdPuyos = [firstPuyo, secondPuyo]
        
        nextPuyoHistory.append(nextdPuyos)
    }
    // 現在のぷよをグリッドに追加
    for puyo in currentPuyos {
        puyoGrid.addPuyo(puyo)
    }
}
