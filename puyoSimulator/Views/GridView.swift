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
        VStack(spacing: 2) {
            ForEach(0..<puyoGrid.height, id: \.self) { y in
                HStack(spacing: 2) {
                    ForEach(0..<puyoGrid.width, id: \.self) { x in
                        if let puyo = puyoGrid.grid[y][x] {
                            PuyoView(puyo: puyo)
                        } else {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 40, height: 40)
                        }
                    }
                }
            }
        }
    }
}

