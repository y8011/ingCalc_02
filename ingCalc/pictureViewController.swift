//
//  pictureViewController.swift
//  ingCalc
//
//  Created by yuka on 2017/12/02.
//  Copyright © 2017年 yuka. All rights reserved.
//

import UIKit

class pictureViewController: UIViewController
    ,UIScrollViewDelegate
{

    var passedIndex:Int = -1
    
    @IBOutlet weak var detailImageView: UIImageView!
    //var detailImageView: UIImageView!
    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var myNavigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImageView.isUserInteractionEnabled = true  // Gestureの許可

        myNavigationBar.titleTextAttributes
            = [NSAttributedStringKey.font: UIFont(name: "Menlo", size: 16)!]
        

    }

    override func viewWillAppear(_ animated: Bool) {
        if Constants.DEBUG == true {
            print(#function)
        }

        
        let myIngCoreData:ingCoreData = ingCoreData()
        let dic = myIngCoreData.readRireki(r_id: passedIndex)
        
        myTextView.text = dic["resultText"] as! String
        //日付を文字列に変換
        let df = DateFormatter()
        df.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        df.dateStyle = .long
        df.timeStyle = .short

        df.doesRelativeDateFormatting = true

        myNavigationBar.topItem?.title = df.string(from: dic["resultDate"] as! Date)

    }
    
    //===============================
    // viewDidAppear
    //===============================
    var onetime:Bool = false
    override func viewDidAppear(_ animated: Bool) {
        print(#function)
        super.viewDidAppear(animated)
        if onetime == false {
            let myIngLocalImage:ingLocalImage = ingLocalImage()
            let image = myIngLocalImage.readJpgImageInDocument(nameOfImage: "image\(passedIndex).jpg")
            detailImageView.image = image
            initScrollImage()
            onetime = true
        }
    }

    //=================================
    //ジェスチャー系。タップ
    //=================================
    //ツールバーの中のシェアボタンが押された時
    @IBAction func tapShare(_ sender: UIBarButtonItem) {
        //シェア用画面（インスタンス）の作成
        let controller = UIActivityViewController(activityItems: [detailImageView.image!,myTextView.text], applicationActivities: nil)
        
        //シェア用画面を表示
        present(controller, animated: true, completion: nil)
    }
    
    

    @IBAction func tapBack(_ sender: UIBarButtonItem) {

    }
    
    //==============================
    // ScrolView
    //==============================
    func initScrollImage() {
        if Constants.DEBUG == true {
            print(#function)
            print("rireki:\(detailImageView.image?.size)")
            print("rireki:\(detailImageView.frame)")
        }
        
        if let size = detailImageView.image?.size {
            // imageViewのサイズがscrollView内に収まるように調整
            let wrate = detailScrollView.frame.width / size.width
            let hrate = detailScrollView.frame.height / size.height
            let rate = min(wrate, hrate)
            print(rate)
            detailImageView.frame.size = CGSize(width: size.width * rate , height: size.height * rate)
            detailImageView.frame.origin = CGPoint(x: 0.0, y: 0.0)
            
            // contentSizeを画像サイズに設定
            detailScrollView.contentSize = detailImageView.frame.size
            detailScrollView.maximumZoomScale = 4.0
            detailScrollView.minimumZoomScale = 1.0

            print("detailScrollView:\(detailScrollView.frame)")
            print("contentSize:\(detailScrollView.contentSize)")
            print("detailImageView:\(detailImageView.frame)")

            detailScrollView.delegate = self
           //StoryBoadでされてる detailScrollView.addSubview(detailImageView)
            // 初期表示のためcontentInsetを更新
            updateScrollInset()
        }
        
    }
    
    func updateScrollInset()
    {
        if Constants.DEBUG == true {
            print(#function)
        }
        
        // imageViewの大きさからcontentInsetを再計算
        // 0を下回らないようにする
//        detailScrollView.contentInset = UIEdgeInsetsMake(
//            max((detailScrollView.frame.height - detailImageView.frame.height)/2, 0)
//            ,max((detailScrollView.frame.width - detailImageView.frame.width)/2, 0)
//            , 0
//            , 0
//        )
        
        print(detailScrollView.contentOffset)
        print(detailScrollView.contentInset)
        print(detailImageView.frame)
        
    }
    
    // スクロール中に呼び出され続けるデリゲートメソッド.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Constants.DEBUG == true {
            print(#function)
        }
    }
    
    // ズーム中に呼び出され続けるデリゲートメソッド.
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if Constants.DEBUG == true {
            print(#function)
        }
      updateScrollInset()
    }
    
    // ユーザが指でドラッグを開始した場合に呼び出されるデリゲートメソッド.
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if Constants.DEBUG == true {
            print(#function)
        }
    }
    
    // ユーザがドラッグ後、指を離した際に呼び出されるデリゲートメソッド.
    // velocity = points / second.
    // targetContentOffsetは、停止が予想されるポイント？
    // pagingEnabledがYESの場合には、呼び出されません.
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if Constants.DEBUG == true {
            print(#function)
        }
    }

    // ユーザがドラッグ後、指を離した際に呼び出されるデリゲートメソッド.
    // decelerateがYESであれば、慣性移動を行っている.
    //
    // 指をぴたっと止めると、decelerateはNOになり、
    // その場合は「scrollViewWillBeginDecelerating:」「scrollViewDidEndDecelerating:」が呼ばれない？
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if Constants.DEBUG == true {
            print(#function)
            print("[displayImageView.center]↓")
            print(detailImageView.center)
        }
    }
    
    // ユーザがドラッグ後、スクロールが減速する瞬間に呼び出されるデリゲートメソッド.
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if Constants.DEBUG == true {
            print(#function)
        }
    }
    
    // ユーザがドラッグ後、慣性移動も含め、スクロールが停止した際に呼び出されるデリゲートメソッド.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if Constants.DEBUG == true {
            print(#function)
        }
    }
    
    // スクロールのアニメーションが終了した際に呼び出されるデリゲートメソッド.
    // アニメーションプロパティがNOの場合には呼び出されない.
    // 【setContentOffset】/【scrollRectVisible:animated:】
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if Constants.DEBUG == true {
            print(#function)
        }
    }
    
    // ズーム中に呼び出されるデリゲートメソッド.
    // ズームの値に対応したUIViewを返却する.
    // nilを返却すると、何も起きない.
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if Constants.DEBUG == true {
            print(#function)
            print(detailScrollView.frame)
            print(detailImageView.frame)
        }
        return self.detailImageView
    }
    
    // ズーム完了時(バウンドアニメーション完了時)に呼び出されるデリゲートメソッド.
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if Constants.DEBUG == true {
            print(#function)
        }
    }
    
    // 先頭にスクロールする際に呼び出されるデリゲートメソッド.
    // NOなら反応しない.
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if Constants.DEBUG == true {
            print(#function)
        }
        return true
    }

    //ズームのために要指定
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        if Constants.DEBUG == true {
            print(#function)
        }
        // ズームのために要指定
        return detailImageView
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
