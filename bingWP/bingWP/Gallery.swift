//
//  Gallery.swift
//  bingWP
//
//  Created by 门一凡 on 16/12/2.
//  Copyright © 2016年 门一凡. All rights reserved.
//

import UIKit

class Gallery: UIViewController, UITableViewDataSource,UITableViewDelegate {

    var dateFormatter2:DateFormatter?
    var pic=[String]()
    var months = [Int]()
    var dic = [Int: [Int]]()
    var currentDate:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize
        dateFormatter2 = DateFormatter()
        dateFormatter2?.dateFormat = "yyMMdd" //链接格式
        months = []
        pic=[]
        dic = [:]
        var date=Date()
        let fileManager = FileManager.default
        
        //Visit all images
        while true {
            let id:String=(dateFormatter2?.string(from: date))!
            let imagePath = (getDirectoryPath() as NSString).appendingPathComponent("\(id).jpg")
            //判断是否在本地
            if fileManager.fileExists(atPath: imagePath){
                pic.append(id)
                if months.contains(Int(id)!/100) {
                    var tmp = dic[Int(id)!/100]
                    tmp?.append(Int(id)!)
                    dic[Int(Int(id)!/100)]=tmp
                }
                else{
                    months.append(Int(id)!/100)
                    dic[Int(id)!/100]=[Int(id)!]
                }
            }
            else{
                break
            }
            date.addTimeInterval(-24*60*60)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //0 numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return months.count
    }
    
    //1 numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return dic[months[section]]!.count
    }
    
    //2 titleForHeaderInSection
    func tableView(_ tableView: UITableView, titleForHeaderInSection section:Int) -> String? {
        return "\(2000+months[section]/100)年\(months[section]%100)月"
    }

    //3 cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:UITableViewCell=tableView.dequeueReusableCell(withIdentifier: "imageCell")! as UITableViewCell
        
        //Set Label
        var tmp=dic[months[indexPath.section]]
        let id:Int=(tmp?[indexPath.row])!
        cell.textLabel!.text="20\((id/10000))年\((id%10000/100))月\((id%100))日"
        
        //Set Image
        let imagePAth = (getDirectoryPath() as NSString).appendingPathComponent("\(id).jpg")
        cell.imageView!.image = UIImage(contentsOfFile: imagePAth)
        return cell
    }
   
    //4 didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //数据处理
        var tmp=self.dic[self.months[indexPath.section]]
        let id:String="\((tmp?[indexPath.row])!)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        currentDate = dateFormatter.date(from: id)!
        
        //设置segue
        let first = self.storyboard //当前View
        let secondView:UIViewController = first!.instantiateViewController(withIdentifier: "List")
        let secondViewController = secondView as! ListView
        secondViewController.flag=false
        secondViewController.current = currentDate
        self.present(secondView, animated: true, completion: nil)
        
    }
    
    //Get Document Directory Path :
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
