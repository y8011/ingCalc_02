//
//  ingLocalImage.swift
//  ingCalc
//
//  Created by yuka on 2017/12/01.
//  Copyright © 2017年 yuka. All rights reserved.
//

import UIKit

class ingLocalImage {
    let documentDirectory =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) // [String]型
    
    func storeJpgImageInDocument(image: UIImage , name: String) {
        print(#function)

        let dataUrl = URL.init(fileURLWithPath: documentDirectory[0], isDirectory: true) //URL型 Documentpath
        
        let dataPath = dataUrl.appendingPathComponent(name) //URL型 documentへのパス + ファイル名
        print(dataPath)
        let myData = UIImageJPEGRepresentation(image, 1.0)! as NSData // Data?型　→ NSData型
        
        print(dataPath.path)
        myData.write(toFile: dataPath.path , atomically: true) // NSData型の変数.write(String型,Bool型)
    }
    
    func readJpgImageInDocument(nameOfImage: String) -> UIImage? {
        print(#function)
        let dataUrl = URL.init(fileURLWithPath: documentDirectory[0], isDirectory: true)  //URL型 Documentpath
        let dataPath = dataUrl.appendingPathComponent(nameOfImage)
        
        do {
            
            let myData = try Data(contentsOf: dataPath, options: [])
            let image =  UIImage.init(data: myData)
            
            print(image!)
            
            return image
            
        }catch {
            print(error)
            return nil
        }
        
    }
    
    func deleteJpgImageInDocument(nameOfImage: String){
        print(#function)
        var error: NSErrorPointer = nil
        let dataUrl = URL.init(fileURLWithPath: documentDirectory[0], isDirectory: true)  //URL型 Documentpath
        var dataPath = dataUrl.appendingPathComponent(nameOfImage)
        
        
        do {
            let fileManager = FileManager.default
            // Check if file exists
            print("filePath")
            print(dataPath.path)
            print("filePath")
            if fileManager.fileExists(atPath: dataPath.path) {
                // Delete file
                try fileManager.removeItem(atPath: dataPath.path)
            } else {
                print("File does not exist")
            }
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
}
