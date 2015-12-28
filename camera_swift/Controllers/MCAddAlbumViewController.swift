//
//  MCAddAlbumViewController.swift
//  camera_swift
//
//  Created by cjw on 15/12/25.
//  Copyright © 2015年 MingleChang. All rights reserved.
//

import UIKit

class MCAddAlbumViewController: MCViewController {

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

extension MCAddAlbumViewController{
    func saveBarButtonItemClick(sender:UIBarButtonItem){
        print("保存")
    }
    @IBAction func imageViewTap(sender: UITapGestureRecognizer) {
        print("点击")
    }
}