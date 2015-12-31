//
//  MCPhotoCell.swift
//  camera_swift
//
//  Created by cjw on 15/12/31.
//  Copyright © 2015年 MingleChang. All rights reserved.
//

import UIKit

class MCPhotoCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }
    
    //MARK:Init Methods
    private func configure(){
        self.configureView()
        self.configureData()
    }
    private func configureView(){
        
    }
    private func configureData(){
        
    }

}

extension MCPhotoCell{
    func setupPhoto(photo:MCPhoto){
        
    }
}