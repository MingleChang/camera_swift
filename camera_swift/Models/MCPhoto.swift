//
//  MCPhoto.swift
//  camera_swift
//
//  Created by cjw on 15/12/25.
//  Copyright © 2015年 MingleChang. All rights reserved.
//

import UIKit

class MCPhoto: NSObject {
    var id:String!
    var albumid:String!
    var ctime:NSDate!
    var mtime:NSDate!
    
    var directoryPath: String {
        get {
            return MCFilePath.directoryPathInDirectory(CAMERA_PATH, item: self.albumid)!
        }
    }
    
    var imagePath:String {
        get {
            return MCFilePath.pathInDirectory(self.directoryPath, item: self.id+".mc")
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
    
    override init() {
        super.init()
        self.id=NSUUID().UUIDString
        self.albumid=""
        self.ctime=NSDate()
        self.mtime=NSDate()
    }
    init(AlbumId albumId:String) {
        super.init()
        self.id=NSUUID().UUIDString
        self.albumid=albumId
        self.ctime=NSDate()
        self.mtime=NSDate()
    }
    init(Dictionary dic:[String : AnyObject]) {
        super.init()
        self.setValuesForKeysWithDictionary(dic)
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
extension MCPhoto{
    func toDBDictionary() -> [String : AnyObject]{
        return self.dictionaryWithValuesForKeys(MCPhoto.getAllSQLParam())
    }
    class func getAllSQLParam() -> [String] {
        return ["id","albumid","create_time","modify_time"]
    }
}

//MARK:SQL语句
extension MCPhoto{
    class func createTableSQL() -> String{
        return "CREATE TABLE IF NOT EXISTS photo (id text NOT NULL PRIMARY KEY UNIQUE,albumid text NOT NULL REFERENCES photo (id) ON DELETE CASCADE ON UPDATE CASCADE, create_time timestamp, modify_time timestamp)"
    }
    
    class func insertPhotoSQL() -> String {
        return "INSERT INTO photo(id,albumid,create_time,modify_time) VALUES (:id,:albumid,:create_time,:modify_time)"
    }
    class func updatePhotoSQL() -> String {
        return "UPDATE photo SET id=:id,albumid=:albumid,create_time=:create_time,modify_time=:modify_time WHERE id=:id"
    }
    class func selectPhotoSQL(withAlbumId albumId:String) -> String {
        return "SELECT * FROM photo WHERE albumid=" + "'" + albumId + "'";
    }
}

//MARK:
extension MCPhoto{
    class func photoArray(byResultSet resultSet:FMResultSet) -> [MCPhoto]{
        var lArray:[MCPhoto]=[]
        while resultSet.next(){
            let dic=resultSet.resultDictionary() as! [String : AnyObject]
            let photo=MCPhoto(Dictionary: dic)
            lArray.append(photo)
        }
        return lArray
    }
    
    func save(withImage image:UIImage!) -> Bool{
        let imageData=UIImageJPEGRepresentation(image, 0.9)
        let sucess=imageData!.writeToFile(self.imagePath, atomically: true)
        if(sucess==true){
            return self.save()
        }
        return false
    }
    
    func save() -> Bool {
        let sucess=MCCameraManager.shareInstance.insertPhoto(self)
        if(sucess==true){
            return true
        }else{
            return false
        }
    }
}
