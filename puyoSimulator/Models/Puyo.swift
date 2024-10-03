//
//  Puyo.swift
//  puyoSimulator
//
//  Created by Katsuki Go on 2024/09/20.
//

import SwiftUI

enum PuyoColor {
    case red, green, blue, yellow
}

// ランダムな色を生成する関数
func randomPuyoColor() -> PuyoColor {
    let colors: [PuyoColor] = [.red, .green, .blue, .yellow]
    return colors.randomElement() ?? .red
}

struct Puyo: Identifiable {
    var id = UUID()  // 一意のIDを持つ
    var color: PuyoColor
    var position: (Int, Int)
}

extension PuyoColor {
    // PuyoColor を SwiftUI の Color に変換
    var swiftUIColor: Color {
        switch self {
        case .red:
            return Color.red
        case .blue:
            return Color.blue
        case .green:
            return Color.green
        case .yellow:
            return Color.yellow
        }
    }
}
