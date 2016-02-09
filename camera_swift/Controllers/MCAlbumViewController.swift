//
//  MCAlbumViewController.swift
//  camera_swift
//
//  Created by cjw on 15/12/24.
//  Copyright © 2015年 MingleChang. All rights reserved.
//

import UIKit

class MCAlbumViewController: MCViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    //MARK:cell的id值
    let ALBUM_CELL_ID="MCAlbumCell"
    let ADD_ALBUM_CELL_ID="MCAddAlbumCell"
    
    let ALBUM_DETAIL_SEGUE_ID="MCAlbumDetailViewController"

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == ALBUM_DETAIL_SEGUE_ID){
            let lViewController=segue.destinationViewController as! MCAlbumDetailViewController
            lViewController.album=sender as! MCAlbum
        }
    }
}
//MARK:Override
//MARK:Init Methods
extension MCAlbumViewController{
    override func configureView() {
        super.configureView()
        self.automaticallyAdjustsScrollViewInsets=false
    }
    override func configureData() {
        super.configureData()
    }
    override func resetNavigationItem() {
        
    }
}
//MARK:Delegate
extension MCAlbumViewController{
    //MARK:UICollectionView DataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MCCameraManager.shareInstance.albums.count+1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let row=indexPath.row
        if (row == MCCameraManager.shareInstance.albums.count){
            let lCell=collectionView .dequeueReusableCellWithReuseIdentifier(ADD_ALBUM_CELL_ID, forIndexPath: indexPath) as! MCAddAlbumCell
            return lCell
        }else{
            let lAlbum=MCCameraManager.shareInstance.albums[row]
            let lCell=collectionView.dequeueReusableCellWithReuseIdentifier(ALBUM_CELL_ID, forIndexPath: indexPath) as! MCAlbumCell
            lCell.setupAlbum(lAlbum)
            return lCell
        }
    }
    //MARK:UICollectionView Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView .deselectItemAtIndexPath(indexPath, animated: true)
        let row=indexPath.row
        if (row == MCCameraManager.shareInstance.albums.count){
            
        }else{
            let lAlbum=MCCameraManager.shareInstance.albums[row]
            self.performSegueWithIdentifier(ALBUM_DETAIL_SEGUE_ID, sender: lAlbum)
        }
    }
    //MARK:UICollectionViewFlowLayout Delegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let width=MCDevice.screenWidth()/3
        return CGSizeMake(width, width)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsZero
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSizeZero
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        return CGSizeZero
    }
}