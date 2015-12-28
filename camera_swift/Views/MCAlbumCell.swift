//
//  MCAlbumCell.swift
//  camera_swift
//
//  Created by cjw on 15/12/24.
//  Copyright © 2015年 MingleChang. All rights reserved.
//

import UIKit

class MCAlbumCell: UICollectionViewCell {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!

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
extension MCAlbumCell{
    func setupAlbum(album:MCAlbum){
        self.albumTitleLabel.text=album.title
    }
}