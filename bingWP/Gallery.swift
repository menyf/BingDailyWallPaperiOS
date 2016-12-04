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
    var yourArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dateFormatter2 = DateFormatter()
        dateFormatter2?.dateFormat = "yyMMdd" //链接格式
        months = []
        pic=[]
        dic = [:]
        var date=Date()
        let fileManager = FileManager.default
        
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

    //0
    func numberOfSections(in tableView: UITableView) -> Int {
        return months.count
    }
    
    //1
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return dic[months[section]]!.count
    }
    
    //2
    func tableView(_ tableView: UITableView, titleForHeaderInSection section:Int) -> String? {
        return "\(2000+months[section]/100)年\(months[section]%100)月"
    }
    
    
    //3
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:UITableViewCell=tableView.dequeueReusableCell(withIdentifier: "imageCell")! as UITableViewCell
        
        var tmp=dic[months[indexPath.section]]
        let id:Int=(tmp?[indexPath.row])!
        cell.textLabel!.text="20\((id/10000))年\((id%10000/100))月\((id%100))日"
        
        let fileManager = FileManager.default
        let imagePAth = (getDirectoryPath() as NSString).appendingPathComponent("\(id).jpg")
        if fileManager.fileExists(atPath: imagePAth){
            cell.imageView!.image = UIImage(contentsOfFile: imagePAth)
        }else{
//            debug.text="No image \(id!).jpg"
        }
    
        return cell
    }
    
    //4
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
/*
        var flowerMessage:String
        switch indexPath.section {
        case kRedSection:
            flowerMessage="You chose the red flower - \(redFlowers[indexPath.row])"
        case kBlueSection:
            flowerMessage="You chose the blue flower - \(blueFlowers[indexPath.row])"
        default:
            flowerMessage="I have no idea what you chose?!"
        }
        
        let alertController=UIAlertController(title: "Flower Selected", message: flowerMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction=UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
        
 */
//        let tmp = UIStoryboardSegue(identifier: <#T##String?#>, source: <#T##UIViewController#>, destination: <#T##UIViewController#>, performHandler: <#T##() -> Void#>)
//        
//        present(tmp, animated: true, completion: nil)
        
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

}
