//
//  MCViewController.swift
//  camera_swift
//
//  Created by cjw on 15/12/24.
//  Copyright © 2015年 MingleChang. All rights reserved.
//

import UIKit

class MCViewController: UIViewController {
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
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
    
    //MARK:Init Methods
    private func configure(){
        self.configureView()
        self.configureData()
    }
    internal func configureView(){
        
    }
    internal func configureData(){
        
    }

}
