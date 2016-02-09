//
//  MCCameraViewController.swift
//  camera_swift
//
//  Copyright © 2016年 MingleChang. All rights reserved.
//

import UIKit

class MCCameraViewController: MCViewController {

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
}

//MARK:Event Response
extension MCCameraViewController{
    @IBAction func cameraButtonClick(sender: UIButton) {
    }
    
    @IBAction func backButtonClick(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

//MARK:Override
//MARK:Init Methods
extension MCCameraViewController{
    override func configureView() {
        super.configureView()
    }
    override func configureData() {
        super.configureData()
    }
    override func resetNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func resetNavigationItem() {
        
    }
}