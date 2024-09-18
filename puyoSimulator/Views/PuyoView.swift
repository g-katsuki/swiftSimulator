//
//  PuyoView.swift
//  puyoSimulator
//
//  Created by Katsuki Go on 2024/09/18.
//

import UIKit

class PuyoView: UIView {
    
    init(color: String) {
        super.init(frame: .zero)
        setupPuyo(color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPuyo(color: String) {
        // Puyoの背景色を設定
        self.backgroundColor = getColorForPuyo(color: color)
        self.layer.cornerRadius = 17 // Puyoの形を円にする
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // Puyoの色に対応する背景色を取得
    private func getColorForPuyo(color: String) -> UIColor {
        switch color {
        case "red":
            return UIColor.red
        case "blue":
            return UIColor.blue
        case "green":
            return UIColor.green
        case "yellow":
            return UIColor.yellow
        default:
            return UIColor.clear
        }
    }
}
