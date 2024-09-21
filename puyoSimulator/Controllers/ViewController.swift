//import UIKit
//
//class ViewController: UIViewController {
//
//    // ゲームの状態を管理するプロパティ
//    var grid: [[String?]] = Array(repeating: Array(repeating: nil, count: 6), count: 12)
//    var currentPuyos = (puyo1: Puyo(color: "red", x: 0, y: 0), puyo2: Puyo(color: "blue", x: 1, y: 0))
//    var nextPuyos = [Puyo(color: "green", x: 0, y: 0), Puyo(color: "yellow", x: 1, y: 0)]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//    }
//
//    // UIの設定
//    func setupUI() {
//        view.backgroundColor = UIColor.white
//
//        // ヘッダー
//        let header = UILabel()
//        header.text = "ぷよ通・中辛"
//        header.textColor = UIColor.white
//        header.backgroundColor = UIColor(red: 180/255, green: 4/255, blue: 4/255, alpha: 1.0)
//        header.textAlignment = .center
//        header.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(header)
//
//        // グリッド
//        let gridContainer = UIView()
//        gridContainer.translatesAutoresizingMaskIntoConstraints = false
//        gridContainer.backgroundColor = UIColor.darkGray
//        view.addSubview(gridContainer)
//
//        // グリッドのセル
//        for (rowIndex, row) in grid.enumerated() {
//            for (cellIndex, cell) in row.enumerated() {
//                let cellView = UIView()
//                cellView.translatesAutoresizingMaskIntoConstraints = false
//                cellView.backgroundColor = UIColor.gray
//                cellView.layer.borderWidth = 1
//                cellView.layer.borderColor = UIColor.black.cgColor
//                gridContainer.addSubview(cellView)
//
//                // Puyoがある場合は表示
//                if let cellColor = cell {
//                    let puyoView = createPuyoView(color: cellColor)
//                    cellView.addSubview(puyoView)
//                    puyoView.frame = CGRect(x: 2, y: 2, width: 34, height: 34) // セル内のPuyoの位置とサイズ
//                }
//                
//                // セルのレイアウト制約
//                cellView.frame = CGRect(x: cellIndex * 38, y: rowIndex * 38, width: 38, height: 38)
//            }
//        }
//
//        // その他のUI（次のPuyoやコントロールボタンなど）も追加
//        setupControls()
//
//        // 制約の設定
//        NSLayoutConstraint.activate([
//            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            header.heightAnchor.constraint(equalToConstant: 60),
//
//            gridContainer.topAnchor.constraint(equalTo: header.bottomAnchor),
//            gridContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            gridContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            gridContainer.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),
//            gridContainer.widthAnchor.constraint(equalToConstant: 228),
//            gridContainer.heightAnchor.constraint(equalToConstant: 456)
//        ])
//    }
//
//    func createPuyoView(color: String) -> UIView {
//        let puyoView = UIView()
//        puyoView.backgroundColor = getColorForPuyo(color: color)
//        puyoView.layer.cornerRadius = 17
//        puyoView.translatesAutoresizingMaskIntoConstraints = false
//        return puyoView
//    }
//
//    func getColorForPuyo(color: String) -> UIColor {
//        switch color {
//        case "red":
//            return UIColor.red
//        case "blue":
//            return UIColor.blue
//        case "green":
//            return UIColor.green
//        case "yellow":
//            return UIColor.yellow
//        default:
//            return UIColor.clear
//        }
//    }
//
//    // コントロールボタンの設定
//    func setupControls() {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.distribution = .equalSpacing
//        stackView.alignment = .fill
//        stackView.spacing = 10
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(stackView)
//
//        let leftButton = UIButton(type: .system)
//        leftButton.setTitle("←", for: .normal)
//        leftButton.addTarget(self, action: #selector(moveLeft), for: .touchUpInside)
//
//        let rightButton = UIButton(type: .system)
//        rightButton.setTitle("→", for: .normal)
//        rightButton.addTarget(self, action: #selector(moveRight), for: .touchUpInside)
//
//        let downButton = UIButton(type: .system)
//        downButton.setTitle("↓", for: .normal)
//        downButton.addTarget(self, action: #selector(dropPuyos), for: .touchUpInside)
//
//        let rotateLeftButton = UIButton(type: .system)
//        rotateLeftButton.setTitle("L", for: .normal)
//        rotateLeftButton.addTarget(self, action: #selector(rotatePuyosLeft), for: .touchUpInside)
//
//        let rotateRightButton = UIButton(type: .system)
//        rotateRightButton.setTitle("R", for: .normal)
//        rotateRightButton.addTarget(self, action: #selector(rotatePuyosRight), for: .touchUpInside)
//
//        // ボタンをスタックビューに追加
//        stackView.addArrangedSubview(leftButton)
//        stackView.addArrangedSubview(downButton)
//        stackView.addArrangedSubview(rightButton)
//        stackView.addArrangedSubview(rotateLeftButton)
//        stackView.addArrangedSubview(rotateRightButton)
//
//        NSLayoutConstraint.activate([
//            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
//    }
//
//    @objc func moveLeft() {
//        // 左移動ロジック
//    }
//
//    @objc func moveRight() {
//        // 右移動ロジック
//    }
//
//    @objc func dropPuyos() {
//        // 下移動ロジック
//    }
//
//    @objc func rotatePuyosLeft() {
//        // 左回転ロジック
//    }
//
//    @objc func rotatePuyosRight() {
//        // 右回転ロジック
//    }
//}
//
//// Puyo構造体
//struct Puyo {
//    var color: String
//    var x: Int
//    var y: Int
//}
//
