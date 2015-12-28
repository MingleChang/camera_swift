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
    
    var directoryPath: String {
        get {
            return MCFilePath.directoryPathInDirectory(MCCameraManager.shareInstance.cameraPath, item: self.id)!
        }
    }
    
    override init() {
        super.init()
        self.id=NSUUID().UUIDString
        self.title=""
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
        return "UPDATE Notepad SET id=:id,title=:title,create_time=:create_time,modify_time=:modify_time WHERE id=:id"
    }
    class func selectAlbumSQL() -> String {
        return "SELECT * FROM album";
    }
}

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
    
    func save() -> Bool {
        let sucess=MCCameraManager.shareInstance.insertAlbum(self)
        return sucess
    }
    
    func update() -> Bool {
        let sucess=MCCameraManager.shareInstance.updateAlbum(self)
        return sucess
    }
}
