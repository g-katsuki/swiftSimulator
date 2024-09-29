//
//  GridView.swift
//  puyoSimulator
//
//  Created by Katsuki Go on 2024/09/20.
//

import SwiftUI

struct GridView: View {
    @Binding var puyoGrid: PuyoGrid

    var body: some View {
        VStack(spacing: 0) {  // マス目の間に少し隙間を作る
            ForEach(0..<puyoGrid.height, id: \.self) { row in
                HStack(spacing: 0) {  // 横のマスにも隙間を作る
                    ForEach(0..<puyoGrid.width, id: \.self) { column in
                        ZStack {
                            // グリッドの背景を常に描画（背景がゲーム画面にならないようにする）
                            Rectangle()
                                .fill(Color(white: 0.3))  // グリッドの背景色を設定
                                .frame(width: 40, height: 40)  // グリッドの各マスの大きさ

                            // ぷよが存在する場合、そのぷよを描画
                            if let puyo = puyoGrid.grid[row][column] {
                                PuyoView(puyo: puyo)
                                    .frame(width: 40, height: 40)  // ぷよの大きさ
                            }
                        }
                    }
                }
            }
        }
    }
}


