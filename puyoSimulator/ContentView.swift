import SwiftUI

struct ContentView: View {
    @State private var puyoGrid = PuyoGrid(width: 6, height: 13)
    @State private var currentPuyos: [Puyo] = []  // 現在操作中のぷよ
    @State private var nextPuyos: [Puyo] = []     // ネクストぷよ
    @State private var nextdPuyos: [Puyo] = []     // ダブルネクストぷよ
    @State private var nextPuyoHistory: [[Puyo]] = []  // nextPuyos用の履歴
    @State private var savedNextPuyoHistories: [[Puyo]] = []  // 2次元配列として保存


    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(white: 0.2).edgesIgnoringSafeArea(.all)
                // グリッドを表示
                VStack {
                    GridView(puyoGrid: $puyoGrid)
                        .padding(.trailing, geometry.size.width * 0.2)

                    // 操作ボタンの配置
                    HStack {
                        Button(action: {
                            movePuyosLeft()
                        }) {
                            Text("←")
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                                .background(Color.gray)
                                .cornerRadius(10)
                                .padding(geometry.size.width * 0.01)
                        }

                        Button(action: {
                            dropPuyosWithGravityAndRemoveAsync()
                        }) {
                            Text("↓")
                                .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
                                .background(Color.gray)
                                .cornerRadius(10)
                                .padding(geometry.size.width * 0.02)
                        }

                        Button(action: {
                            movePuyosRight()
                        }) {
                            Text("→")
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                                .background(Color.gray)
                                .cornerRadius(10)
                                .padding(geometry.size.width * 0.01)
                        }

                        Button(action: {
                            rotatePuyosLeft()
                        }) {
                            Text("L")
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                                .background(Color.gray)
                                .cornerRadius(10)
                                .padding(geometry.size.width * 0.015)
                        }

                        Button(action: {
                            rotatePuyosRight()
                        }) {
                            Text("R")
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                                .background(Color.gray)
                                .cornerRadius(10)
                                .padding(geometry.size.width * 0.015)
                        }
                    }
                    .padding()

                    // 下部に「戻る」ボタンと「リセット」ボタンを配置
                    HStack {
                        Button(action: {
                            restorePuyoGridState()
                        }) {
                            Text("back").padding().background(Color.gray).cornerRadius(10)
                        }
                        
                        // ボタンの間にスペースを追加
//                        Spacer()
//                            .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0)
                        
                        Button(action: {
                            // ネクストぷよの履歴を保存してUserDefaultsに書き込む
                            savedNextPuyoHistories.append(nextPuyos)
                            saveNextPuyoHistoryToUserDefaults()
                        }) {
                            Text("save")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                        }

                        
                        Button(action: {
                            loadNextPuyoHistoryFromUserDefaults()  // ネクストぷよの履歴を読み込む
                        }) {
                            Text("履歴を呼び出す")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                        }




                        Button(action: {
                            resetGame()
                        }) {
                            Text("reset").padding().background(Color.red).foregroundColor(.white).cornerRadius(10)
                        }
                    }
                    .padding(.top, 20)
                }
                
                // ネクストぷよを画面右上に縦に配置
                VStack {
                    VStack {
                        Text("Next")
                        ForEach(nextPuyos) { puyo in
                            PuyoView(puyo: puyo)
                        }
                        Text("---")
                        ForEach(nextdPuyos) { puyo in
                            PuyoView(puyo: puyo)
                        }
                    }
                    .frame(width: geometry.size.width * 0.15)  // ネクストぷよの幅を画面幅の15%に設定
                    .padding()
                    .background(Color(white: 0.3))
                    .cornerRadius(10)
                    .shadow(radius: 10)

                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topTrailing)  // 右上に配置
            }
            .onAppear {
                setupNewPuyos()  // 最初のぷよとネクストぷよを表示
                loadNextPuyoHistoryFromUserDefaults()  // 履歴をロード
            }
        }
    }

    // 新しいぷよのセットアップ
    func setupNewPuyos() {

        // 新しいぷよを生成
        let firstPuyo = Puyo(color: randomPuyoColor(), position: Position(x: 2, y:  0))
        let secondPuyo = Puyo(color: randomPuyoColor(), position: Position(x: 2, y:  1))
        currentPuyos = [firstPuyo, secondPuyo]

        let nextFirstPuyo = Puyo(color: randomPuyoColor(), position: Position(x: 2, y:  0))
        let nextSecondPuyo = Puyo(color: randomPuyoColor(), position: Position(x: 2, y:  1))
        nextPuyos = [nextFirstPuyo, nextSecondPuyo]
        
        let nextdFirstPuyo = Puyo(color: randomPuyoColor(), position: Position(x: 2, y:  0))
        let nextdSecondPuyo = Puyo(color: randomPuyoColor(), position: Position(x: 2, y:  1))
        nextdPuyos = [nextdFirstPuyo, nextdSecondPuyo]

        // グリッドに現在のぷよを追加
        puyoGrid.addPuyo(currentPuyos[0])
        puyoGrid.addPuyo(currentPuyos[1])

        // グリッドとぷよの状態を履歴に保存
        savePuyoGridState()
        nextPuyoHistory.append(currentPuyos)
        nextPuyoHistory.append(nextPuyos)
        nextPuyoHistory.append(nextdPuyos)
    }

    // ぷよを設置し、次のぷよを現在のぷよにする
    func placePuyos() {
        
        currentPuyos = nextPuyos  // ネクストぷよをcurrentPuyosに移動
        nextPuyos = nextdPuyos
        
        // ネクストぷよを履歴から復元するか、新しく生成
        if currentHistoryIndex < nextPuyoHistory.count - 1{
            // 履歴からネクストぷよを取得（次の履歴に進む）
            nextdPuyos = nextPuyoHistory[currentHistoryIndex+1]
        } else {
            // 履歴がない場合、新しくネクストぷよを生成
            let firstPuyo = Puyo(color: randomPuyoColor(), position: Position(x: 2, y:  0))
            let secondPuyo = Puyo(color: randomPuyoColor(), position: Position(x: 2, y:  1))
            nextdPuyos = [firstPuyo, secondPuyo]
            
            nextPuyoHistory.append(nextdPuyos)
        }

        // 現在のぷよをグリッドに追加
        for puyo in currentPuyos {
            puyoGrid.addPuyo(puyo)
        }

    }

    // ぷよを左に移動
    func movePuyosLeft() {
        _ = movePuyos(byX: -1, byY: 0)  // 戻り値を無視する
    }

    // ぷよを右に移動
    func movePuyosRight() {
        _ = movePuyos(byX: 1, byY: 0)  // 戻り値を無視する
    }

    // 戻り値として「移動できるかどうか」を返すようにする
    func movePuyos(byX deltaX: Int, byY deltaY: Int) -> Bool {
        var canMove = true

        // 全てのぷよについて移動後の位置がすべてグリッドの範囲内で空いているか確認
        for (_, puyo) in currentPuyos.enumerated() {
            let newX = puyo.position.x + deltaX
            let newY = puyo.position.y + deltaY

            // 移動できない条件がある場合
            if newX < 0 || newX >= puyoGrid.width || newY < 0 || newY >= puyoGrid.height {
                canMove = false
                print("ぷよが移動できません: newX=\(newX), newY=\(newY) - 範囲外")
                break
            }

            // 他のぷよに衝突しないか確認（同じ組ぷよは無視）
            if let otherPuyo = puyoGrid.grid[newY][newX] {
                if !currentPuyos.contains(where: { $0.id == otherPuyo.id }) {
                    canMove = false
                    print("ぷよが移動できません: newX=\(newX), newY=\(newY) - 他のぷよに衝突")
                    break
                }
            }
        }

        // 移動可能ならすべてのぷよを移動させる
        if canMove {
            // まずはすべてのぷよをグリッドから削除
            for puyo in currentPuyos {
                puyoGrid.removePuyo(at: (puyo.position.x, puyo.position.y))
            }

            // 新しい位置にすべてのぷよを移動
            for i in 0..<currentPuyos.count {
                currentPuyos[i].position.x += deltaX
                currentPuyos[i].position.y += deltaY
            }

            // 新しい位置にすべてのぷよを追加
            for puyo in currentPuyos {
                puyoGrid.addPuyo(puyo)
            }
        }

        return canMove
    }
    
    func rotatePuyosRight() {
        let axisPuyo = currentPuyos[1]  // 軸ぷよ
        let childPuyo = currentPuyos[0]  // 子ぷよ
        
        if childPuyo.position.x == 0 && childPuyo.position.x < axisPuyo.position.x {
            return
        }

        // 子ぷよの相対的な位置を計算し、右回転（時計回り）
        let relativeX = childPuyo.position.x - axisPuyo.position.x
        let relativeY = childPuyo.position.y - axisPuyo.position.y
        var newChildPuyoPosition: (Int, Int) = (axisPuyo.position.x - relativeY, axisPuyo.position.y + relativeX)
        var newParentPuyoPosition: (Int, Int) = (axisPuyo.position.x, axisPuyo.position.x)

        if axisPuyo.position.x - relativeY >= puyoGrid.width {
            newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
            newParentPuyoPosition = (axisPuyo.position.x - 1, axisPuyo.position.y + relativeX)
        }
        else if axisPuyo.position.x - relativeY == -1 {
            newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
            newParentPuyoPosition = (axisPuyo.position.x + 1, axisPuyo.position.y + relativeX)
        } else { // 壁とは離れている
            if puyoGrid.grid[newChildPuyoPosition.1][newChildPuyoPosition.0] != nil { // ぷよに衝突
                if relativeY < 0 { // 子ぷよが上
                    newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                    newParentPuyoPosition = (axisPuyo.position.x - 1, axisPuyo.position.y + relativeX)
                    if puyoGrid.grid[newParentPuyoPosition.1][newParentPuyoPosition.0] != nil { // rotete 180
                        newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX + 1)
                        newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                        if puyoGrid.grid[newChildPuyoPosition.1][newChildPuyoPosition.0] != nil { // 180の先にぷよが存在
                            newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                            newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX - 1)
                        }
                    }
                } else if relativeY > 0 { // 子ぷよが下
                    newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                    newParentPuyoPosition = (axisPuyo.position.x + 1, axisPuyo.position.y + relativeX)
                    if puyoGrid.grid[newParentPuyoPosition.1][newParentPuyoPosition.0] != nil { // rotete 180
                        newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX - 1)
                        newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                    }
                } else {
                    newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX - 1)
                    newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX - 2)
                }
            } else {
                newChildPuyoPosition = (axisPuyo.position.x - relativeY, axisPuyo.position.y + relativeX)
                newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y)
            }
        }
        
        // 移動先が範囲外なら何もせず終了
        if newChildPuyoPosition.1 < 0 || newParentPuyoPosition.1 < 0 {
            return
        }
        
        // グリッドから古い位置のぷよを削除
        puyoGrid.removePuyo(at: (childPuyo.position.x, childPuyo.position.y))
        puyoGrid.removePuyo(at: (axisPuyo.position.x, axisPuyo.position.y))

        // 新しい位置にぷよを移動
        currentPuyos[0].position = Position(x: newChildPuyoPosition.0, y: newChildPuyoPosition.1)
        currentPuyos[1].position = Position(x: newParentPuyoPosition.0, y: newParentPuyoPosition.1)
        
        // グリッドに新しい位置のぷよを追加
        puyoGrid.addPuyo(currentPuyos[0])
        puyoGrid.addPuyo(currentPuyos[1])
    }

    func rotatePuyosLeft() {
        let axisPuyo = currentPuyos[1]  // 軸ぷよ
        let childPuyo = currentPuyos[0]  // 子ぷよ
        
        if childPuyo.position.y == 0 && childPuyo.position.x > axisPuyo.position.x {
            return
        }

        // 子ぷよの相対的な位置を計算し、左回転
        let relativeX = childPuyo.position.x - axisPuyo.position.x
        let relativeY = childPuyo.position.y - axisPuyo.position.y
        var newChildPuyoPosition: (Int, Int) = (axisPuyo.position.x + relativeY, axisPuyo.position.y - relativeX)
        var newParentPuyoPosition: (Int, Int) = (axisPuyo.position.x, axisPuyo.position.x)

        if axisPuyo.position.x + relativeY >= puyoGrid.width {
            newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
            newParentPuyoPosition = (axisPuyo.position.x - 1, axisPuyo.position.y + relativeX)
        }
        else if axisPuyo.position.x + relativeY == -1 {
            newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y - relativeX)
            newParentPuyoPosition = (axisPuyo.position.x + 1, axisPuyo.position.y + relativeX)
        } else { // 壁とは離れている
            if puyoGrid.grid[newChildPuyoPosition.1][newChildPuyoPosition.0] != nil { // ぷよに衝突
                if relativeY < 0 { // 子ぷよが上
                    newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y - relativeX)
                    newParentPuyoPosition = (axisPuyo.position.x + 1, axisPuyo.position.y + relativeX)
                    if puyoGrid.grid[newParentPuyoPosition.1][newParentPuyoPosition.0] != nil { // rotete 180
                        newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX + 1)
                        newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                        if puyoGrid.grid[newChildPuyoPosition.1][newChildPuyoPosition.0] != nil { // 180の先にぷよが存在
                            newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                            newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX - 1)
                        }
                    }
                } else if relativeY > 0 { // 子ぷよが下
                    newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                    newParentPuyoPosition = (axisPuyo.position.x - 1, axisPuyo.position.y + relativeX)
                    if puyoGrid.grid[newParentPuyoPosition.1][newParentPuyoPosition.0] != nil { // rotete 180
                        newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX - 1)
                        newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                    }
                } else {
                    newChildPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX + 1)
                    newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y + relativeX)
                }
            } else {
                newChildPuyoPosition = (axisPuyo.position.x + relativeY, axisPuyo.position.y - relativeX)
                newParentPuyoPosition = (axisPuyo.position.x, axisPuyo.position.y)
            }
        }
        
        // 移動先が範囲外なら何もせず終了
        if newChildPuyoPosition.1 < 0 || newParentPuyoPosition.1 < 0 {
            return
        }
        
        // グリッドから古い位置のぷよを削除
        puyoGrid.removePuyo(at: (childPuyo.position.x, childPuyo.position.y))
        puyoGrid.removePuyo(at: (axisPuyo.position.x, axisPuyo.position.y))

        // 新しい位置にぷよを移動
        currentPuyos[0].position = Position(x: newChildPuyoPosition.0, y: newChildPuyoPosition.1)
        currentPuyos[1].position = Position(x: newParentPuyoPosition.0, y: newParentPuyoPosition.1)

        // グリッドに新しい位置のぷよを追加
        puyoGrid.addPuyo(currentPuyos[0])
        puyoGrid.addPuyo(currentPuyos[1])
    }

    func applyGravityToPuyos() {
        // グリッド全体を下から上に向かってスキャン
        for y in (0..<puyoGrid.height).reversed() {  // 下から上へ
            for x in 0..<puyoGrid.width {
                // ぷよがある場合
                if var puyo = puyoGrid.grid[y][x] {
                    var currentY = y

                    // 下が空いている限り、ぷよを下まで落とす
                    while currentY + 1 < puyoGrid.height && puyoGrid.grid[currentY + 1][x] == nil {
                        puyoGrid.removePuyo(at: (x, currentY))  // 現在の位置から削除
                        currentY += 1  // 下に移動
                        puyo.position.y = currentY  // ぷよの位置を更新
                        puyoGrid.addPuyo(puyo)  // 新しい位置にぷよを追加
                    }
                }
            }
        }
    }

    
    func findConnectedPuyos(from start: Position) -> [Position] {
        guard let startPuyo = puyoGrid.grid[start.y][start.x] else { return [] }
        
        var stack = [start]
        var visited = Set<Position>()
        visited.insert(start)
        var connectedPuyos = [Position]()

        while !stack.isEmpty {
            let current = stack.removeLast()
            connectedPuyos.append(current)

            let neighbors = [
                Position(x: current.x - 1, y: current.y),  // 左
                Position(x: current.x + 1, y: current.y),  // 右
                Position(x: current.x, y: current.y - 1),  // 上
                Position(x: current.x, y: current.y + 1)   // 下
            ]
            
            for neighbor in neighbors {
                if neighbor.y > 0 && neighbor.x >= 0 && neighbor.x < puyoGrid.width && neighbor.y < puyoGrid.height {
                    if let neighborPuyo = puyoGrid.grid[neighbor.y][neighbor.x],
                       neighborPuyo.color == startPuyo.color,
                       !visited.contains(neighbor) {
                        stack.append(neighbor)
                        visited.insert(neighbor)
                    }
                }
            }
        }

        return connectedPuyos
    }

    
    func removeConnectedPuyos() -> Bool {
        var removed = false
        var visited = Set<Position>()

        // グリッド全体をスキャン
        for y in 1..<puyoGrid.height {
            for x in 0..<puyoGrid.width {
                if let _ = puyoGrid.grid[y][x], !visited.contains(Position(x: x, y: y)) {
                    let connectedPuyos = findConnectedPuyos(from: Position(x: x, y: y))

                    // 4つ以上連結していたら消す
                    if connectedPuyos.count >= 4 {
                        for position in connectedPuyos {
                            puyoGrid.removePuyo(at: (position.x, position.y))
                            visited.insert(position)  // 削除された位置を記録
                        }
                        removed = true
                    }
                }
            }
        }
        return removed
    }

    func dropPuyosWithGravityAndRemoveAsync() {
        applyGravityToPuyos()  // まずぷよをすべて下に落とす
        // 非同期に連鎖処理を行う
        DispatchQueue.global().async {
            while self.removeConnectedPuyos() {
                // メインスレッドでUI更新とグラビティ適用
                DispatchQueue.main.async {
                    self.applyGravityToPuyos()
                }
                // 0.5秒待機（この間にUIの更新が行われる）
                Thread.sleep(forTimeInterval: 0.5)
            }
            // 最後に新しいぷよを配置
            DispatchQueue.main.async {
                self.placePuyos()
                savePuyoGridState()  // 状態を履歴に保存
            }
        }
    }
    
    struct PuyoGridState {
        var grid: [[Puyo?]]  // グリッドの状態
        var currentPuyos: [Puyo]  // 現在操作中のぷよ
    }

    @State private var puyoGridHistory: [PuyoGridState] = []  // 履歴
    @State private var currentHistoryIndex: Int = -1  // 現在の履歴のインデックス
    
    func savePuyoGridState() {
        // 現在のグリッドとcurrentPuyosの状態を保存
        let currentGrid = puyoGrid.grid.map { row in row.map { $0 } }
        let currentState = PuyoGridState(grid: currentGrid, currentPuyos: currentPuyos)

        // グリッド履歴を上書きする場合
        if currentHistoryIndex < puyoGridHistory.count - 1 {
            puyoGridHistory = Array(puyoGridHistory.prefix(currentHistoryIndex + 1))
        }

        // グリッドとcurrentPuyosの状態を保存
        puyoGridHistory.append(currentState)

        currentHistoryIndex += 1  // インデックスを進める
    }


    func restorePuyoGridState() {
        guard currentHistoryIndex > 0 else { return }  // インデックスが0より大きい場合のみ戻す
        
        nextdPuyos = nextPuyos
        nextPuyos = currentPuyos
        // currentPuyoの位置ごと戻してしまうので初期位置に戻す
        nextPuyos[0].position = Position(x: 2, y: 0)
        nextPuyos[1].position = Position(x: 2, y: 1)
        
        currentHistoryIndex -= 1  // インデックスを1つ戻す
        let previousState = puyoGridHistory[currentHistoryIndex]  // 1つ前の状態を取得
        puyoGrid.grid = previousState.grid  // グリッドを復元
        currentPuyos = previousState.currentPuyos  // currentPuyosを復元
    }
    
    func resetGame() {
        // グリッドをリセット（全てのぷよを削除）
        for y in 0..<puyoGrid.height {
            for x in 0..<puyoGrid.width {
                puyoGrid.grid[y][x] = nil
            }
        }
        
        // 現在のぷよとネクストぷよをリセット
        currentPuyos.removeAll()
        nextPuyos.removeAll()

        // 履歴をリセット
        puyoGridHistory.removeAll()
        nextPuyoHistory.removeAll()
        currentHistoryIndex = -1

        // 最初のぷよを生成してゲームを再開
        setupNewPuyos()
    }

    
    struct GridView: View {
        @Binding var puyoGrid: PuyoGrid

        var body: some View {
            VStack(spacing: 0) {  // マス目の間に少し隙間を作る
                ForEach(0..<puyoGrid.height, id: \.self) { row in
                    HStack(spacing: 0) {  // 横のマスにも隙間を作る
                        ForEach(0..<puyoGrid.width, id: \.self) { column in
                            ZStack {
                                // グリッドの背景
                                if row == 0 {  // 13段目（プログラム上は12行目）
                                    Rectangle()
                                        .fill(Color(white: 0.2))  // 13段目は少し暗めのグレー
                                        .frame(width: 40, height: 40)  // グリッドの各マスの大きさ
                                } else {
                                    // グリッドの背景を常に描画（背景がゲーム画面にならないようにする）
                                    Rectangle()
                                        .fill(Color(white: 0.3))  // グリッドの背景色を設定
                                        .frame(width: 40, height: 40)  // グリッドの各マスの大きさ
                                }

                                // ぷよが存在する場合、そのぷよを描画
                                if let puyo = puyoGrid.grid[row][column] {
                                    // findConnectedPuyosを使って連結状態を取得
                                    let connectedPuyos = findConnectedPuyos(from: Position(x: column, y: row))
                                    
                                    // 連結している場合、連結部分に長方形を描画
                                    if isConnected(at: (row, column), to: (row, column - 1), in: connectedPuyos) {
                                        Rectangle()
                                            .fill(puyo.color.swiftUIColor)  // 同じ色で描画
                                            .frame(width: 20, height: 20)  // 左右の連結を表現
                                            .offset(x: -20)  // 左にずらす
                                    }

                                    if isConnected(at: (row, column), to: (row - 1, column), in: connectedPuyos) {
                                        Rectangle()
                                            .fill(puyo.color.swiftUIColor)  // 同じ色で描画
                                            .frame(width: 20, height: 20)  // 上下の連結を表現
                                            .offset(y: -20)  // 上にずらす
                                    }

                                    // ぷよ自体の描画
                                    PuyoView(puyo: puyo)
                                        .frame(width: 30, height: 30)
                                }
                            }
                        }
                    }
                }
            }
        }

        // ぷよが特定の隣の位置と連結しているかどうかを判定する関数
        func isConnected(at currentPosition: (Int, Int), to neighborPosition: (Int, Int), in connectedPuyos: [Position]) -> Bool {
            let (neighborRow, neighborColumn) = neighborPosition
            
            // 隣接している場所がグリッドの範囲内であり、連結している場合に true を返す
            if neighborRow >= 0 && neighborRow < puyoGrid.height &&
               neighborColumn >= 0 && neighborColumn < puyoGrid.width {
                return connectedPuyos.contains(Position(x: neighborColumn, y: neighborRow))
            }
            return false
        }
        
        func findConnectedPuyos(from start: Position) -> [Position] {
            guard let startPuyo = puyoGrid.grid[start.y][start.x] else { return [] }
            
            var stack = [start]
            var visited = Set<Position>()
            visited.insert(start)
            var connectedPuyos = [Position]()

            while !stack.isEmpty {
                let current = stack.removeLast()
                connectedPuyos.append(current)

                let neighbors = [
                    Position(x: current.x - 1, y: current.y),  // 左
                    Position(x: current.x + 1, y: current.y),  // 右
                    Position(x: current.x, y: current.y - 1),  // 上
                    Position(x: current.x, y: current.y + 1)   // 下
                ]
                
                for neighbor in neighbors {
                    if neighbor.y > 0 && neighbor.x >= 0 && neighbor.x < puyoGrid.width && neighbor.y < puyoGrid.height {
                        if let neighborPuyo = puyoGrid.grid[neighbor.y][neighbor.x],
                           neighborPuyo.color == startPuyo.color,
                           !visited.contains(neighbor) {
                            stack.append(neighbor)
                            visited.insert(neighbor)
                        }
                    }
                }
            }
            return connectedPuyos
        }
    }

    func saveNextPuyoHistoryToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(nextPuyoHistory) {
            UserDefaults.standard.set(encoded, forKey: "nextPuyoHistory")
            print("ネクストぷよ履歴を保存しました")
        }
    }

    func loadNextPuyoHistoryFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "nextPuyoHistory") {
            let decoder = JSONDecoder()
            if let loadedHistory = try? decoder.decode([[Puyo]].self, from: savedData) {
                nextPuyoHistory = loadedHistory
                print("ネクストぷよ履歴を読み込みました")
                
                // currentPuyos, nextPuyos, nextdPuyos を復元
                if nextPuyoHistory.count >= 3 {
                    // 古いcurrentPuyosを削除
                    puyoGrid.removePuyo(at: (currentPuyos[0].position.x, currentPuyos[0].position.y))
                    puyoGrid.removePuyo(at: (currentPuyos[1].position.x, currentPuyos[1].position.y))
                    
                    currentPuyos = nextPuyoHistory[0]
                    nextPuyos = nextPuyoHistory[1]
                    nextdPuyos = nextPuyoHistory[2]
                }
                
                puyoGrid.addPuyo(currentPuyos[0])
                puyoGrid.addPuyo(currentPuyos[1])
            }
        }
    }


}
