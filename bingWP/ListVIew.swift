//
//  ListVIew.swift
//  bingWP
//
//  Created by 门一凡 on 16/12/2.
//  Copyright © 2016年 门一凡. All rights reserved.
//
// 获取图片 ref：http://t.cn/RfuFkj9

/* 
 To-do
 
 */
import UIKit

class ListView: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    let dateFormatter = DateFormatter()
    let dateFormatter2 = DateFormatter()
    var imageURLString: String?
    var today: Date?
    var current: Date?
    var startDate: Date?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let displayCount=(parent as! CountingNavigationController).pushCount
//        countLabel.text=String(displayCount)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化
        dateFormatter.dateFormat = "yyyy年MM月dd日"  //Label格式
        dateFormatter2.dateFormat = "yyMMdd" //链接格式
        today = Date()
        current = Date()
        let start = "2016年09月28日"
        startDate = dateFormatter.date(from: start)!
        stepper.minimumValue=0
        stepper.maximumValue=(today?.timeIntervalSince(startDate!))!
        stepper.value=(today?.timeIntervalSince(startDate!))!
        stepper.stepValue=24*60*60
        getImage(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Ref: Get Document Directory Path :
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //Ref: Save Image At Document Directory :
    func saveImageDocumentDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("apple.jpg")
        let image = UIImage(named: "apple.jpg")
        print(paths)
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    //Ref: Get Image from Document Directory
    func getImagefromDocument(){
        let fileManager = FileManager.default
        let imagePAth = (getDirectoryPath() as NSString).appendingPathComponent("apple.jpg")
        if fileManager.fileExists(atPath: imagePAth){
            self.Image.image = UIImage(contentsOfFile: imagePAth)
        }else{
            print("No Image")
        }
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
                let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(self.dateFormatter2.string(from: self.current!)).jpg")
                let image = UIImage(data: data)
                print(paths)
                let imageData = UIImageJPEGRepresentation(image!, 1)
                fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
            }
        }
    }
    
    //加载图片
    func getImage(_ sender: AnyObject?) {
        currentDate.text = dateFormatter.string(from: current!)
        let id=dateFormatter2.string(from: current!)

        let fileManager = FileManager.default
        let imagePAth = (getDirectoryPath() as NSString).appendingPathComponent("\(id).jpg")
        
        //判断是否在本地
        if fileManager.fileExists(atPath: imagePAth){
            self.Image.image = UIImage(contentsOfFile: imagePAth)
        }
        else{
            imageURLString = "https://d.menyifan.com/bingWallpaper/\(id).jpg"
            if let checkedUrl = URL(string: imageURLString!) {
                downloadImage(url: checkedUrl)
            }
        }
        
    }
    
    //计步器修改
    @IBAction func stepperChanged(_ sender: AnyObject) {
        current = startDate?.addingTimeInterval(stepper.value)
        getImage(nil)
    }
    
    //保存到相册
    @IBAction func saveButt(_ sender: AnyObject) {
        let imageData = UIImageJPEGRepresentation(Image.image!, 1)
        let compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
        let alert = UIAlertView(title: "Congratulations!",
                                message: "This image has been saved to Camera Roll!",
                                delegate: nil,
                                cancelButtonTitle: "Ok")
        alert.show()
    }
    
    
    @IBOutlet weak var butt: UIButton!
    @IBAction func sizeChange(_ sender: AnyObject) {
        if self.Image.contentMode == .scaleAspectFit {
            self.Image.contentMode = .scaleAspectFill
            butt.setTitle("Fit", for: UIControlState.normal)
        }
        else{
            self.Image.contentMode = .scaleAspectFit
            butt.setTitle("Fill", for: UIControlState.normal)
        }
    }
    
    
}

