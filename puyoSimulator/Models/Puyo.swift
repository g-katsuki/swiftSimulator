
import SwiftUI

// 128手のループ
var handLoop: [PuyoColor] = create128HandLoop()
var currentHandIndex = 0


// PuyoColor を Codable に準拠させる
enum PuyoColor: String, Codable {
    case red, green, blue, yellow
}

func create128HandLoop() -> [PuyoColor] {
    let colors: [PuyoColor] = [.red, .green, .blue, .yellow]
    var hands: [PuyoColor] = []

    // 各色を32個ずつ追加
    for _ in 0..<32 {
        hands.append(contentsOf: colors)
    }

    // 配列をシャッフル
    hands.shuffle()
    return hands
}


// ランダムな色を生成する関数
func randomPuyoColor() -> PuyoColor {
    let color = handLoop[currentHandIndex]
        currentHandIndex = (currentHandIndex + 1) % handLoop.count  // インデックスを進めてループ
        return color
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
    
    // PuyoColor を文字列に変換
    var description: String {
        switch self {
        case .red:
            return "Red"
        case .green:
            return "Green"
        case .blue:
            return "Blue"
        case .yellow:
            return "Yellow"
        }
    }
}
