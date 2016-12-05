//
//  ListVIew.swift
//  bingWP
//
//  Created by 门一凡 on 16/12/2.
//  Copyright © 2016年 门一凡. All rights reserved.
//
// 获取图片 ref：http://t.cn/RfuFkj9

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
    var flag:Bool=true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ListView.tappedMe))
        Image.addGestureRecognizer(tap)
        Image.isUserInteractionEnabled = true
        
        //初始化
        dateFormatter.dateFormat = "yyyy年MM月dd日"  //Label格式
        dateFormatter2.dateFormat = "yyMMdd" //链接格式
        today = Date()
        if flag {
            current = Date()
        }
        
        let start = "2016年09月28日"
        startDate = dateFormatter.date(from: start)!
        stepper.minimumValue=0
        stepper.maximumValue=(today?.timeIntervalSince(startDate!))!
        stepper.value=(current?.timeIntervalSince(startDate!))!
        stepper.stepValue=24*60*60
        getImage(nil)
        flag=true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Get Document Directory Path :
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
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
                // 同时Save Image At Document Directory
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
    
    
    //轻触手势
    func tappedMe(){
        if Image.contentMode == .scaleAspectFill {
            Image.contentMode = .scaleAspectFit
        }
        else{
            Image.contentMode = .scaleAspectFill
        }
    }
}

