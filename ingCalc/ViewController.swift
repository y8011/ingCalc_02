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
        

        //初回は写真表示させずに行く。
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
//
//            //写真ライブラリ（カメラロール）表示用のViewControllerを宣言
//            let controller = UIImagePickerController()
//
//            controller.delegate = self
//            //新しく宣言したViewControllerでカメラとカメラロールのどちらを表示するかを指定
//            controller.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
//            //トリミング
//            controller.allowsEditing = true
//            //新たに追加したカメラロール表示ViewControllerをpresetViewControllerにする
//            self.present(controller, animated: true,completion: nil)
//
//        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputText.becomeFirstResponder()
    }
    
    
    func calculator(_ calculator: CalculatorKeyboard, didChangeValue value: String) {
        inputText.text = value
    }
    
    //===============================
    //ジェスチャー
    //===============================
    @IBAction func longPressImageView(_ sender: UILongPressGestureRecognizer) {
        showAlbum()
        display()
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
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)  // TODO:fetchResult変更
            
            let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
            let manager: PHImageManager = PHImageManager()
            manager.requestImage(for: asset, targetSize: CGSize(width: 5, height: 500), contentMode: .aspectFill, options: nil, resultHandler: { ( image , info) -> Void in self.displayImageView.image = image
                
            })
            
        }
    }
    
    func showCamera() {
        print("showCamera")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let picker = UIImagePickerController()
            picker.modalPresentationStyle = UIModalPresentationStyle.popover
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary

            if let popover = picker.popoverPresentationController {
                popover.sourceView = self.view
                popover.sourceRect = displayImageView.frame
                popover.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            self.present(picker, animated: true, completion: nil)
        }
    }


    func showAlbum(){
        print("showAlbum")
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            //インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion:  nil)


        }
    }


    
    func save() {
        print("save()")
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

        
        
                let assetURL:AnyObject = info[UIImagePickerControllerReferenceURL]! as AnyObject
        let imageURL:AnyObject = info[UIImagePickerControllerImageURL]! as AnyObject  // コーションが出たので変更。
        print("didFinishPickingMediaWithInfo")
        print(assetURL) //assets-library://asset/asset.JPG?id=9F983DBA-EC35-42B8-8773-B597CF782EDD&ext=JPG
        print(imageURL) /* file:///Users/yuka/Library/Developer/CoreSimulator/Devices/C679ECF0-0655-4785-B09B-88591EE5E4EA/data/Containers/Data/Application/ADC1DCAE-A8EA-4827-9BCB-BD60D8CB6F8F/tmp/E86756F3-585B-4A3B-BA78-EDE39ECA010E.jpeg */
        
        print(info[UIImagePickerControllerMediaType]!) //public.image
        //print(info[UIImagePickerControllerMediaMetadata]!)
        print(info[UIImagePickerControllerOriginalImage]!)//<UIImage: 0x60c0000b9f20> size {3000, 2002} orientation 0 scale 1.000000
                                                        //info[UIImagePickerControllerOriginalImage] as? UIImageにするとそのままUIImageを取得できます。
        //print(info[UIImagePickerControllerEditedImage])//<UIImage: 0x6080000bb9c0> size {1242, 1242} orientation 0 scale 1.000000
        //print(info[UIImagePickerControllerMediaURL]!)
        //print(info[UIImagePickerControllerCropRect]!)

        let strURL:String = assetURL.description
        let strURL2:String = imageURL.description
        print("----  ")
        print(strURL) //assets-library://asset/asset.JPG?id=ED7AC36B-A150-4C38-BB8C-B6D696F4F2ED&ext=JPG
        print(strURL2)  //file:///Users/yuka/Library/Developer/CoreSimulator/Devices/C679ECF0-0655-4785-B09B-88591EE5E4EA/data/Containers/Data/Application/5D53066C-49C3-4176-A1AB-AD1C828A7AA5/tmp/07108CE3-7A7E-46C1-88F2-36B25DB5877D.jpeg
        
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

