//
//  ViewController.swift
//  PlayRTC
//
//  Created by 默司 on 2016/9/9.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var listVC: ListViewController?
    var delegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        listVC = storyboard?.instantiateViewControllerWithIdentifier("ListVC") as? ListViewController
        
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if let userId = NSUserDefaults.standardUserDefaults().stringForKey("userId") {
            join(withUserId: userId)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func use486(sender: AnyObject) {
        join(withUserId: "486")
    }
    @IBAction func useEmilia(sender: AnyObject) {
        join(withUserId: "Emilia")
    }
    @IBAction func useRem(sender: AnyObject) {
        join(withUserId: "Rem")
    }
    
    func join(withUserId userId: String) {
        NSUserDefaults.standardUserDefaults().setValue(userId, forKey: "userId")
        delegate.setupSinch(withUserId: userId)
        self.navigationController?.pushViewController(listVC!, animated: false)
    }
}

