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
        self.dbQueue=FMDatabaseQueue(path:DB_PATH)
        self.createTable()
        self.albums=self.selectAlbum()
        MCLog(CAMERA_PATH)
    }
    
    var dbQueue:FMDatabaseQueue!
    var albums:[MCAlbum]!
}

//MARK:SQL
//MARK:创建表
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

//MARK:Album的相关SQL操作
extension MCCameraManager{
    func selectAlbum() -> [MCAlbum]{
        var lResults:[MCAlbum]=[]
        func block(db:FMDatabase!){
            do{
                let lResultSet=try db.executeQuery(MCAlbum.selectAlbumSQL(), values: nil)
                lResults=MCAlbum.albumArray(byResultSet: lResultSet)
            }catch{
                
            }
        }
        self.dbQueue.inDatabase(block)
        return lResults
    }
    func insertAlbum(album:MCAlbum) -> Bool{
        var success=false
        func block(db:FMDatabase!){
            success=db.executeUpdate(MCAlbum.insertAlbumSQL(), withParameterDictionary: album.toDBDictionary())
        }
        self.dbQueue.inDatabase(block)
        return success
    }
    func updateAlbum(album:MCAlbum) -> Bool{
        var success=false
        func block(db:FMDatabase!){
            success=db.executeUpdate(MCAlbum.updateAlbumSQL(), withParameterDictionary: album.toDBDictionary())
        }
        self.dbQueue.inDatabase(block)
        return success
    }
}

//MARK:Photo的相关SQL操作
extension MCCameraManager{
    func selectPhoto(inAlbumId albumId:String) -> [MCPhoto]{
        var lResults:[MCPhoto]=[]
        func block(db:FMDatabase!){
            do{
                let lResultSet=try db.executeQuery(MCPhoto.selectPhotoSQL(withAlbumId: albumId), values: nil)
                lResults=MCPhoto.photoArray(byResultSet: lResultSet)
            }catch{
                
            }
        }
        self.dbQueue.inDatabase(block)
        return lResults
    }
    
    func insertPhoto(photo:MCPhoto) -> Bool {
        var success=false
        func block(db:FMDatabase!){
            success=db.executeUpdate(MCPhoto.insertPhotoSQL(), withParameterDictionary: photo.toDBDictionary())
        }
        self.dbQueue.inDatabase(block)
        return success
    }
}
