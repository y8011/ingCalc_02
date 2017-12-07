//
//  ingCoreData.swift
//  ingCalc
//
//  Created by yuka on 2017/12/01.
//  Copyright © 2017年 yuka. All rights reserved.
//

import CoreData
import UIKit


//rirekiCount : 現在の履歴の数
//max_rid     : 現在の最大の r_idの位置
//maxNum      : 最大の値

class ingCoreData {
    //AppDelegateを使う用意をしておく（インスタンス化）
    let appDalegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var dics:[NSDictionary] = []
    var rirekiCount:Int = -1
    var min_rid:Int = -1
    var max_rid:Int = -1
    private let maxNum:Int = 10
    
    init() {
        
        //エンティティを操作するためのオブジェクトを作成する
        let viewContext = appDalegate.persistentContainer.viewContext

        //エンティティオブジェクトを作成する
        let myEntity = NSEntityDescription.entity(forEntityName: "Rireki", in: viewContext)

        let query:NSFetchRequest<Rireki> = Rireki.fetchRequest()
        query.entity = myEntity
        
        //取り出しの順番
        let sortDescripter = NSSortDescriptor(key: "resultDate", ascending: true)//ascendind:true 昇順 古い順、false 降順　新しい順
        query.sortDescriptors = [sortDescripter]
        do {
            let fetchResults = try viewContext.fetch(query)
            rirekiCount = fetchResults.count
            if(rirekiCount != 0){
                for fetch:AnyObject in fetchResults {
                    if(min_rid == -1) {
                        min_rid = (fetch.value(forKey: "r_id") as? Int)!
                    }
                    max_rid = (fetch.value(forKey: "r_id") as? Int)!
                }
                NSLog("coreDataの数\(rirekiCount)")
                NSLog("max_ridの値:\(max_rid)")
            }
        }
        catch{
            
        }
    }
    
    //==============================
    // Create
    //==============================
    func createRecord(r_id:Int, result:String, resultText:String) {
        if Constants.DEBUG == true {
            print(#function)
        }
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
        newRecord.setValue(Date(), forKey: "resultDate")
        
        //レコードの即時保存
        do {
            try viewContext.save()
            rirekiCount = rirekiCount + 1
            max_rid = r_id
        } catch {
            //エラーが発生した時に行う例外処理を書いておく
        }
        
    }
    
    //==============================
    // Read All
    //==============================
    //既に存在するデータの読み込み処理
    func readRirekiAll() -> [NSDictionary] {
        if Constants.DEBUG == true {
            print(#function)
        }
        //エンティティを操作するためのオブジェクトを作成する
        let viewContext = appDalegate.persistentContainer.viewContext
        
        //エンティティオブジェクトを作成する
        let myEntity = NSEntityDescription.entity(forEntityName: "Rireki", in: viewContext)
        
        let query:NSFetchRequest<Rireki> =  Rireki.fetchRequest()
        query.entity = myEntity
        
        //取り出しの順番
        let sortDescripter = NSSortDescriptor(key: "resultDate", ascending: false)//ascendind:true 昇順 古い順、false 降順　新しい順
        query.sortDescriptors = [sortDescripter]

        
        //データを一括取得
        do {
            
            let fetchResults = try viewContext.fetch(query)
            if( fetchResults.count != 0) {
                for fetch:AnyObject in fetchResults {
                    let r_id:Int = (fetch.value(forKey: "r_id") as? Int)!
                    let result:String = (fetch.value(forKey: "result") as? String)!
                    let resultText:String = (fetch.value(forKey: "resultText") as? String)!
                    let resultDate:NSDate = (fetch.value(forKey: "resultDate") as? NSDate)!

                    let dic =  ["r_id":r_id,"result":result,"resultText":resultText,"resultDate":resultDate] as [String : Any]
                    


                    dics.append(dic as NSDictionary)
                    
                    
                }
            }
            
        } catch  {
            print(error)
            
        }
        
        return dics
        
    }
    
    
    //==============================
    // Read 1
    //==============================
    func readRireki(r_id:Int) -> NSDictionary {
        if Constants.DEBUG == true {
            print(#function)
        }
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
                let resultDate:NSDate = (fetch.value(forKey: "resultDate") as? NSDate)!

                dic =  ["r_id":r_id,"result":result,"resultText":resultText,"resultDate":resultDate]
                
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
        if Constants.DEBUG == true {
            print(#function)
        }
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
            rirekiCount = 0

            
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
            rirekiCount = rirekiCount - 1

            
        } catch  {
            
            if Constants.DEBUG == true {
                print(#function)
                print("削除するレコードなかったよ")
            }
            
        }
        
    }
    
    //==============================
    // Edit　今回は使わないけど記述残しとく
    //==============================
    
//    func editRireki(r_id:Int, result:String, resultText:String) {
//        print(#function)
//        //エンティティを操作するためのオブジェクトを作成する
//        let viewContext = appDalegate.persistentContainer.viewContext
//
//        //どのエンティティからデータを取得してくるか設定（ToDoエンティティ）
//        let query:NSFetchRequest<Rireki> =  Rireki.fetchRequest()
//
//
//        //===== 絞り込み =====
//        let r_idPredicate = NSPredicate(format: "r_id = %d", r_id)
//        query.predicate = r_idPredicate
//
//        do {
//
//            let fetchResults = try viewContext.fetch(query)
//
//            if (fetchResults.count == 0) {
//                //なければ新規で作る
//                print(#function)
//                print("ないので作ります。")
//                createRecord(r_id: r_id, result: result, resultText: resultText)
//                return  // 作って終了する
//            }
//
//            for fetch:AnyObject in fetchResults {
//
//                //更新する対象のデータをNSManagedObjectにダウンキャスト
//                let record = fetch as! NSManagedObject
//                //値のセット
//                record.setValue(r_id, forKey: "r_id")
//                record.setValue(result, forKey: "result")
//                record.setValue(resultText, forKey: "resultText")
//
//                //レコードの即時保存
//                do {
//                    try viewContext.save()
//                } catch {
//                    //エラーが発生した時に行う例外処理を書いておく
//                    print(#function)
//                    print("保存できなかった")
//                }
//
//
//            }
//
//
//        } catch  {
//
//        }
//
//
//    }
    
    //==============================
    // 挿入 履歴maxnum件　最新に入れる
    //　戻り値：　挿入したr_id
    //==============================
    
    func insertRireki(result:String, resultText:String) -> Int {
        if Constants.DEBUG == true {
            print(#function)
        }
        let newid:Int = max_rid + 1
        
        createRecord(r_id: newid, result: result, resultText: resultText)
        if(rirekiCount > maxNum ) {
            deleteRireki(r_id: min_rid)

        }
        
        return newid
        
    }
    
}

