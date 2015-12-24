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
    private override init(){
        super.init()
    }
    
    let cameraPath=MCFilePath.directoryPathInDocument("Camera")!
    let dbPath=MCFilePath.pathInDirectory(MCCameraManager.shareInstance.cameraPath, item: "camera.sqlite")
}
