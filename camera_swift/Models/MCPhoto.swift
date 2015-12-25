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
    var title:String!
    var ctime:NSDate!
    var mtime:NSDate!
    weak var album:MCAlbum!
    
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
        
    }
    class func createTableSQL() -> String{
        return "CREATE TABLE IF NOT EXISTS photo (id integer NOT NULL PRIMARY KEY AUTOINCREMENT,albumid text NOT NULL REFERENCES photo (id) ON DELETE CASCADE ON UPDATE CASCADE, ctime timestamp, mtime timestamp)"
    }
}
