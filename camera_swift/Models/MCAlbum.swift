//
//  MCAlbum.swift
//  camera_swift
//
//  Created by cjw on 15/12/24.
//  Copyright © 2015年 MingleChang. All rights reserved.
//

import UIKit

class MCAlbum: NSObject {
    var id:String!
    var title:String!
    var ctime:NSDate!
    var mtime:NSDate!
    
    var isSave:Bool!
    
    var directoryPath: String {
        get {
            return MCFilePath.directoryPathInDirectory(CAMERA_PATH, item: self.id)!
        }
    }
    
    var imagePath:String {
        get {
            return MCFilePath.pathInDirectory(CAMERA_PATH, item: self.id+".mc")
        }
    }
    
    var image:UIImage {
        get{
            let image=UIImage(contentsOfFile: self.imagePath)
            if let validImage = image{
                return validImage
            }else{
                return UIImage(named: "album_default")!
            }
        }
    }
    
    var videoPath:String {
        get {
            return MCFilePath.pathInDirectory(VIDEO_PATH, item: self.id+".mp4")
        }
    }
    
    override init() {
        super.init()
        self.id=NSUUID().UUIDString
        self.title=""
        self.ctime=NSDate()
        self.mtime=NSDate()
        
        self.isSave=false
    }
    init(Dictionary dic:[String : AnyObject]) {
        super.init()
        self.setValuesForKeysWithDictionary(dic)
        
        self.isSave=true
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        if(key == "create_time"){
            self.ctime=NSDate(timeIntervalSince1970: value as! NSTimeInterval)
        }
        if(key == "modify_time"){
            self.mtime=NSDate(timeIntervalSince1970: value as! NSTimeInterval)
        }
    }
    override func valueForUndefinedKey(key: String) -> AnyObject? {
        if(key == "create_time"){
            return self.ctime.timeIntervalSince1970
        }
        if(key == "modify_time"){
            return self.mtime.timeIntervalSince1970
        }
        return nil
    }
}

//MAKR:
extension MCAlbum{
    func toDBDictionary() -> [String : AnyObject]{
        return self.dictionaryWithValuesForKeys(MCAlbum.getAllSQLParam())
    }
    class func getAllSQLParam() -> [String] {
        return ["id","title","create_time","modify_time"]
    }
}
//MARK:SQL语句
extension MCAlbum{
    class func createTableSQL() -> String {
        return "CREATE TABLE IF NOT EXISTS album (id text NOT NULL PRIMARY KEY UNIQUE,title text,create_time timestamp,modify_time timestamp)"
    }
    class func insertAlbumSQL() -> String {
        return "INSERT INTO album(id,title,create_time,modify_time) VALUES (:id,:title,:create_time,:modify_time)"
    }
    class func updateAlbumSQL() -> String {
        return "UPDATE album SET id=:id,title=:title,create_time=:create_time,modify_time=:modify_time WHERE id=:id"
    }
    class func selectAlbumSQL() -> String {
        return "SELECT * FROM album";
    }
}

//MARK:
extension MCAlbum{
    class func albumArray(byResultSet resultSet:FMResultSet) -> [MCAlbum]{
        var lArray:[MCAlbum]=[]
        while resultSet.next(){
            let dic=resultSet.resultDictionary() as! [String : AnyObject]
            let album=MCAlbum(Dictionary: dic)
            lArray.append(album)
        }
        return lArray
    }
    
    func save(withImage image:UIImage?) -> Bool{
        if let validImage = image{
            let imageData=UIImageJPEGRepresentation(validImage, 0.9)
            let sucess=imageData!.writeToFile(self.imagePath, atomically: true)
            if(sucess==true){
                return self.save()
            }
        }else{
            return self.save()
        }
        
        return false
    }
    
    func save() -> Bool {
        if(self.isSave==false){
            let sucess=MCCameraManager.shareInstance.insertAlbum(self)
            if(sucess==true){
                self.isSave=true
                return true
            }else{
                return false
            }
        }else{
            let sucess=MCCameraManager.shareInstance.updateAlbum(self)
            return sucess
        }
    }
}
