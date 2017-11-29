//
//  ViewController.swift
//  ingCalc
//
//  Created by yuka on 16/11/2017.
//  Copyright © 2017 yuka. All rights reserved.
//

import UIKit
import CalculatorKeyboard   // 計算機用
import Photos               // 写真用
import CoreData


var rirekiResult:[String] = []
var rirekiTexts:[String] = []
var rirekiNum:Int = -1

class ViewController: UIViewController
, CalculatorDelegate
, UIImagePickerControllerDelegate
, UINavigationControllerDelegate
,UIScrollViewDelegate
{

    @IBOutlet weak var inputText: UITextField!
    //@IBOutlet weak var displayImageView: UIImageView!
    var displayImageView: UIImageView = UIImageView()
    @IBOutlet weak var myScrollView: UIScrollView!
    

    // 計算機
    var keyboard:CalculatorKeyboard = CalculatorKeyboard()
    var resultText:String = ""
    var suuji:String = ""

    
    //===============================
    // viewDidLoad
    //===============================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCalc()
        
        displayImageView = UIImageView(image: UIImage(named: "Red-kitten.jpg"))
        displayImageView.isUserInteractionEnabled = true  // Gestureの許可
        displayImageView.backgroundColor = UIColor.black
        initScrollImage()

        displayImageView.isUserInteractionEnabled = true  // Gestureの許可
        displayImageView.contentMode = UIViewContentMode.scaleAspectFit
        
    
    }
    
    //===============================
    // viewDidAppear
    //===============================
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputText.becomeFirstResponder()   //計算機
    }
    
    
    //===============================
    // 計算機
    //===============================
    func calculator(_ calculator: CalculatorKeyboard, didChangeValue value: String, KeyType: Int) {
        inputText.text = value
        let myIngCore:ingCore = ingCore()

        switch KeyType {
        case CalculatorKey.multiply.rawValue ... CalculatorKey.add.rawValue:
            if KeyType == CalculatorKey.multiply.rawValue {
                resultText = resultText + "\(suuji)x"
            }
            else if KeyType == CalculatorKey.divide.rawValue {
                resultText = resultText + "\(suuji)/"
            }
            else if KeyType == CalculatorKey.subtract.rawValue {
                resultText = resultText + "\(suuji)-"
            }
            else if KeyType == CalculatorKey.add.rawValue {
                resultText = resultText + "\(suuji)+"
            }
            
        case CalculatorKey.equal.rawValue :
            resultText = resultText + "\(suuji) = \(value)"
            if(myIngCore.rirekiCount >= 10 ) {
                rirekiNum = rirekiNum + 1
                
            }
            else{
                //myIngCore.createRecord(r_id: rirekiNum, result: value, resultText: resultText)
            }
            myIngCore.insertRireki(result: value, resultText: resultText)

            rirekiTexts.append(resultText)
            rirekiResult.append(value)
            resultText = ""
            
            let dics = myIngCore.readRirekiAll()
            print(dics)
            
        case CalculatorKey.clear.rawValue:
            print("けされたぁ")
            resultText = ""
            myIngCore.deleteRirekiAll()
            
        default:
            break
            
        }
        
        suuji = value
       // print(value)
        //print(resultText)
    }
    
    func initCalc() {
        let frame = CGRect(x:0 , y:0 , width: UIScreen.main.bounds.width, height:300 )
        keyboard = CalculatorKeyboard(frame: frame)

        
        keyboard.delegate = self
        keyboard.showDecimal = true
        inputText.inputView = keyboard
        

    }
    
    //===============================
    // ジェスチャー
    //===============================
    @IBAction func longPressImageView(_ sender: UILongPressGestureRecognizer) {
        showAlbum()
    }
    
    

    
    //===============================
    // カメラボタン
    //===============================
    @IBAction func tapCameraBarButton(_ sender: UIBarButtonItem) {
        showCamera()
        
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
            
            let asset: PHAsset = (fetchResult.firstObject as! PHAsset)
            let manager: PHImageManager = PHImageManager()
            let size = myScrollView.frame.size
            
            manager.requestImage(for: asset, targetSize: size , contentMode: .aspectFit, options: nil, resultHandler: { ( image , info) -> Void in
                self.displayImageView.image = image!
                 // print(image!)
                  print(info!)
                print("[myScrollView.frame.size]↓")
                print(size)
                print(self.myScrollView.center)
                
            })
            // 初期表示のためcontentInsetを更新
            updateScrollInset()
        }
    }
    
    func showCamera() {
        print(#function)
        //カメラボタンが使えるかどうか判別するための情報を取得（列挙体）
        //意味のわかる言葉に置き換え。中身はenumで数字で作ってる
        let camera = UIImagePickerControllerSourceType.camera

        //カメラが使える場合　撮影モードの画面を表示
        //クラス名.メソッド名　で使えるメソッド＝型メソッド
        if UIImagePickerController.isSourceTypeAvailable(camera) {
            let picker = UIImagePickerController()
            
            //カメラモードに設定
            picker.sourceType = camera
            
            //デリゲートの設定（撮影後のメソッドを感知するため）
            picker.delegate = self
            
            //撮影モード画面の表示（モーダル）
            present(picker, animated: true, completion: nil)
            
            
        }
        
    
    }


    func showAlbum(){
        
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
    

    //カメラロールで写真を選んだ後発動
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        
        print(#function)
        //for camera
        // UIImagePickerControllerReferenceURL はカメラロールを選択した時だけ存在するので切り分け。
        if (info.index(forKey: UIImagePickerControllerReferenceURL) == nil) {
            //imageViewに撮影した写真をセットするために変数に保存する
            let takenimage = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            //画面上のimageViewに設定
            displayImageView.image = takenimage
            
            //自分のデバイス（プログラムが動いている場所）に写真を保存（カメラロール）
            UIImageWriteToSavedPhotosAlbum(takenimage, nil, nil, nil)
            
            updateScrollInset()

            //モーダルで表示した撮影モード画面を閉じる（前の画面に戻る）
            dismiss(animated: true, completion: nil)
            
        }
        else {
            //for photolibrary
            let assetURL:AnyObject = info[UIImagePickerControllerReferenceURL]! as AnyObject
            print("didFinishPickingMediaWithInfo")
            print(assetURL) //assets-library://asset/asset.JPG?id=9F983DBA-EC35-42B8-8773-B597CF782EDD&ext=JPG
            
            print(info[UIImagePickerControllerMediaType]!) //public.image
            print(info[UIImagePickerControllerOriginalImage]!)//<UIImage: 0x60c0000b9f20> size {3000, 2002} orientation 0 scale 1.000000
                                                            //info[UIImagePickerControllerOriginalImage] as? UIImageにするとそのままUIImageを取得できます。

            let strURL:String = assetURL.description
            print("----  ")
            print(strURL) //assets-library://asset/asset.JPG?id=ED7AC36B-A150-4C38-BB8C-B6D696F4F2ED&ext=JPG
            
            // ユーザーデフォルトを用意する
            let myDefault = UserDefaults.standard
            
            // データを書き込んで
            myDefault.set(strURL, forKey: "selectedPhotoURL")
            
            // 即反映させる
            myDefault.synchronize()
            
            
           // display()  画質が悪くなるので削除
            let takenimage = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            //画面上のimageViewに設定
            displayImageView.image = takenimage
            updateScrollInset()

            //閉じる処理
            imagePicker.dismiss(animated: true, completion: nil)
        }
        
    }
    

    //==============================
    // ScrolView
    //==============================
    func initScrollImage() {
        print("initScrollImage")
        if let size = displayImageView.image?.size {
            // imageViewのサイズがscrollView内に収まるように調整
            let wrate = myScrollView.frame.width / size.width
            let hrate = myScrollView.frame.height / size.height
            let rate = min(wrate, hrate , 1)
            displayImageView.frame.size = CGSize(width: size.width * rate , height: size.height * rate)
            displayImageView.frame.origin = CGPoint(x: 0.0, y: 0.0)
            
            // contentSizeを画像サイズに設定
            myScrollView.contentSize = displayImageView.frame.size
            myScrollView.maximumZoomScale = 4.0
            myScrollView.minimumZoomScale = 1.0
            
            myScrollView.delegate = self
            myScrollView.addSubview(displayImageView)
            // 初期表示のためcontentInsetを更新
            updateScrollInset()
        }
        
    }
    
    func updateScrollInset()
    {
        // imageViewの大きさからcontentInsetを再計算
        // 0を下回らないようにする
        myScrollView.contentInset = UIEdgeInsetsMake(
            max((myScrollView.frame.height - displayImageView.frame.height)/2, 0)
            ,max((myScrollView.frame.width - displayImageView.frame.width)/2, 0)
            , 0
            , 0
        )
        
    }
    
    // スクロール中に呼び出され続けるデリゲートメソッド.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(#function)
    }
    
    // ズーム中に呼び出され続けるデリゲートメソッド.
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateScrollInset()
    }
    
    // ユーザが指でドラッグを開始した場合に呼び出されるデリゲートメソッド.
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print(#function)
    }
    
    // ユーザがドラッグ後、指を離した際に呼び出されるデリゲートメソッド.
    // velocity = points / second.
    // targetContentOffsetは、停止が予想されるポイント？
    // pagingEnabledがYESの場合には、呼び出されません.
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(#function)
    }
    
    // ユーザがドラッグ後、指を離した際に呼び出されるデリゲートメソッド.
    // decelerateがYESであれば、慣性移動を行っている.
    //
    // 指をぴたっと止めると、decelerateはNOになり、
    // その場合は「scrollViewWillBeginDecelerating:」「scrollViewDidEndDecelerating:」が呼ばれない？
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("[displayImageView.center]↓")
        print(displayImageView.center)
//        displayImageView.center = scrollView.center
//        print(#function)
//        print(displayImageView.center)
    }
    
    // ユーザがドラッグ後、スクロールが減速する瞬間に呼び出されるデリゲートメソッド.
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print(#function)
    }
    
    // ユーザがドラッグ後、慣性移動も含め、スクロールが停止した際に呼び出されるデリゲートメソッド.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(#function)
    }
    
    // スクロールのアニメーションが終了した際に呼び出されるデリゲートメソッド.
    // アニメーションプロパティがNOの場合には呼び出されない.
    // 【setContentOffset】/【scrollRectVisible:animated:】
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print(#function)
    }
    
    // ズーム中に呼び出されるデリゲートメソッド.
    // ズームの値に対応したUIViewを返却する.
    // nilを返却すると、何も起きない.
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print(#function)
        return self.displayImageView
    }
    
    // ズーム開始時に呼び出されるデリゲートメソッド.
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        print(#function)
    }
    
    // ズーム完了時(バウンドアニメーション完了時)に呼び出されるデリゲートメソッド.
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print(#function)
    }
    
    // 先頭にスクロールする際に呼び出されるデリゲートメソッド.
    // NOなら反応しない.
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        print(#function)
        return true
    }
    
    // 先頭へのスクロールが完了した際に呼び出されるデリゲートメソッド.
    // すでに先頭にいる場合には呼び出されない.
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print(#function)
    }
    
    
    //ズームのために要指定
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        print(#function)
        // ズームのために要指定
        return displayImageView
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

