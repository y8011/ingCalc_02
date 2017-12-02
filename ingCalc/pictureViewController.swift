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
    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var myTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImageView.isUserInteractionEnabled = true  // Gestureの許可

        initScrollImage()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        
        let myIngLocalImage:ingLocalImage = ingLocalImage()
        let image = myIngLocalImage.readJpgImageInDocument(nameOfImage: "image\(passedIndex).jpg")
        detailImageView.image = image
        
        let myIngCoreData:ingCoreData = ingCoreData()
        let dic = myIngCoreData.readRireki(r_id: passedIndex)
        
        myTextView.text = dic["resultText"] as! String
        //日付を文字列に変換
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        //時差補正　日本時間
        df.locale = NSLocale(localeIdentifier: "ja_JP") as! Locale!

        self.title = df.string(from: dic["resultDate"] as! Date)
        
        updateScrollInset()

    }
    
    //==============================
    // ScrolView
    //==============================
    func initScrollImage() {
        print(#function)
        if let size = detailImageView.image?.size {
            // imageViewのサイズがscrollView内に収まるように調整
            let wrate = detailScrollView.frame.width / size.width
            let hrate = detailScrollView.frame.height / size.height
            let rate = min(wrate, hrate , 1)
            detailImageView.frame.size = CGSize(width: size.width * rate , height: size.height * rate)
            detailImageView.frame.origin = CGPoint(x: 0.0, y: 0.0)
            
            // contentSizeを画像サイズに設定
            detailScrollView.contentSize = detailImageView.frame.size
            detailScrollView.maximumZoomScale = 4.0
            detailScrollView.minimumZoomScale = 1.0
            
            detailScrollView.delegate = self
            detailScrollView.addSubview(detailImageView)
            // 初期表示のためcontentInsetを更新
            updateScrollInset()
        }
        
    }
    
    func updateScrollInset()
    {
        print(#function)
        // imageViewの大きさからcontentInsetを再計算
        // 0を下回らないようにする
        detailScrollView.contentInset = UIEdgeInsetsMake(
            max((detailScrollView.frame.height - detailImageView.frame.height)/2, 0)
            ,max((detailScrollView.frame.width - detailImageView.frame.width)/2, 0)
            , 0
            , 0
        )
        
    }
    // ズーム中に呼び出され続けるデリゲートメソッド.
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print(#function)
      updateScrollInset()
    }
    
    // ユーザがドラッグ後、指を離した際に呼び出されるデリゲートメソッド.
    // velocity = points / second.
    // targetContentOffsetは、停止が予想されるポイント？
    // pagingEnabledがYESの場合には、呼び出されません.
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(#function)
    }
    
    // ズーム中に呼び出されるデリゲートメソッド.
    // ズームの値に対応したUIViewを返却する.
    // nilを返却すると、何も起きない.
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print(#function)
        return self.detailImageView
    }
    
    // 先頭にスクロールする際に呼び出されるデリゲートメソッド.
    // NOなら反応しない.
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        print(#function)
        return true
    }

    //ズームのために要指定
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        print(#function)
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
