////
////  PuyoViewModel.swift
////  puyoSimulator
////
////  Created by Katsuki Go on 2024/11/30.
////
//
//import SwiftUI
//
//class PuyoViewModel: ObservableObject {
//    @Published var puyoGrid = PuyoGrid(width: 6, height: 13)
//    @Published var currentPuyos: [Puyo] = []
//    @Published var nextPuyos: [Puyo] = []
//    @Published var nextdPuyos: [Puyo] = []
//    @Published var nextPuyoHistory: [[Puyo]] = []
//    @Published var savedHistoryNames: [String] = []
//    @Published var createdPuyoSequence: [PuyoColor] = []
//    @Published var historyName: String = ""
//    @Published var isShowingSaveAlert = false
//
//    private var currentHistoryIndex: Int = -1
//    private var puyoGridHistory: [PuyoGridState] = []
//
//    // 初期化
//    func setupNewPuyos() {
//        let firstPuyo = Puyo(color: .red, position: Position(x: 2, y: 0))
//        let secondPuyo = Puyo(color: .blue, position: Position(x: 2, y: 1))
//        currentPuyos = [firstPuyo, secondPuyo]
//        nextPuyos = [firstPuyo, secondPuyo]
//        nextdPuyos = [firstPuyo, secondPuyo]
//    }
//
//    func savePuyoGridState() {
//        let currentGrid = puyoGrid.grid.map { row in row.map { $0 } }
//        let currentState = PuyoGridState(grid: currentGrid, currentPuyos: currentPuyos)
//        if currentHistoryIndex < puyoGridHistory.count - 1 {
//            puyoGridHistory = Array(puyoGridHistory.prefix(currentHistoryIndex + 1))
//        }
//        puyoGridHistory.append(currentState)
//        currentHistoryIndex += 1
//    }
//
//    func restorePuyoGridState() {
//        guard currentHistoryIndex > 0 else { return }
//        currentHistoryIndex -= 1
//        let previousState = puyoGridHistory[currentHistoryIndex]
//        puyoGrid.grid = previousState.grid
//        currentPuyos = previousState.currentPuyos
//    }
//
//    func resetGame() {
//        puyoGrid = PuyoGrid(width: 6, height: 13)
//        currentPuyos.removeAll()
//        nextPuyos.removeAll()
//        nextdPuyos.removeAll()
//        puyoGridHistory.removeAll()
//        nextPuyoHistory.removeAll()
//        currentHistoryIndex = -1
//        setupNewPuyos()
//    }
//
//    func saveCreatedHistory() {
//        var createdHistory: [[Puyo]] = []
//        for i in stride(from: 0, to: createdPuyoSequence.count, by: 2) {
//            let firstPuyoColor = createdPuyoSequence[i]
//            let secondPuyoColor = (i + 1 < createdPuyoSequence.count) ? createdPuyoSequence[i + 1] : createdPuyoSequence[i]
//            let firstPuyo = Puyo(color: firstPuyoColor, position: Position(x: 2, y: 0))
//            let secondPuyo = Puyo(color: secondPuyoColor, position: Position(x: 2, y: 1))
//            createdHistory.append([firstPuyo, secondPuyo])
//        }
//        nextPuyoHistory = createdHistory
//        createdPuyoSequence.removeAll()
//        historyName = ""
//    }
//    
//    func addColorToSequence(_ color: PuyoColor) {
//        createdPuyoSequence.append(color)
//    }
//}
