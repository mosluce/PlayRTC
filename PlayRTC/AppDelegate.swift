//
//  AppDelegate.swift
//  PlayRTC
//
//  Created by 默司 on 2016/9/9.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var sinchClient: SINClient!
    var sinchPush: SINManagedPush!
    var call: SINCall!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        sinchPush = Sinch.managedPushWithAPSEnvironment(SINAPSEnvironment.Development)
        sinchPush?.delegate = self
        sinchPush?.setDesiredPushTypeAutomatically()
        sinchPush?.registerUserNotificationSettings()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate: SINClientDelegate, SINManagedPushDelegate, SINCallClientDelegate, SINMessageClientDelegate {
    
    
    func setupSinch(withUserId userId: String) {
        
        if sinchClient != nil {
            return
        }
        
        sinchClient = Sinch.clientWithApplicationKey(Env.SinchAppKey,
                                       applicationSecret: Env.SinchAppSecret,
                                       environmentHost: Env.SinchHost,
                                       userId: userId)
        
        
        sinchClient.delegate = self
        sinchClient.messageClient().delegate = self
        sinchClient.callClient().delegate = self
        
        sinchClient.setSupportCalling(true)
        sinchClient.setSupportMessaging(true)
        sinchClient.enableManagedPushNotifications()
        
        sinchClient.start()
        sinchClient.startListeningOnActiveConnection()
    }
    
    func logoutSinch() {
        sinchClient.terminate()
        sinchClient = nil
    }
    
    //MARK: Client
    func clientDidStart(client: SINClient!) {
        print("\(sinchClient.userId) :: clientDidStart")
    }
    
    func clientDidStop(client: SINClient!) {
        print("\(sinchClient.userId) :: clientDidStop")
    }
    
    func clientDidFail(client: SINClient!, error: NSError!) {
        print("\(sinchClient.userId) :: clientDidFail :: \(error.description)")
    }
    
    //MARK: CallClient
    func client(client: SINCallClient!, didReceiveIncomingCall call: SINCall!) {
        print("\(sinchClient.userId) :: didReceiveIncomingCall :: \(call.remoteUserId)")
        NSNotificationCenter.defaultCenter().postNotificationName("SINCH_RECEIVE_INCOMING_CALL", object: call, userInfo: nil)
    }
    
    func client(client: SINCallClient!, localNotificationForIncomingCall call: SINCall!) -> SINLocalNotification! {
        let notification = SINLocalNotification()
        notification.alertAction = "Answer"
        notification.alertBody = "Incoming Call"
        return notification
    }
    
    //MARK: MessageClient
    func messageClient(messageClient: SINMessageClient!, didReceiveIncomingMessage message: SINMessage!) {
        print("\(sinchClient.userId) :: didReceiveIncomingMessage :: \(message.text)")
    }
    
    func messageDelivered(info: SINMessageDeliveryInfo!) {
        print("\(sinchClient.userId) :: messageDelivered")
    }
    
    func messageSent(message: SINMessage!, recipientId: String!) {
        print("\(sinchClient.userId) :: messageSent :: to \(recipientId)")
    }
    
    func messageFailed(message: SINMessage!, info messageFailureInfo: SINMessageFailureInfo!) {
        print("\(sinchClient.userId) :: messageFailed :: \(messageFailureInfo.description)")
    }
    
    //MARK: Push
    func managedPush(managedPush: SINManagedPush!, didReceiveIncomingPushWithPayload payload: [NSObject : AnyObject]!, forType pushType: String!) {
        print(payload)
    }
}

