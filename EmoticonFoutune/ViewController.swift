//
//  ViewController.swift
//  EmoticonFoutune
//
//  Created by 李根一 on 2016/03/17.
//  Copyright © 2016年 Lee Geunil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // ストーリーボードの画面要素
    @IBOutlet weak var emoticonLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var foutuneBtn: UIButton!

    // 動物絵文字と占い文を取得する
    let results = NSDictionary(contentsOfFile:NSBundle.mainBundle().pathForResource("ResultList", ofType: "plist")!)
    
    // タイマー
    var timer: NSTimer?
    
    // タイマーカウンター
    var timerCounter: Int = 0
    
    // 占い回数
    var foutuneCounter: Int = 0

    // 初回画面が読み込まれた際に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 占い中じゃないレイアウトに初期化
        endFoutuneLayout()
    }
    
    // ボタンが押された際に呼び出される
    @IBAction func onStartFoutune(sender: AnyObject) {
        if judgeFoutuneLimit() {
            return
        }
        startFoutuneLayout()
        resultLabel.text = ""
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(ViewController.onUpdate), userInfo: nil, repeats: true)
    }

    // タイマースケジュールに寄って0.1秒間隔で呼び出される
    func onUpdate() {
        
        // 占い結果の種類要素数の回数かチェック
        if timerCounter == results?.count {
            
            // 占い結果の種類要素数と同じになったら結果を表示する処理へ
            finish()
            
        } else {
            
            // それ以外なら絵文字表示ラベルを変更する(0.1秒間隔なのでスロットの様に表示される)
            let result = getResult(timerCounter)
            emoticonLabel.text = result.0
            
        }
        
        // タイマーカウンターを更新
        timerCounter += 1
    }

    // 占い結果表示の際に呼ぶ
    func finish() {
        
        // タイマー停止
        self.timer?.invalidate()
        self.timer = nil

        // タイマーカウンター初期化
        timerCounter = 0
        
        // 占い回数を更新
        foutuneCounter += 1
        
        // 占いボタン文言を変更
        updateBtn()
        
        // 占い中じゃないレイアウトに変更
        endFoutuneLayout()
        
        // 占い結果を表示
        resultLabel.textAlignment = NSTextAlignment.Left
        let random = arc4random_uniform(UInt32((results?.count)!))
        let result = getResult(Int(random))
        emoticonLabel.text = result.0
        resultLabel.text = result.1
    }

    // 占い結果を返す
    func getResult(index: Int) -> (String, String) {
        
        // 動物絵文字
        var emoticon: String?
        
        // 占い結果の文言
        var description: String?
        
        // for文のループを数えるカウンター
        var counter = 0

        // 結果を調べるためのforループ
        for (key, value) in results! {

            // 引数で取得した数値とループの回数が一致した場合のみ結果を格納する
            if index == counter {
                emoticon = String(key)
                description = String(value)
            }
            
            // ループカウンター更新
            counter += 1
        }
        
        // タプルで結果を返す
        return (emoticon!, description!)
    }
    
    // 占いボタンを更新
    func updateBtn() {
        
        // 占いボタン文言を変更
        foutuneBtn.setTitle(getFoutuneText(), forState: UIControlState.Normal)
        
        // 占い３回以上なら背景を赤に
        if foutuneCounter >= 3 {
            foutuneBtn.backgroundColor = UIColor.redColor()
        } else {
            foutuneBtn.backgroundColor = UIColor.magentaColor()
        }
    }

    // 占いボタンの文言を返す
    func getFoutuneText() -> String {
        if foutuneCounter == 1 {
            return "もう一度、占う！"
        } else if foutuneCounter == 2 {
            return "もう一度、占いたい！！"
        } else if foutuneCounter == 3 {
            return "占いは一日３度まで！"
        } else {
            return "占う"
        }
    }

    // 占い回数を判定
    func judgeFoutuneLimit() -> Bool {
        
        if foutuneCounter >= 3 {
            return true
        } else {
            return false
        }
    }
    
    /**
     * 占い中のレイアウト
     *   黒背景を表示かつ最前面にし、絵文字ラベルを最前面にして絵文字ラベルを目立たせる
     */
    func startFoutuneLayout() {
        bgView.hidden = false
        self.view.bringSubviewToFront(bgView)
        self.view.bringSubviewToFront(emoticonLabel)
    }
    
    /**
     * 占い中ではない場合のレイアウト
     *   黒背景を非表示かつ最背面にし、絵文字ラベルを最前面にして元に戻す
     */
    func endFoutuneLayout() {
        bgView.hidden = true
        self.view.sendSubviewToBack(bgView)
        self.view.bringSubviewToFront(emoticonLabel)
    }
}

