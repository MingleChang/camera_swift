//
//  MCFilePath.swift
//  camera_swift
//
//  Created by cjw on 15/12/24.
//  Copyright © 2015年 MingleChang. All rights reserved.
//

import UIKit

///文件路径相关
class MCFilePath: NSObject {
    //MARK:用户获取路径
    class func homePath() -> String {
        return NSHomeDirectory()
    }
    class func documentPath() -> String {
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
    }
    class func libraryPath() -> String {
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
    }
    class func cachePath() ->String {
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
    }
    class func tmpPath() -> String {
        return NSTemporaryDirectory()
    }
    class func pathInHome(item:String) -> String{
        return self.pathInDirectory(self.homePath(), item: item)
    }
    class func pathInDocument(item:String) -> String {
        return self.pathInDirectory(self.documentPath(), item: item)
    }
    class func pathInLibrary(item:String) -> String {
        return self.pathInDirectory(self.libraryPath(), item: item)
    }
    class func pathInCache(item:String) -> String {
        return self.pathInDirectory(self.cachePath(), item: item)
    }
    class func pathInTmp(item:String) -> String {
        return self.pathInDirectory(self.tmpPath(), item: item)
    }
    class func pathInDirectory(directoryPath:String,item:String) ->String {
        return directoryPath.stringByAppendingPathComponent(item)
    }
    //MARK:用户获取文件夹路径，如果文件夹不存在则创建，如果创建失败将返回nil说明没有该文件夹,创建前会先删除同名文件
    class func directoryPathInHome(item:String) -> String? {
        return self.directoryPathInDirectory(self.homePath(), item: item)
    }
    class func directoryPathInDocument(item:String) -> String? {
        return self.directoryPathInDirectory(self.documentPath(), item: item)
    }
    class func directoryPathInLibrary(item:String) -> String? {
        return self.directoryPathInDirectory(self.libraryPath(), item: item)
    }
    class func directoryPathInCache(item:String) -> String? {
        return self.directoryPathInDirectory(self.cachePath(), item: item)
    }
    class func directoryPathInTmp(item:String) -> String? {
        return self.directoryPathInDirectory(self.tmpPath(), item: item)
    }
    class func directoryPathInDirectory(directoryPath:String,item:String) -> String? {
        return self.createDirectory(directoryPath.stringByAppendingPathComponent(item))
    }
    class func createDirectory(path:String) -> String? {
        var isDirectory=ObjCBool(false)
        let isExists=NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDirectory)
        if isExists{
            if !isDirectory.boolValue{
                do{
                    try NSFileManager.defaultManager().removeItemAtPath(path)
                    try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
                    return path
                }catch{
                    return nil
                }
            }else{
                return path
            }
        }else{
            do{
                try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
                return path
            }catch{
                return nil
            }
        }
    }
}
