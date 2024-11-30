//
//  ControlButtonsView.swift
//  puyoSimulator
//
//  Created by Katsuki Go on 2024/11/30.
//

import SwiftUI

struct ControlButtonsView: View {
    @ObservedObject var viewModel: PuyoViewModel
    let geometry: GeometryProxy

    var body: some View {
        HStack {
            Button("←") { viewModel.movePuyosLeft() }
                .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                .background(Color.gray)
                .cornerRadius(10)
            // 他のボタンも同様に追加
        }
    }
}

