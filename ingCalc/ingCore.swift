//
//  ingCore.swift
//  ingCalc
//
//  Created by yuka on 2017/11/28.
//  Copyright © 2017年 yuka. All rights reserved.
// TODO : オプショナルバインディング

//================================
// ingCalcでCoreDataを扱うための処理
// r_id:0が最新 r_id:9まで
// result :　計算結果　コピー用
// resultText : 計算過程の式　表示用

import UIKit
import CoreData

class ingCore {
    //AppDelegateを使う用意をしておく（インスタンス化）
    let appDalegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var dics:[NSDictionary] = []
    var rirekiCount:Int = -1
    private let maxNum:Int = 10
    
    init() {
        let viewContext = appDalegate.persistentContainer.viewContext
        let query:NSFetchRequest<Rireki> =  Rireki.fetchRequest()
        
        do {
            let fetchResults = try viewContext.fetch(query)
            rirekiCount = fetchResults.count
            NSLog("coreDataの数\(rirekiCount)")
        }
        catch{
            
        }
    }
    
    //==============================
    // Create
    //==============================
    func createRecord(r_id:Int, result:String, resultText:String) {
        print(#function)
        //エンティティを操作するためのオブジェクトを作成する
        let viewContext = appDalegate.persistentContainer.viewContext
        
        //エンティティオブジェクトを作成する
        let myEntity = NSEntityDescription.entity(forEntityName: "Rireki", in: viewContext)
        
        //ToDOエンティティにレコードを挿入するためのオブジェクトを作成
        let newRecord = NSManagedObject(entity: myEntity!, insertInto: viewContext)
        
        //値のセット
        newRecord.setValue(r_id, forKey: "r_id")
        newRecord.setValue(result, forKey: "result")
        newRecord.setValue(resultText, forKey: "resultText")

        
        //レコードの即時保存
        do {
            try viewContext.save()
            rirekiCount = rirekiCount + 1
        } catch {
            //エラーが発生した時に行う例外処理を書いておく
        }
        
    }
    
    //==============================
    // Read All
    //==============================
    //既に存在するデータの読み込み処理
    func readRirekiAll() -> [NSDictionary] {
        print(#function)
        //エンティティを操作するためのオブジェクトを作成する
        let viewContext = appDalegate.persistentContainer.viewContext
        
        //エンティティを設定
        let query:NSFetchRequest<Rireki> =  Rireki.fetchRequest()

        //データを一括取得
        do {
        
            let fetchResults = try viewContext.fetch(query)
            
            //saveするときに、nilチェックするのでnilはない前提
            for fetch:AnyObject in fetchResults {
                let r_id:Int = (fetch.value(forKey: "r_id") as? Int)!
                let result:String = (fetch.value(forKey: "result") as? String)!
                let resultText:String = (fetch.value(forKey: "resultText") as? String)!

                let dic =  ["r_id":r_id,"result":result,"resultText":resultText] as [String : Any]
                
                print(dic)
                
                dics.append(dic as NSDictionary)
                
                
            }

            
        } catch  {
            
        }
        
        return dics
        
    }
    
    
    //==============================
    // Read 1
    //==============================
    func readRireki(r_id:Int) -> NSDictionary {
        print(#function)
        //エンティティを操作するためのオブジェクトを作成する
        let viewContext = appDalegate.persistentContainer.viewContext
        var dic:NSDictionary = NSDictionary()

        //どのエンティティからデータを取得してくるか設定
        let query:NSFetchRequest<Rireki> =  Rireki.fetchRequest()
        
        
        //===== 絞り込み =====
        let r_idPredicate = NSPredicate(format: "r_id = %d", r_id)
        query.predicate = r_idPredicate


        //===== データ１件取得（r_idを指定しているので) =====
        do {
            
            let fetchResults = try viewContext.fetch(query)
            
            //きちんと保存できているか、１行ずつ表示（デバッグエリア）
            for fetch:AnyObject in fetchResults {
                let r_id:Int = (fetch.value(forKey: "r_id") as? Int)!
                let result:String = (fetch.value(forKey: "result") as? String)!
                let resultText:String = (fetch.value(forKey: "resultText") as? String)!
                
                dic =  ["r_id":r_id,"result":result,"resultText":resultText]

                print(dic)
                
            }
        
        } catch  {
            
        }
        
        return (dic as NSDictionary)
    }

    //==============================
    // Delete all
    //==============================
    func deleteRirekiAll() {
        print(#function)
        //エンティティを操作するためのオブジェクトを作成する
        let viewContext = appDalegate.persistentContainer.viewContext
        
        //どのエンティティからデータを取得してくるか設定（ToDoエンティティ）
        let query:NSFetchRequest<Rireki> =  Rireki.fetchRequest()
        
        do {
            //削除するデータを取得（今回は全て取得）
            let fetchResults = try viewContext.fetch(query)
            
            //１行ずつ削除
            
            for fetch:AnyObject in fetchResults{
                //削除処理を行うために型変換
                let record = fetch as! NSManagedObject  // 扱いやすいように型変換
                viewContext.delete(record)
                
            }
            //削除した状態を保存
            try viewContext.save()
            
            
        } catch  {
            
        }
        
    }
    
    //==============================
    // Delete 1
    //==============================
    func deleteRireki(r_id:Int) {
        
        //エンティティを操作するためのオブジェクトを作成する
        let viewContext = appDalegate.persistentContainer.viewContext
        
        //どのエンティティからデータを取得してくるか設定（ToDoエンティティ）
        let query:NSFetchRequest<Rireki> =  Rireki.fetchRequest()
        
        //===== 絞り込み =====
        let r_idPredicate = NSPredicate(format: "r_id = %d", r_id)
        query.predicate = r_idPredicate
        

        do {
            //削除するデータを取得
            let fetchResults = try viewContext.fetch(query)
            
            //１行ずつ削除
            
            for fetch:AnyObject in fetchResults{
                //削除処理を行うために型変換
                let record = fetch as! NSManagedObject  // 扱いやすいように型変換
                viewContext.delete(record)
                
            }
            //削除した状態を保存
            try viewContext.save()
            
            
        } catch  {
            
            print(#function)
            print("削除するレコードなかったよ")
            
        }
        
    }
    
    //==============================
    // Edit
    //==============================

    func editRireki(r_id:Int, result:String, resultText:String) {
        print(#function)
        //エンティティを操作するためのオブジェクトを作成する
        let viewContext = appDalegate.persistentContainer.viewContext
        
        //どのエンティティからデータを取得してくるか設定（ToDoエンティティ）
        let query:NSFetchRequest<Rireki> =  Rireki.fetchRequest()
        
      
        //===== 絞り込み =====
        let r_idPredicate = NSPredicate(format: "r_id = %d", r_id)
        query.predicate = r_idPredicate
        
        do {
            
            let fetchResults = try viewContext.fetch(query)
            
            if (fetchResults.count == 0) {
                //なければ新規で作る
                print(#function)
                print("ないので作ります。")
                createRecord(r_id: r_id, result: result, resultText: resultText)
                return  // 作って終了する
            }
            
            for fetch:AnyObject in fetchResults {
                
                //更新する対象のデータをNSManagedObjectにダウンキャスト
                let record = fetch as! NSManagedObject
                //値のセット
                record.setValue(r_id, forKey: "r_id")
                record.setValue(result, forKey: "result")
                record.setValue(resultText, forKey: "resultText")
                
                //レコードの即時保存
                do {
                    try viewContext.save()
                } catch {
                    //エラーが発生した時に行う例外処理を書いておく
                    print(#function)
                    print("保存できなかった")
                }
                
                
            }
            
            
        } catch  {
            
        }

        
    }
    
    //==============================
    // 挿入 履歴maxnum件　0に最新を入れる
    // r_id:maxnum-1番目は上書きされて削除になる
    //==============================
    
    func insertRireki(result:String, resultText:String) {
        print(#function)
        //1段ずつずらす処理
        if( rirekiCount > 1 ) {
            for i in 1...rirekiCount {
                let anum = rirekiCount - i   // 後ろの方から
                // [i-1]の
                let before = self.readRireki(r_id: anum )

                if( (anum + 1) <  maxNum ) {
                    editRireki(r_id: anum + 1, result: before["result"] as! String, resultText: before["resultText"] as! String)

                }

            }
        }
        else if ( rirekiCount == 1) {
            let before = self.readRireki(r_id: 0 )
            editRireki(r_id: 1, result: before["result"] as! String, resultText: before["resultText"] as! String)

        }
        //0番目に追加
        editRireki(r_id: 0, result: result , resultText: resultText)
    }
        
}
