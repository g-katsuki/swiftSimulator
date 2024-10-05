//
//  Puyo.swift
//  puyoSimulator
//
//  Created by Katsuki Go on 2024/09/20.
//

//import SwiftUI
//
//enum PuyoColor {
//    case red, green, blue, yellow
//}
//
//// ランダムな色を生成する関数
//func randomPuyoColor() -> PuyoColor {
//    let colors: [PuyoColor] = [.red, .green, .blue, .yellow]
//    return colors.randomElement() ?? .red
//}
//
//struct Puyo: Identifiable {
//    var id = UUID()  // 一意のIDを持つ
//    var color: PuyoColor
//    var position: (Int, Int)
//}
//
//extension PuyoColor {
//    // PuyoColor を SwiftUI の Color に変換
//    var swiftUIColor: Color {
//        switch self {
//        case .red:
//            return Color.red
//        case .blue:
//            return Color.blue
//        case .green:
//            return Color.green
//        case .yellow:
//            return Color.yellow
//        }
//    }
//}


import SwiftUI

// PuyoColor を Codable に準拠させる
enum PuyoColor: String, Codable {
    case red, green, blue, yellow
}

// ランダムな色を生成する関数
func randomPuyoColor() -> PuyoColor {
    let colors: [PuyoColor] = [.red, .green, .blue, .yellow]
    return colors.randomElement() ?? .red
}

// 位置を表す構造体
struct Position: Codable, Hashable {
    var x: Int
    var y: Int
}


// Puyo 構造体を Codable に準拠させる
struct Puyo: Identifiable, Codable {
    var id = UUID()  // 一意のIDを持つ
    var color: PuyoColor
    var position: Position  // タプルの代わりに Position 構造体を使用
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
