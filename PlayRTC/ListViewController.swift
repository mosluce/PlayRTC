//
//  ListViewController.swift
//  PlayRTC
//
//  Created by 默司 on 2016/9/12.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, SINCallDelegate, UITableViewDataSource, UITableViewDelegate {

    weak var callClient: SINCallClient!
    
    var users = ["486", "Emilia", "Rem"]
    var userId: String!
    var call: SINCall?
    
    var alertController: UIAlertController?
    
    var hangupAction: UIAlertAction!
    var answerAction: UIAlertAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.sinchClient
        
        callClient = client.callClient()
        
        userId = client.userId
        users.removeAtIndex(users.indexOf(userId)!)
        
        hangupAction = UIAlertAction(title: "Hangup", style: .Cancel, handler: { [unowned self] (action) in
            self.call?.hangup()
            self.alertController?.dismissViewControllerAnimated(true, completion: nil)
        })
        
        answerAction = UIAlertAction(title: "Answer", style: .Default, handler: { [unowned self] (action) in
            self.call?.answer()
            self.alertController?.dismissViewControllerAnimated(true, completion: nil)
        })
        
        NSNotificationCenter.defaultCenter().addObserverForName("SINCH_RECEIVE_INCOMING_CALL", object: nil, queue: nil) { [unowned self] (notification) in
            let call = notification.object as! SINCall
            
            call.delegate = self
            
            self.call = call
            self.showAlert("來電通知", message: "\(call.remoteUserId) 正在撥打電話給您", actions: [self.answerAction, self.hangupAction])
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = userId
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(ListViewController.exit(_:)))
    }
    
    func exit(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userId")
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell")
        let user = users[indexPath.row]
        
        cell?.textLabel?.text = user
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let userId = users[indexPath.row]
        
        call = callClient.callUserWithId(userId)
        call?.delegate = self
        
        showAlert("正在撥打", message: "給 \(userId)", actions: [hangupAction])
    }
    
    func showAlert(title:String, message: String, actions: [UIAlertAction]) {
        self.alertController?.dismissViewControllerAnimated(true, completion: nil)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        
        for action in actions {
            alertController.addAction(action)
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
        self.alertController = alertController
    }
    
    func callDidAddVideoTrack(call: SINCall!) {
        print("\(userId) callDidAddVideoTrack")
    }
    
    func callDidProgress(call: SINCall!) {
        print("\(userId) callDidProgress (\(call.state.rawValue))")
    }
    
    func callDidEstablish(call: SINCall!) {
        print("\(userId) callDidEstablish (\(call.state.rawValue))")
        showAlert("通話中", message: "與\(call.remoteUserId)", actions: [hangupAction])
    }
    
    func callDidEnd(call: SINCall!) {
        alertController?.dismissViewControllerAnimated(true, completion: nil)
        
        print("\(userId) callDidEnd (\(call.state.rawValue))")
    }
    
    func call(call: SINCall!, shouldSendPushNotifications pushPairs: [AnyObject]!) {
        print(111)
    }
    
}
