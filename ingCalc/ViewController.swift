//
//  ViewController.swift
//  ingCalc
//
//  Created by yuka on 16/11/2017.
//  Copyright © 2017 yuka. All rights reserved.
//

import UIKit
import CalculatorKeyboard
import Photos
import MobileCoreServices

class ViewController: UIViewController, CalculatorDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var displayImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = CGRect(x:0 , y:0 , width: UIScreen.main.bounds.width, height:300 )
        let keyboard = CalculatorKeyboard(frame: frame)
        keyboard.delegate = self
        keyboard.showDecimal = true
        inputText.inputView = keyboard
        // inputText.text = "0"
        
        displayImageView.isUserInteractionEnabled = true  // Gestureの許可
        
    
    }
    
    func calculator(_ calculator: CalculatorKeyboard, didChangeValue value: String) {
        inputText.text = value
    }
    
    //===============================
    //ジェスチャー
    //===============================
    @IBAction func longPressImageView(_ sender: UILongPressGestureRecognizer) {
        
        display()
    }
    
    @IBAction func tapImageView(_ sender: UITapGestureRecognizer) {
        print("TAP")
    }
    
    
    
    //===============================
    // カメラ
    //===============================
    func openPhoto() {
        save()
    }
    
    
    func display() {
        
        print("display")
        // UserDefaultから取り出す
        let myDefault = UserDefaults.standard
        
        //データを取り出す
        let strURL = myDefault.string(forKey: "selectedPhotoURL")
        
        if strURL != nil {
            
            let url = URL(string: strURL as String!)
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)  // fetchResult変更
            
            let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
            let manager: PHImageManager = PHImageManager()
            manager.requestImage(for: asset, targetSize: CGSize(width: 5, height: 500), contentMode: .aspectFill, options: nil, resultHandler: { ( image , info) -> Void in self.displayImageView.image = image
                
            })
            
        }
    }
    


    
    func save() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            //写真ライブラリ（カメラロール）表示用のViewControllerを宣言
            let controller = UIImagePickerController()
            
            controller.delegate = self
            //新しく宣言したViewControllerでカメラとカメラロールのどちらを表示するかを指定
            controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //トリミング
            controller.allowsEditing = true
            //新たに追加したカメラロール表示ViewControllerをpresetViewControllerにする
            self.present(controller, animated: true,completion: nil)
            
        }
    }
    
    //カメラロールで写真を選んだ後
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        
        
        //        let assetURL:AnyObject = info[UIImagePickerControllerReferenceURL]! as AnyObject
        let assetURL:AnyObject = info[UIImagePickerControllerPHAsset]! as AnyObject  // コーションが出たので変更。

        let strURL:String = assetURL.description
        
        print(strURL)
        
        
        // ユーザーデフォルトを用意する
        let myDefault = UserDefaults.standard
        
        // データを書き込んで
        myDefault.set(strURL, forKey: "selectedPhotoURL")
        
        // 即反映させる
        myDefault.synchronize()
        
        
        
        //閉じる処理
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

