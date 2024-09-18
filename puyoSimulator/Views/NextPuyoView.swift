//
//  NextPuyoView.swift
//  puyoSimulator
//
//  Created by Katsuki Go on 2024/09/18.
//

import UIKit

class NextPuyoView: UIView {
    
    var puyos: [Puyo]
    
    init(puyos: [Puyo]) {
        self.puyos = puyos
        super.init(frame: .zero)
        setupNextPuyos()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNextPuyos() {
        for (index, puyo) in puyos.enumerated() {
            let puyoView = PuyoView(color: puyo.color)
            addSubview(puyoView)
            
            // レイアウトの設定
            puyoView.frame = CGRect(x: 0, y: CGFloat(index * 40), width: 34, height: 34)
        }
    }
}
