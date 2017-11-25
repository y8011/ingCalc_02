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
{
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TableViewとCellの設定
        myTableView.dataSource = self
        myTableView.delegate   = self
        myTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cellta")
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function)
        // Dispose of any resources that can be recreated.
    }
    

    //=============================
    //TableView
    //=============================
    var rirekiResult:[String] = ["result1","result2","result3","result4","result5","result6","result7","result8","result9","result10"]

    //2.行数の決定
    // numberofrowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
        
        //return rirekiResult.count
        
    }

    //3.リストに表示する文字列を決定し、表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellta", for: indexPath) as! CustomTableViewCell
        cell.button.setTitle(rirekiResult[indexPath.row], for: .normal)
        cell.button.addTarget(self, action:  #selector(cellButtonClicked(_:))
            , for: .touchUpInside)
        let wrapper = ActionCell()
        wrapper.delegate = self
        wrapper.animationStyle = .concurrent
        wrapper.wrap(cell: cell,
                     actionsLeft: [
                        {
                            let action = TextAction(action: "cell 3 -- left 1")
                            action.label.text = "Long Sentence"
                            action.label.font = UIFont.systemFont(ofSize: 12)
                            action.label.textColor = UIColor.white
                            action.backgroundColor = UIColor(red:1.00, green:0.78, blue:0.80, alpha:1.00)
                            return action
                        }(),
                        {
                            let action = IconAction(action: "cell 3 -- left 2")
                            action.icon.image = #imageLiteral(resourceName: "image_0").withRenderingMode(.alwaysTemplate)
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
                        {
                            let action = TextAction(action: "cell 3 -- right 1")
                            action.label.text = "Long Sentence"
                            action.label.font = UIFont.systemFont(ofSize: 12)
                            action.label.textColor = UIColor.white
                            action.backgroundColor = UIColor(red:0.51, green:0.83, blue:0.73, alpha:1.00)
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

