//
//  MCCameraManager.swift
//  camera_swift
//
//  Created by cjw on 15/12/24.
//  Copyright © 2015年 MingleChang. All rights reserved.
//

import UIKit

class MCCameraManager: NSObject {
    //MARK:单例
    static let shareInstance=MCCameraManager()
    override init(){
        super.init()
        self.cameraPath=MCFilePath.directoryPathInDocument("Camera")!
        self.dbPath=MCFilePath.pathInDirectory(self.cameraPath, item: "camera.sqlite")
        self.dbQueue=FMDatabaseQueue(path:self.dbPath)
//        self.createTable()
    }
    
    var cameraPath:String!
    var dbPath:String!
    var dbQueue:FMDatabaseQueue!
}

extension MCCameraManager{
    func createTable(){
        func block(db:FMDatabase!,rollback:UnsafeMutablePointer<ObjCBool>){
            do{
                try db.executeUpdate(MCAlbum.createTableSQL(), values: nil)
                try db.executeUpdate(MCPhoto.createTableSQL(), values: nil)
                db.inTransaction()
            }catch{
                db.rollback()
            }
        }
        self.dbQueue.inTransaction(block)
    }
}
