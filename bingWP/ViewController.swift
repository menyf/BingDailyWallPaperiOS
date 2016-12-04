//
//  ViewController.swift
//  bingWP
//
//  Created by 门一凡 on 16/12/2.
//  Copyright © 2016年 门一凡. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Image: UIImageView!
    var dateFormatter2 = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyMMdd" //链接格式
        let id=dateFormatter2.string(from: Date())
        let fileManager = FileManager.default
        let imagePAth = (getDirectoryPath() as NSString).appendingPathComponent("\(id).jpg")
        
        //判断是否在本地
        if fileManager.fileExists(atPath: imagePAth){
            Image.image = UIImage(contentsOfFile: imagePAth)
        }
        else{
            let imageURLString = "https://d.menyifan.com/bingWallpaper/\(id).jpg"
            if let checkedUrl = URL(string: imageURLString) {
                downloadImage(url: checkedUrl)
            }
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //获取数据
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    //下载图片
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                self.Image.image = UIImage(data: data)
                // 同时下载到本地
                let fileManager = FileManager.default
                let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(self.dateFormatter2.string(from: Date())).jpg")
                let image = UIImage(data: data)
                print(paths)
                let imageData = UIImageJPEGRepresentation(image!, 1)
                fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
            }
        }
    }
    
    //Ref: Get Document Directory Path :
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    @IBAction func exitToHere(_ sender: UIStoryboardSegue) {
    }
    
    
}

