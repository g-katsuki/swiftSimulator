//
//  GridView.swift
//  puyoSimulator
//
//  Created by Katsuki Go on 2024/09/20.
//

import SwiftUI

//struct GridView: View {
//    @Binding var puyoGrid: PuyoGrid
//
//    var body: some View {
//        VStack(spacing: 0) {  // マス目の間に少し隙間を作る
//            ForEach(0..<puyoGrid.height, id: \.self) { row in
//                HStack(spacing: 0) {  // 横のマスにも隙間を作る
//                    ForEach(0..<puyoGrid.width, id: \.self) { column in
//                        ZStack {
//                            // 13段目は特別な色、その他は通常の色
//                            if row == 0 {  // 13段目（プログラム上は12行目）
//                                Rectangle()
//                                    .fill(Color(white: 0.2))  // 13段目は少し暗めのグレー
//                                    .frame(width: 40, height: 40)  // グリッドの各マスの大きさ
//                            } else {
//                                // グリッドの背景を常に描画（背景がゲーム画面にならないようにする）
//                                Rectangle()
//                                    .fill(Color(white: 0.3))  // グリッドの背景色を設定
//                                    .frame(width: 40, height: 40)  // グリッドの各マスの大きさ
//                            }
//
//                            // ぷよが存在する場合、そのぷよを描画
//                            if let puyo = puyoGrid.grid[row][column] {
//                                PuyoView(puyo: puyo)
//                                    .frame(width: 40, height: 40)  // ぷよの大きさ
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//}


//struct GridView: View {
//    @Binding var puyoGrid: PuyoGrid
//
//    var body: some View {
//        VStack(spacing: 2) {  // マス目の間に少し隙間を作る
//            ForEach(0..<puyoGrid.height, id: \.self) { row in
//                HStack(spacing: 2) {  // 横のマスにも隙間を作る
//                    ForEach(0..<puyoGrid.width, id: \.self) { column in
//                        ZStack {
//                            // グリッドの背景
//                            Rectangle()
//                                .fill(row == 12 ? Color(white: 0.3) : Color(white: 0.5))  // 13段目は暗め
//                                .frame(width: 30, height: 30)
//
//                            // ぷよが存在する場合、そのぷよを描画
//                            if let puyo = puyoGrid.grid[row][column] {
//                                // findConnectedPuyosを使って連結状態を取得
//                                let connectedPuyos = findConnectedPuyos(from: Position(x: column, y: row))
//                                
//                                // 連結している場合、連結部分に長方形を描画
//                                if isConnected(at: (row, column), to: (row, column - 1), in: connectedPuyos) {
//                                    Rectangle()
//                                        .fill(puyo.color)  // 同じ色で描画
//                                        .frame(width: 20, height: 30)  // 左右の連結を表現
//                                        .offset(x: -25)  // 左にずらす
//                                }
//
//                                if isConnected(at: (row, column), to: (row, column + 1), in: connectedPuyos) {
//                                    Rectangle()
//                                        .fill(puyo.color)
//                                        .frame(width: 20, height: 30)
//                                        .offset(x: 25)  // 右にずらす
//                                }
//
//                                if isConnected(at: (row, column), to: (row - 1, column), in: connectedPuyos) {
//                                    Rectangle()
//                                        .fill(puyo.color)
//                                        .frame(width: 30, height: 20)  // 上下の連結を表現
//                                        .offset(y: -25)  // 上にずらす
//                                }
//
//                                if isConnected(at: (row, column), to: (row + 1, column), in: connectedPuyos) {
//                                    Rectangle()
//                                        .fill(puyo.color)
//                                        .frame(width: 30, height: 20)
//                                        .offset(y: 25)  // 下にずらす
//                                }
//
//                                // ぷよ自体の描画
//                                PuyoView(puyo: puyo)
//                                    .frame(width: 30, height: 30)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    // ぷよが特定の隣の位置と連結しているかどうかを判定する関数
//    func isConnected(at currentPosition: (Int, Int), to neighborPosition: (Int, Int), in connectedPuyos: [Position]) -> Bool {
//        let (currentRow, currentColumn) = currentPosition
//        let (neighborRow, neighborColumn) = neighborPosition
//        
//        // 隣接している場所がグリッドの範囲内であり、連結している場合に true を返す
//        if neighborRow >= 0 && neighborRow < puyoGrid.height &&
//           neighborColumn >= 0 && neighborColumn < puyoGrid.width {
//            return connectedPuyos.contains(Position(x: neighborColumn, y: neighborRow))
//        }
//        return false
//    }
//    
//    func findConnectedPuyos(from start: Position) -> [Position] {
//        guard let startPuyo = puyoGrid.grid[start.y][start.x] else { return [] }
//        
//        var stack = [start]
//        var visited = Set<Position>()
//        visited.insert(start)
//        var connectedPuyos = [Position]()
//
//        while !stack.isEmpty {
//            let current = stack.removeLast()
//            connectedPuyos.append(current)
//
//            let neighbors = [
//                Position(x: current.x - 1, y: current.y),  // 左
//                Position(x: current.x + 1, y: current.y),  // 右
//                Position(x: current.x, y: current.y - 1),  // 上
//                Position(x: current.x, y: current.y + 1)   // 下
//            ]
//            
//            for neighbor in neighbors {
//                if neighbor.y > 0 && neighbor.x >= 0 && neighbor.x < puyoGrid.width && neighbor.y < puyoGrid.height {
//                    if let neighborPuyo = puyoGrid.grid[neighbor.y][neighbor.x],
//                       neighborPuyo.color == startPuyo.color,
//                       !visited.contains(neighbor) {
//                        stack.append(neighbor)
//                        visited.insert(neighbor)
//                    }
//                }
//            }
//        }
//
//        return connectedPuyos
//    }
//
//}
//
