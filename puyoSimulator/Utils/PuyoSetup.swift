//
//  PuyoSetup.swift
//  puyoSimulator
//
//  Created by Katsuki Go on 2024/12/30.
//

import Foundation

func setupNewPuyos(
    puyoGrid: inout PuyoGrid,
    currentPuyos: inout [Puyo],
    nextPuyos: inout [Puyo],
    nextdPuyos: inout [Puyo],
    nextPuyoHistory: inout [[Puyo]]
) {
    // 新しいぷよを生成
    let firstPuyo = Puyo(color: randomPuyoColor(), position: Position(x: 2, y: 1))
    let secondPuyo = Puyo(color: randomPuyoColor(), position: Position(x: 2, y: 2))
    currentPuyos = [firstPuyo, secondPuyo]

    let nextFirstPuyo = Puyo(color: randomPuyoColor(), position: Position(x: 2, y: 1))
    let nextSecondPuyo = Puyo(color: randomPuyoColor(), position: Position(x: 2, y: 2))
    nextPuyos = [nextFirstPuyo, nextSecondPuyo]

    let nextdFirstPuyo = Puyo(color: randomPuyoColor(), position: Position(x: 2, y: 1))
    let nextdSecondPuyo = Puyo(color: randomPuyoColor(), position: Position(x: 2, y: 2))
    nextdPuyos = [nextdFirstPuyo, nextdSecondPuyo]

    // グリッドに現在のぷよを追加
    puyoGrid.addPuyo(currentPuyos[0])
    puyoGrid.addPuyo(currentPuyos[1])

    // グリッドとぷよの状態を履歴に保存
    nextPuyoHistory.append(currentPuyos)
    nextPuyoHistory.append(nextPuyos)
    nextPuyoHistory.append(nextdPuyos)
}
