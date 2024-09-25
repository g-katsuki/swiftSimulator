import SwiftUI

struct ContentView: View {
    @State private var puyoGrid = PuyoGrid(width: 6, height: 12)
    @State private var currentPuyos: [Puyo] = []  // 現在操作中のぷよ
    @State private var nextPuyos: [Puyo] = []     // ネクストぷよ

    var body: some View {
        VStack {
            // グリッドを表示
            GridView(puyoGrid: $puyoGrid)

            // ネクストぷよを表示
            Text("Next Puyo")
            HStack {
                ForEach(nextPuyos) { puyo in
                        PuyoView(puyo: puyo)
                }
            }
            .frame(height: 60) // ネクストぷよの表示用

            // 移動用のコントロールボタン
            HStack {
                Button(action: {
                    movePuyosLeft()
                }) {
                    Text("←").padding().background(Color.gray).cornerRadius(10)
                }
                
                Button(action: {
                    applyGravityToPuyos()
                    placePuyos()
                }) {
                    Text("↓").padding().background(Color.gray).cornerRadius(10)
                }

                Button(action: {
                    movePuyosRight()
                }) {
                    Text("→").padding().background(Color.gray).cornerRadius(10)
                }
                
                Button(action: {
                    rotatePuyosLeft()  // ぷよを左回転させる
                }) {
                    Text("左").padding().background(Color.gray).cornerRadius(10)
                }

                Button(action: {
                    rotatePuyosRight()  // ぷよを右回転させる
                }) {
                    Text("右").padding().background(Color.gray).cornerRadius(10)
                }

            }

            .padding()
        }
        .onAppear {
            // 最初のぷよとネクストぷよを表示
            setupNewPuyos()
        }
    }

    // 新しいぷよのセットアップ
    func setupNewPuyos() {
        // 現在のぷよをランダム生成
        let firstPuyo = Puyo(color: randomPuyoColor(), position: (2, 0))
        let secondPuyo = Puyo(color: randomPuyoColor(), position: (2, 1))
        currentPuyos = [firstPuyo, secondPuyo]

        // グリッドに現在のぷよを追加
        puyoGrid.addPuyo(firstPuyo)
        puyoGrid.addPuyo(secondPuyo)

        // ネクストぷよをランダム生成
        let nextFirstPuyo = Puyo(color: randomPuyoColor(), position: (0, 0))
        let nextSecondPuyo = Puyo(color: randomPuyoColor(), position: (0, 1))
        nextPuyos = [nextFirstPuyo, nextSecondPuyo]
    }

    // ぷよを設置し、次のぷよを現在のぷよにする
    func placePuyos() {
        // 現在のぷよを固定し、新しいぷよをネクストから取得
        currentPuyos = nextPuyos

        // 新しいぷよをグリッドの初期位置にセット
        for i in 0..<currentPuyos.count {
            currentPuyos[i].position = (2, i)  // 初期位置を設定
        }

        // グリッドに新しいぷよを追加
        for puyo in currentPuyos {
            puyoGrid.addPuyo(puyo)
        }

        // 新しいネクストぷよを生成
        let nextFirstPuyo = Puyo(color: randomPuyoColor(), position: (0, 0))
        let nextSecondPuyo = Puyo(color: randomPuyoColor(), position: (0, 1))
        nextPuyos = [nextFirstPuyo, nextSecondPuyo]
    }

    // ぷよを左に移動
    func movePuyosLeft() {
        _ = movePuyos(byX: -1, byY: 0)  // 戻り値を無視する
    }

    // ぷよを右に移動
    func movePuyosRight() {
        _ = movePuyos(byX: 1, byY: 0)  // 戻り値を無視する
    }

    // ぷよを下に移動
    func movePuyosDown() {
        _ = movePuyos(byX: 0, byY: 1)  // 戻り値を無視する
    }


    // 汎用的な移動関数を修正
    // 戻り値として「移動できるかどうか」を返すようにする
    func movePuyos(byX deltaX: Int, byY deltaY: Int) -> Bool {
        var canMove = true

        // 全てのぷよについて移動後の位置がすべてグリッドの範囲内で空いているか確認
        for (index, puyo) in currentPuyos.enumerated() {
            let newX = puyo.position.0 + deltaX
            let newY = puyo.position.1 + deltaY

            // デバッグ用ログ
            print("チェック中: newX=\(newX), newY=\(newY)")

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
                puyoGrid.removePuyo(at: puyo.position)
            }

            // 新しい位置にすべてのぷよを移動
            for i in 0..<currentPuyos.count {
                currentPuyos[i].position.0 += deltaX
                currentPuyos[i].position.1 += deltaY
            }

            // 新しい位置にすべてのぷよを追加
            for puyo in currentPuyos {
                puyoGrid.addPuyo(puyo)
            }

            print("ぷよを移動しました")
        }

        return canMove
    }
    
    func rotatePuyosRight() {
        guard currentPuyos.count == 2 else {
            return  // 2つのぷよがなければ回転しない
        }
        
        let axisPuyo = currentPuyos[1]  // 軸ぷよ（下側のぷよ）
        let childPuyo = currentPuyos[0]  // 子ぷよ（上側のぷよ）

        // 子ぷよの相対的な位置を計算し、右回転（時計回り）
        let relativeX = childPuyo.position.0 - axisPuyo.position.0
        let relativeY = childPuyo.position.1 - axisPuyo.position.1
        let newChildPuyoPosition: (Int, Int) = (axisPuyo.position.0 - relativeY, axisPuyo.position.1 + relativeX)

        // 回転先がグリッド範囲内か、他のぷよに衝突しないか確認
        if newChildPuyoPosition.0 < 0 || newChildPuyoPosition.0 >= puyoGrid.width ||
           newChildPuyoPosition.1 < 0 || newChildPuyoPosition.1 >= puyoGrid.height ||
           puyoGrid.grid[newChildPuyoPosition.1][newChildPuyoPosition.0] != nil {
            return  // 回転できない場合は何もしない
        }

        // グリッドから古い位置のぷよを削除
        puyoGrid.removePuyo(at: childPuyo.position)

        // 新しい位置にぷよを移動
        currentPuyos[0].position = newChildPuyoPosition

        // グリッドに新しい位置のぷよを追加
        puyoGrid.addPuyo(currentPuyos[0])

        print("ぷよを右回転させました: \(newChildPuyoPosition)")
    }

    func rotatePuyosLeft() {
        guard currentPuyos.count == 2 else {
            return  // 2つのぷよがなければ回転しない
        }
        
        let axisPuyo = currentPuyos[1]  // 軸ぷよ（下側のぷよ）
        let childPuyo = currentPuyos[0]  // 子ぷよ（上側のぷよ）

        // 子ぷよの相対的な位置を計算し、左回転（反時計回り）
        let relativeX = childPuyo.position.0 - axisPuyo.position.0
        let relativeY = childPuyo.position.1 - axisPuyo.position.1
        let newChildPuyoPosition: (Int, Int) = (axisPuyo.position.0 + relativeY, axisPuyo.position.1 - relativeX)

        // 回転先がグリッド範囲内か、他のぷよに衝突しないか確認
        if newChildPuyoPosition.0 < 0 || newChildPuyoPosition.0 >= puyoGrid.width ||
           newChildPuyoPosition.1 < 0 || newChildPuyoPosition.1 >= puyoGrid.height ||
           puyoGrid.grid[newChildPuyoPosition.1][newChildPuyoPosition.0] != nil {
            return  // 回転できない場合は何もしない
        }

        // グリッドから古い位置のぷよを削除
        puyoGrid.removePuyo(at: childPuyo.position)

        // 新しい位置にぷよを移動
        currentPuyos[0].position = newChildPuyoPosition

        // グリッドに新しい位置のぷよを追加
        puyoGrid.addPuyo(currentPuyos[0])

        print("ぷよを左回転させました: \(newChildPuyoPosition)")
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
                        puyo.position.1 = currentY  // ぷよの位置を更新
                        puyoGrid.addPuyo(puyo)  // 新しい位置にぷよを追加
                    }
                }
            }
        }
        print("重力による一括落下完了")
    }

}

