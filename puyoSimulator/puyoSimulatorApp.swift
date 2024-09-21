//
//  puyoSimulatorApp.swift
//  puyoSimulator
//
//  Created by Katsuki Go on 2024/09/09.
//

//import SwiftUI
//
//@main
//struct puyoSimulatorApp: App {
//    var body: some Scene {
//        WindowGroup {
//            // SwiftUIのビューを表示する場合
//            ContentView()
//            
//            // UIKitのビューコントローラを表示する場合
////             ViewControllerWrapper()
//        }
//    }
//}
//
//// UIKitのViewControllerをSwiftUIで使用するためのラッパー
//struct ViewControllerWrapper: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> UIViewController {
//        return ViewController() // 自作のViewControllerクラス
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        // 更新処理があればここに記述
//    }
//}


import SwiftUI

@main
struct PuyoSimulatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()  // メインの画面を表示
        }
    }
}

