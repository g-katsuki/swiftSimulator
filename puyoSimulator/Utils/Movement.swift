//
//  Movement.swift
//  puyoSimulator
//
//  Created by Katsuki Go on 2024/12/30.
//

import Foundation

func movePuyosLeft(puyoGrid: inout PuyoGrid, currentPuyos: inout [Puyo]) {
    _ = movePuyos(byX: -1, byY: 0, puyoGrid: &puyoGrid, currentPuyos: &currentPuyos)
}

func movePuyosRight(puyoGrid: inout PuyoGrid, currentPuyos: inout [Puyo]) {
    _ = movePuyos(byX: 1, byY: 0, puyoGrid: &puyoGrid, currentPuyos: &currentPuyos)
}

func movePuyos(byX deltaX: Int, byY deltaY: Int, puyoGrid: inout PuyoGrid, currentPuyos: inout [Puyo]) -> Bool {
    var canMove = true
    // 全てのぷよについて移動後の位置がすべてグリッドの範囲内で空いているか確認
    for (_, puyo) in currentPuyos.enumerated() {
        let newX = puyo.position.x + deltaX
        let newY = puyo.position.y + deltaY
        // 移動できない条件がある場合
        if newX < 0 || newX >= puyoGrid.width || newY < 0 || newY >= puyoGrid.height {
            canMove = false
            break
        }
        // 他のぷよに衝突しないか確認（同じ組ぷよは無視）
        if let otherPuyo = puyoGrid.grid[newY][newX] {
            if !currentPuyos.contains(where: { $0.id == otherPuyo.id }) {
                canMove = false
                break
            }
        }
    }
    // 移動可能ならすべてのぷよを移動させる
    if canMove {
        // まずはすべてのぷよをグリッドから削除
        for puyo in currentPuyos {
            puyoGrid.removePuyo(at: (puyo.position.x, puyo.position.y))
        }
        // 新しい位置にすべてのぷよを移動
        for i in 0..<currentPuyos.count {
            currentPuyos[i].position.x += deltaX
            currentPuyos[i].position.y += deltaY
        }
        // 新しい位置にすべてのぷよを追加
        for puyo in currentPuyos {
            puyoGrid.addPuyo(puyo)
        }
    }

    return canMove
}
