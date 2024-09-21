//
//  PuyoView.swift
//  puyoSimulator
//
//  Created by Katsuki Go on 2024/09/18.
//

import SwiftUI

struct PuyoView: View {
    var puyo: Puyo

    var body: some View {
        let color: Color
        switch puyo.color {
        case .red:
            color = .red
        case .green:
            color = .green
        case .blue:
            color = .blue
        case .yellow:
            color = .yellow
        }
        
        return Circle()
            .fill(color)
            .frame(width: 30, height: 30)
    }
}
