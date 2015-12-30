//
//  MCAddAlbumViewController.swift
//  camera_swift
//
//  Created by cjw on 15/12/25.
//  Copyright © 2015年 MingleChang. All rights reserved.
//

import UIKit

class MCAddAlbumViewController: MCViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumTitleText: UITextField!
    
    var isSelectImage=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    }
    override func configureData() {
        super.configureData()
    }
    override func resetNavigationItem() {
        super.resetNavigationItem()
        let lSaveBarButtonItem=UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Done, target: self, action: "saveBarButtonItemClick:")
        self.navigationItem.rightBarButtonItem=lSaveBarButtonItem
    }

}

//MARK:Events Response
extension MCAddAlbumViewController{
    func saveBarButtonItemClick(sender:UIBarButtonItem){
        self.saveAlbum()
    }
    @IBAction func imageViewTap(sender: UITapGestureRecognizer) {
        self.tapImageView()
    }
}

extension MCAddAlbumViewController{
    func tapImageView(){
        self.albumTitleText.resignFirstResponder()
        func albumActionBlock(action:UIAlertAction){
            let lViewController=UIImagePickerController()
            lViewController.delegate=self
            lViewController.allowsEditing = true;
            lViewController.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(lViewController, animated: true, completion: nil)
        }
        func cameraActionBlock(action:UIAlertAction){
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
                let lViewController=UIImagePickerController()
                lViewController.delegate=self
                lViewController.allowsEditing = true;
                lViewController.sourceType=UIImagePickerControllerSourceType.Camera
                self.presentViewController(lViewController, animated: true, completion: nil)
            }
        }
        let lAlertController=UIAlertController(title: "选择图片", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let lAlbumAction=UIAlertAction(title: "相册", style: UIAlertActionStyle.Default, handler: albumActionBlock)
        let lCameraAction=UIAlertAction(title: "相机", style: UIAlertActionStyle.Default, handler: cameraActionBlock)
        let lCancelAction=UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        lAlertController.addAction(lAlbumAction)
        lAlertController.addAction(lCameraAction)
        lAlertController.addAction(lCancelAction)
        self .presentViewController(lAlertController, animated: true, completion: nil)
    }
    
    func saveAlbum(){
        self.albumTitleText.resignFirstResponder()
        if let title=self.checkTitle(){
            let lAlbum=MCAlbum()
            lAlbum.title=title
            lAlbum.save(withImage: (self.isSelectImage ? self.albumImageView.image:nil))
            MCCameraManager.shareInstance.albums.append(lAlbum)
            self.navigationController!.popViewControllerAnimated(true)
        }else{
            
        }
    }
    
    func checkTitle() -> String?{
        if let title=self.albumTitleText.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()){
            if(title.characters.count==0){
                return nil
            }
            return title
        }else{
            return nil
        }
    }
}

//MARK:Delegate
extension MCAddAlbumViewController{
    //MARK:UIImagePickerController Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let lImage=info["UIImagePickerControllerEditedImage"] as! UIImage
        self.albumImageView.image=lImage
        self.isSelectImage=true
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker .dismissViewControllerAnimated(true, completion: nil)
    }
}