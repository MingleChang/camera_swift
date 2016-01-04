//
//  MCAlbumDetailViewController.swift
//  camera_swift
//
//  Created by cjw on 15/12/31.
//  Copyright © 2015年 MingleChang. All rights reserved.
//

import UIKit

class MCAlbumDetailViewController: MCViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //MARK:cell的id值
    let PHOTO_CELL_ID="MCPhotoCell"
    let ADD_PHOTO_CELL_ID="MCAddPhotoCell"
    
    
    var album:MCAlbum!
    var photos:[MCPhoto]!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK:Override
    //MARK:Init Methods
    override func configureView() {
        super.configureView()
        self.automaticallyAdjustsScrollViewInsets=false
    }
    override func configureData() {
        super.configureData()
        self.photos=MCCameraManager.shareInstance.selectPhoto(inAlbumId: self.album.id)
    }
    override func resetNavigationItem() {
        super.resetNavigationItem()
        let lSaveBarButtonItem=UIBarButtonItem(title: "生成", style: UIBarButtonItemStyle.Done, target: self, action: "createBarButtonItemClick:")
        self.navigationItem.rightBarButtonItem=lSaveBarButtonItem
    }
}

//MARK:Events Response
extension MCAlbumDetailViewController{
    func createBarButtonItemClick(sender:UIBarButtonItem){
        var imageArray:[UIImage]=[]
        for i in 0 ... self.photos.count-1 {
            let photo=self.photos[i]
            let image=photo.image
            imageArray.append(image)
        }
        MCImagesToVideo.writeImageAsMovie(imageArray, path: self.album.videoPath, size: CGSizeMake(640, 640), fps: 2, shouldAnimateTransitions: true) { (success:Bool) -> Void in
            if success{
                MCLog("Complete")
            }else{
                MCLog("Failed")
            }
            
        }
        MCLog("Over")
    }
}


//MARK:Delegate
extension MCAlbumDetailViewController{
    //MARK:UICollectionView DataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count+1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let row=indexPath.row
        if (row == self.photos.count){
            let lCell=collectionView .dequeueReusableCellWithReuseIdentifier(ADD_PHOTO_CELL_ID, forIndexPath: indexPath) as! MCAddPhotoCell
            return lCell
        }else{
            let lPhoto=self.photos[row]
            let lCell=collectionView.dequeueReusableCellWithReuseIdentifier(PHOTO_CELL_ID, forIndexPath: indexPath) as! MCPhotoCell
            lCell.setupPhoto(lPhoto)
            return lCell
        }
    }
    //MARK:UICollectionView Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView .deselectItemAtIndexPath(indexPath, animated: true)
        let row=indexPath.row
        if (row == self.photos.count){
            let lViewController=UIImagePickerController()
            lViewController.delegate=self
            lViewController.allowsEditing = true;
            lViewController.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(lViewController, animated: true, completion: nil)
        }else{
            
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


//TODD:目前先从相册中获取图片，之后删除，改为自定义拍照
extension MCAlbumDetailViewController{
    //MARK:UIImagePickerController Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let lImage=info["UIImagePickerControllerEditedImage"] as! UIImage
        let photo=MCPhoto(AlbumId: self.album.id)
        photo.save(withImage: lImage)
//        self.albumImageView.image=lImage
//        self.isSelectImage=true
        self.photos.append(photo)
        self.collectionView.reloadData()
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}