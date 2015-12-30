//
//  MingleChang.swift
//  camera_swift
//
//  Created by cjw on 15/12/24.
//  Copyright © 2015年 MingleChang. All rights reserved.
//

import Foundation

/**
 打印消息，如果是Debug模式则打印消息，否则不执行任何操作
 
 - Parameter message:   要打印的消息
 - Returns:N/A
 */
func MCLog(message: String, function: String = __FUNCTION__) {
    #if DEBUG
        print("\(function): \(message)")
    #endif
}