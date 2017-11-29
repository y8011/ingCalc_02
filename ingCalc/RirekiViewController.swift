//
//  RirekiViewController.swift
//  ingCalc
//
//  Created by yuka on 2017/11/20.
//  Copyright © 2017年 yuka. All rights reserved.
//

import UIKit
import ActionCell           // アクションセル

class RirekiViewController: UIViewController
    ,UITableViewDelegate
    ,UITableViewDataSource
//    ,ActionCellDelegate
{
    
    @IBOutlet weak var myTableView: UITableView!
  //  var myActionCell:ActionCell = ActionCell()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TableViewとCellの設定
        myTableView.dataSource = self
        myTableView.delegate   = self
        myTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cellta")
        
    //    myActionCell.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        myTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function)
        // Dispose of any resources that can be recreated.
    }
    

    //=============================
    //TableView
    //=============================
    //2.行数の決定
    // numberofrowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let myIngCore:ingCore = ingCore()

        return myIngCore.rirekiCount
        
        //return rirekiResult.count
        
    }

    //3.リストに表示する文字列を決定し、表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let myIngCore:ingCore = ingCore()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellta", for: indexPath) as! CustomTableViewCell
        //let count:Int = rirekiTexts.count - indexPath.row - 1

       // cell.button.setTitle(rirekiTexts[count], for: .normal)
        let rirekiForCell = myIngCore.readRireki(r_id: indexPath.row)
        print("rirekiForCell:\(rirekiForCell)")
        cell.button.setTitle((rirekiForCell["resultText"] as! String), for: .normal)
        cell.button.addTarget(self, action:  #selector(cellButtonClicked(_:))
            , for: .touchUpInside)
        
        let wrapper = ActionCell()
        wrapper.delegate = self
        wrapper.animationStyle = .concurrent
        wrapper.wrap(cell: cell,
                     actionsLeft: [

                        {
                            let action = IconAction(action: "Delete" )
                            action.icon.image = #imageLiteral(resourceName: "image_8").withRenderingMode(.alwaysTemplate)
                            action.icon.tintColor = UIColor.white
                            action.backgroundColor = UIColor(red:0.51, green:0.83, blue:0.73, alpha:1.00)
                            return action
                        }(),
                        ],
                     actionsRight: [
                        {
                            let action = IconTextAction(action: "cell 3 -- right 0")
                            action.icon.image = #imageLiteral(resourceName: "image_1").withRenderingMode(.alwaysTemplate)
                            action.icon.tintColor = UIColor.white
                            action.label.text = "Hello"
                            action.label.font = UIFont.systemFont(ofSize: 12)
                            action.label.textColor = UIColor.white
                            action.backgroundColor = UIColor(red:0.14, green:0.69, blue:0.67, alpha:1.00)
                            return action
                        }(),


                        ])
        return cell
    }
    
    //addTargetでselector通じて引数を渡すことはできない。それ自身を渡すことならできる
    //なので、テキストラベルに入っているボタンを渡すことにする
    @objc func cellButtonClicked(_ sender: UIButton) {
       // self.output.text = "cell button clicked"
        print(#function)
        let myPasteBoard = UIPasteboard.general
        myPasteBoard.string = sender.titleLabel?.text as! String
        print(sender.description)
        print(sender.titleLabel?.text as! String)
    }

    
    //=============================
    // Alert
    //=============================
    func alertAction1(s_title:String, s_message:String, s_action:String){
        
        //部品となるアラート
        let alert = UIAlertController(
            title: s_title ,
            message: s_message,
            preferredStyle: .alert
        )
        
        //ボタンを増やしたいときは、addActionをもう一つ作ればよい
        alert.addAction(
            UIAlertAction(
                title: s_action,
                style: .default,
                handler: nil)
        )
        
        //アラートを表示
        present(alert,
                animated: true,
                completion: nil
        )
        
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


extension RirekiViewController: ActionCellDelegate {
    
    var tableView: UITableView! {
        return myTableView
        
    }
    
    
    public func didActionTriggered(cell: UITableViewCell, action: String) {
        print(#function)
        print(action)
    }
}

// ActionCell用
class CustomTableViewCell: UITableViewCell {
    
    var button: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        button = {
            let the = UIButton()
            the.setTitle("click me", for: .normal)
            the.setTitleColor(UIColor.white, for: .normal)
            the.backgroundColor = UIColor.brown
            return the
        }()
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 300))
        contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearActionsheet()
    }
}

