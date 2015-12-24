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
}
