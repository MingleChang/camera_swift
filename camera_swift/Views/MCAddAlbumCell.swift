//
//  MCAddAlbumCell.swift
//  camera_swift
//
//  Created by cjw on 15/12/24.
//  Copyright © 2015年 MingleChang. All rights reserved.
//

import UIKit

class MCAddAlbumCell: UICollectionViewCell {
    @IBOutlet weak var addBgView: UIView!
    @IBOutlet weak var addImageView: UIImageView!
    
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
        self.addBgView.layer.cornerRadius=5
        self.addBgView.layer.borderWidth=1
        self.addBgView.layer.borderColor=UIColor(red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1.0).CGColor
    }
    private func configureData(){
        
    }
}
