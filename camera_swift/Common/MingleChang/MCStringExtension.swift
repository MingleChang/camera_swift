//
//  MCStringExtension.swift
//  camera_swift
//
//  Created by cjw on 15/12/24.
//  Copyright © 2015年 MingleChang. All rights reserved.
//

import UIKit

extension String{
    //MARK:转换为基本数据类型
    /**
    将String类型转换转换为Int类型
    
    - Parameter N/A
    - Returns:Int    String转换后的Int值
    */
    func toInt()->Int{
        return Int(self.toDouble())
    }
    /**
     将String类型转换转换为CGFloat类型
     
     - Parameter N/A
     - Returns:CGFloat    String转换后的CGFloat值
     */
    func toCGFloat()->CGFloat{
        return CGFloat(self.toDouble())
    }
    /**
     将String类型转换转换为Double类型
     
     - Parameter N/A
     - Returns:Double    String转换后的Double值
     */
    func toDouble()->Double{
        let lValue=Double(self)
        if (lValue != nil){
            return lValue!
        }else{
            return 0
        }
    }
    
    func stringByAppendingPathComponent(str:String) -> String{
        return self.stringByAppendingFormat("/%@", str)
    }
}
