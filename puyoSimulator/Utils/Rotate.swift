//
//  Rotate.swift
//  puyoSimulator
//
//  Created by Katsuki Go on 2024/11/30.
//

import Foundation

func rotatePuyosRight(currentPuyos: inout [Puyo], puyoGrid: inout PuyoGrid) {
    let axisPuyo = currentPuyos[1]  // 軸ぷよ
    let childPuyo = currentPuyos[0]  // 子ぷよ
    
    if childPuyo.position.x == 0 && childPuyo.position.x < axisPuyo.position.x {
        return
    }

    // 子ぷよの相対的な位置を計算し、右回転（時計回り）
    let relativeX = childPuyo.position.x - axisPuyo.position.x
    let relativeY = childPuyo.position.y - axisPuyo.position.y
    var newChildPuyoPosition: (Int, Int) = (axisPuyo.position.x - relativeY, axisPuyo.position.y + relativeX)
    var newParentPuyoPosition: (Int, Int) = (axisPuyo.position.x, axisPuyo.position.x)

    if axisPuyo.position.x - relativeY >= puyoGrid.width {
        newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
        newParentPuyoPosition = (axisPuyo.position.x - 1, axisPuyo.position.y + relativeX)
    }
    else if axisPuyo.position.x - relativeY == -1 {
        newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
        newParentPuyoPosition = (axisPuyo.position.x + 1, axisPuyo.position.y + relativeX)
    } else { // 壁とは離れている
        if puyoGrid.grid[newChildPuyoPosition.1][newChildPuyoPosition.0] != nil { // ぷよに衝突
            if relativeY < 0 { // 子ぷよが上
                newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                newParentPuyoPosition = (axisPuyo.position.x - 1, axisPuyo.position.y + relativeX)
                if puyoGrid.grid[newParentPuyoPosition.1][newParentPuyoPosition.0] != nil { // rotete 180
                    newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX + 1)
                    newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                    if puyoGrid.grid[newChildPuyoPosition.1][newChildPuyoPosition.0] != nil { // 180の先にぷよが存在
                        newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                        newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX - 1)
                    }
                }
            } else if relativeY > 0 { // 子ぷよが下
                newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                newParentPuyoPosition = (axisPuyo.position.x + 1, axisPuyo.position.y + relativeX)
                if puyoGrid.grid[newParentPuyoPosition.1][newParentPuyoPosition.0] != nil { // rotete 180
                    newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX - 1)
                    newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                }
            } else {
                newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX - 1)
                newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX - 2)
            }
        } else {
            newChildPuyoPosition = (axisPuyo.position.x - relativeY, axisPuyo.position.y + relativeX)
            newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y)
        }
    }
    
    // 移動先が範囲外なら何もせず終了
    if newChildPuyoPosition.1 < 0 || newParentPuyoPosition.1 < 0 {
        return
    }
    
    // グリッドから古い位置のぷよを削除
    puyoGrid.removePuyo(at: (childPuyo.position.x, childPuyo.position.y))
    puyoGrid.removePuyo(at: (axisPuyo.position.x, axisPuyo.position.y))

    // 新しい位置にぷよを移動
    currentPuyos[0].position = Position(x: newChildPuyoPosition.0, y: newChildPuyoPosition.1)
    currentPuyos[1].position = Position(x: newParentPuyoPosition.0, y: newParentPuyoPosition.1)
    
    // グリッドに新しい位置のぷよを追加
    puyoGrid.addPuyo(currentPuyos[0])
    puyoGrid.addPuyo(currentPuyos[1])
}


func rotatePuyosLeft(currentPuyos: inout [Puyo], puyoGrid: inout PuyoGrid) {
    let axisPuyo = currentPuyos[1]  // 軸ぷよ
    let childPuyo = currentPuyos[0]  // 子ぷよ
    
    if childPuyo.position.y == 0 && childPuyo.position.x > axisPuyo.position.x {
        return
    }

    // 子ぷよの相対的な位置を計算し、左回転
    let relativeX = childPuyo.position.x - axisPuyo.position.x
    let relativeY = childPuyo.position.y - axisPuyo.position.y
    var newChildPuyoPosition: (Int, Int) = (axisPuyo.position.x + relativeY, axisPuyo.position.y - relativeX)
    var newParentPuyoPosition: (Int, Int) = (axisPuyo.position.x, axisPuyo.position.x)

    if axisPuyo.position.x + relativeY >= puyoGrid.width {
        newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
        newParentPuyoPosition = (axisPuyo.position.x - 1, axisPuyo.position.y + relativeX)
    }
    else if axisPuyo.position.x + relativeY == -1 {
        newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y - relativeX)
        newParentPuyoPosition = (axisPuyo.position.x + 1, axisPuyo.position.y + relativeX)
    } else { // 壁とは離れている
        if puyoGrid.grid[newChildPuyoPosition.1][newChildPuyoPosition.0] != nil { // ぷよに衝突
            if relativeY < 0 { // 子ぷよが上
                newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y - relativeX)
                newParentPuyoPosition = (axisPuyo.position.x + 1, axisPuyo.position.y + relativeX)
                if puyoGrid.grid[newParentPuyoPosition.1][newParentPuyoPosition.0] != nil { // rotete 180
                    newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX + 1)
                    newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                    if puyoGrid.grid[newChildPuyoPosition.1][newChildPuyoPosition.0] != nil { // 180の先にぷよが存在
                        newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                        newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX - 1)
                    }
                }
            } else if relativeY > 0 { // 子ぷよが下
                newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                newParentPuyoPosition = (axisPuyo.position.x - 1, axisPuyo.position.y + relativeX)
                if puyoGrid.grid[newParentPuyoPosition.1][newParentPuyoPosition.0] != nil { // rotete 180
                    newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX - 1)
                    newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                }
            } else {
                newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX + 1)
                newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
            }
        } else {
            newChildPuyoPosition = (axisPuyo.position.x + relativeY, axisPuyo.position.y - relativeX)
            newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y)
        }
    }
    
    // 移動先が範囲外なら何もせず終了
    if newChildPuyoPosition.1 < 0 || newParentPuyoPosition.1 < 0 {
        return
    }
    
    // グリッドから古い位置のぷよを削除
    puyoGrid.removePuyo(at: (childPuyo.position.x, childPuyo.position.y))
    puyoGrid.removePuyo(at: (axisPuyo.position.x, axisPuyo.position.y))

    // 新しい位置にぷよを移動
    currentPuyos[0].position = Position(x: newChildPuyoPosition.0, y: newChildPuyoPosition.1)
    currentPuyos[1].position = Position(x: newParentPuyoPosition.0, y: newParentPuyoPosition.1)

    // グリッドに新しい位置のぷよを追加
    puyoGrid.addPuyo(currentPuyos[0])
    puyoGrid.addPuyo(currentPuyos[1])
}
