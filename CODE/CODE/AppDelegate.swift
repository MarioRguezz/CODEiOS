 //
 //  AppDelegate.swift
 //  CODE
 //
 //  Created by Mario Alberto Negrete Rodríguez & Oscar Barrera Casillas  on 19/04/16.
 //  Copyright © 2016 CODE. All rights reserved.
 //  APP DELEGATE  play video, local notification, google sign in, drawer navigation controller
 
 import UIKit
 import FBSDKCoreKit
 import FBSDKLoginKit
 import Alamofire
 import AVKit
 import AVFoundation
 import Firebase
 import FirebaseMessaging
 import SafariServices
 import RealmSwift
 
 var fullNameGoogle = ""
 var mailGoogle = ""
 var launchVideo = false

 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    var window: UIWindow? = Window()
    var centerContainer: MMDrawerController?
    
    let networkHandler = NetworkHandler.sharedInstance
    let urlVideo = "http://app.codegto.gob.mx/code_web/src/res/video/video.mp4"//""http://192.168.1.64:81/prueba.mp4
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let completeAction = UIMutableUserNotificationAction()
        completeAction.identifier = "COMPLETE_TODO" // the unique identifier for this action
        completeAction.title = "Hecho" // title for the action button
        completeAction.activationMode = .Background // UIUserNotificationActivationMode.Background - don't bring app to foreground
        completeAction.authenticationRequired = false // don't require unlocking before performing action
        completeAction.destructive = true // display action in red
    
        let remindAction = UIMutableUserNotificationAction()
        remindAction.identifier = "REMIND"
        remindAction.title = "Recordar en 5 min"
        remindAction.activationMode = .Background
        remindAction.destructive = false

        let todoCategory = UIMutableUserNotificationCategory() // notification categories allow us to create groups of actions that we can associate with a notification
        todoCategory.identifier = "TODO_CATEGORY"
        todoCategory.setActions([remindAction, completeAction], forContext: .Default) // UIUserNotificationActionContext.Default (4 actions max)
        todoCategory.setActions([completeAction, remindAction], forContext: .Minimal) // UIUserNotificationActionContext.Minimal - for when space is limited (2 actions max)
        
        
        let viewAction = UIMutableUserNotificationAction()
        viewAction.identifier = "VIEW_IDENTIFIER"
        viewAction.title = "View"
        viewAction.activationMode = .Foreground
        
        let urlCategory = UIMutableUserNotificationCategory()
        urlCategory.identifier = "URL_CATEGORY"
        urlCategory.setActions([viewAction], forContext: .Default)
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: [todoCategory,urlCategory])
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        
        // Override point for customization after application launch.
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        FBSDKLoginButton.classForCoder()
        
        
        // Handle notification
        if (launchOptions != nil) {
            
            // For local Notification
            if let localNotificationInfo = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
                 launchVideo = true
                
                
            } else
                
                // For remote Notification
                if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as! [NSObject : AnyObject]? {
                    
                    if let something = remoteNotification["gcm.notification.link_url"] as? String {
                        let nsurl = NSURL(string: something)!
                        UIApplication.sharedApplication().openURL(nsurl)
                    }
                    
            }
            
        }
        
        
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(
            UIApplicationBackgroundFetchIntervalMinimum)
        
        FIRApp.configure()
        
//        if #available(iOS 8.0, *) {
//            // [START register_for_notifications]
//            
//            
//            let viewAction = UIMutableUserNotificationAction()
//            viewAction.identifier = "VIEW_IDENTIFIER"
//            viewAction.title = "View"
//            viewAction.activationMode = .Foreground
//            
//            let urlCategory = UIMutableUserNotificationCategory()
//            urlCategory.identifier = "URL_CATEGORY"
//            urlCategory.setActions([viewAction], forContext: .Default)
//            
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: [urlCategory])
//            application.registerUserNotificationSettings(settings)
//            application.registerForRemoteNotifications()
//            // [END register_for_notifications]
//        } else {
//            // Fallback
//            let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
//            application.registerForRemoteNotificationTypes(types)
//        }
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.tokenRefreshNotification),
                                                         name: kFIRInstanceIDTokenRefreshNotification, object: nil)
        
        //  return true
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        let item = TodoItem(deadline: notification.fireDate!, title: notification.userInfo!["title"] as! String, UUID: notification.userInfo!["UUID"] as! String!)
        switch (identifier!) {
        case "COMPLETE_TODO":
            TodoList.sharedInstance.removeItem(item)
            
        case "REMIND":
            TodoList.sharedInstance.scheduleReminderforItem(item)
        default: // switch statements must be exhaustive - this condition should never be met
            print("Error: unexpected notification action identifier!")
        }
        completionHandler() // per developer documentation, app will terminate if we fail to call this
    }
    
    //play a video if receive a notification
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print(notification.category)
        if notification.category == "TODO_CATEGORY" {
            do {
                try playVideo()
                firstAppear = false
            } catch AppError.InvalidResource(let name, let type) {
               // debugPrint("Could not find resource \(name).\(type)")
            } catch {
              //  debugPrint("Generic error")
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName("TodoListShouldRefresh", object: self)
    }
    
    func playVideo() throws {
        
        let filePath = localFilePathForUrl(urlVideo)?.path
        
        
        let player = AVPlayer(URL: NSURL(fileURLWithPath: filePath!))
        let playerController = AVPlayerViewController()
        playerController.player = player
        if let wd = self.window {
            var vc = wd.rootViewController
            if(vc is UINavigationController){
                vc = (vc as! UINavigationController).visibleViewController
            }
             
            
            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(filePath!) {
                vc!.presentViewController(playerController, animated: true) {
                    player.play()
                    launchVideo = false
                }
               // print("FILE AVAILABLE")
            }else{
                
             /*   vc!.presentViewController(MessageVideo(), animated: true){
                    aqui
                }*/
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("MessageVideo") as! MessageVideo
                let centerNav = UINavigationController(rootViewController: nextViewController)
                self.window?.rootViewController = centerNav
                
              //  print("FILE NOT AVAILABLE")
            }
        }
        
        
        
    }
    
    
    
    func application(application: UIApplication,
                     openURL url: NSURL,
                             sourceApplication: String?,
                             annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
    //show the container with menu
    func didLogin() -> UIViewController {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let leftViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LeftSideViewController") as! LeftSideViewController
        let centerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        
        let centerNav = UINavigationController(rootViewController: centerViewController)
        
        centerContainer = MMDrawerController(centerViewController: centerNav, leftDrawerViewController: leftViewController)
        
        centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView;
        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView;
        
        return centerContainer!;
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        
        if(url.absoluteString!.containsString("fb")){
            let sourceApplication: String? = options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: nil)
        }else{
            return GIDSignIn.sharedInstance().handleURL(url,
                                                        sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                        annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
        }
    }
    
    
    //Connection with the server to verify if the user exists. If the user uses his type of login he will get in GOOGLE
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            // let userId = user.userID                  // For client-side use only!
            //    let idToken = user.authentication.idToken // Safe to send to the server
            fullNameGoogle = user.profile.name
            //print ("User name \(fullNameGoogle)")
            //   let givenName = user.profile.givenName
            //    let familyName = user.profile.familyName
            mailGoogle  = user.profile.email
            //print ("Email  \(mailGoogle)")
            // [START_EXCLUDE]
            NSNotificationCenter.defaultCenter().postNotificationName(
                "ToggleAuthUINotification",
                object: nil,
                userInfo: ["statusText": "Signed in user:\n\(fullNameGoogle)"])
            // [END_EXCLUDE]
            //print (" .\(mailGoogle).")
            var inserted = 0
            var id_login = ""
            Alamofire.request(.POST, "http://app.codegto.gob.mx/code_web/src/app_php/login/loginGoogle.php", parameters: ["correo": mailGoogle ])
                .responseJSON { response in switch response.result {
                case .Success(let JSON):
                   // print("Success with JSON: \(JSON)")
                    let response = JSON as! NSDictionary
                    //print (".\(response).")
                    if let id_login = response.objectForKey("id_login_app") as? String {
                       // print ("\(id_login)")
                        if id_login == "-1" {
                            self.publica("Este usuario inicia con otro tipo de acceso")
                        }else{
                            inserted = response.objectForKey("inserted")! as! Int
                            if inserted == 1 {
                                googlesave = "1"
                                correosave = mailGoogle
                                //print(mailGoogle)
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("NuevoUsuario") as! NuevoUsuario
                                let centerNav = UINavigationController(rootViewController: nextViewController)
                                self.window?.rootViewController = centerNav
                            } else{
                                
                                
                                //extra
                                if NSUserDefaults.standardUserDefaults().objectForKey("DemoWalk")  == nil {
                                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                    let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("WalkController") as! WalkController2
                                    let centerNav = UINavigationController(rootViewController: nextViewController)
                                    self.window?.rootViewController = centerNav
                                    //self.presentViewController(centerNav, animated:true, completion:nil)
                                }
                                
                                
                                let id_login_app = response.objectForKey("id_login_app")! as! String
                                let a = response.objectForKey("correo")! as! String
                                let b = response.objectForKey("facebook")! as! String
                                let c = response.objectForKey("google")! as! String
                               // print (" .\(a).")
                                dict["id_login_app"] = id_login_app
                                dict["correo"] = a
                                dict["facebook"] = b
                                dict["google"] = c
                                self.window?.rootViewController =  self.didLogin()
                            }
                        }
                        
                    }
                    else{
                        inserted = response.objectForKey("inserted")! as! Int
                        if inserted == 1 {
                            googlesave = "1"
                            correosave = mailGoogle
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("NuevoUsuario") as! NuevoUsuario
                            let centerNav = UINavigationController(rootViewController: nextViewController)
                            self.window?.rootViewController =  centerNav
                        } else{
                            let id_login_app = response.objectForKey("id_login_app")! as! String
                            let a = response.objectForKey("correo")! as! String
                            let b = response.objectForKey("facebook")! as! String
                            let c = response.objectForKey("google")! as! String
                            dict["id_login_app"] = id_login_app
                            //print (" .\(a).")
                            dict["correo"] = a
                            dict["facebook"] = b
                            dict["google"] = c
                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            let center = appDelegate.didLogin()
                            self.window?.rootViewController =  self.didLogin()                        }
                    }
                case .Failure(let error):
                    //print("Request failed with error: \(error)")
                    self.publica("Verifica tu conexión a internet")
                    }
            }
            //DESCOMENTAR SI ES NECESARIO
            // self.window?.rootViewController =  didLogin()
            
            
        } else {
           // print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            NSNotificationCenter.defaultCenter().postNotificationName(
                "ToggleAuthUINotification", object: nil, userInfo: nil)
            // [END_EXCLUDE]
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NSNotificationCenter.defaultCenter().postNotificationName(
            "ToggleAuthUINotification",
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
    
    
    //function to show a alert controller
    func publica (messageBody : String) {
        let alertController = UIAlertController(title: "Error", message:
            messageBody, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,
            handler: nil))
        self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        let todoItems: [TodoItem] = TodoList.sharedInstance.allItems() // retrieve list of all to-do items
        let overdueItems = todoItems.filter({ (todoItem) -> Bool in
            return todoItem.deadline.compare(NSDate()) != .OrderedDescending
        })
        
//        UIApplication.sharedApplication().applicationIconBadgeNumber = overdueItems.count  // set our badge number to number of overdue items
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
         connectToFcm()
        NSNotificationCenter.defaultCenter().postNotificationName("TodoListShouldRefresh", object: self)
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
       UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        var shoulDownload = true
        
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            
            let url:NSURL = NSURL(string: urlVideo)!
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "HEAD"
            
            var response : NSURLResponse?
            try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            
            if let httpResponse = response as? NSHTTPURLResponse {
                
                let remoteSize = httpResponse.expectedContentLength
                
                //print(httpResponse.expectedContentLength)
                
                let filePath = localFilePathForUrl(urlVideo)?.path
                
                let fileManager = NSFileManager.defaultManager()
                if fileManager.fileExistsAtPath(filePath!) {
                   // print("FILE AVAILABLE")
                    let attr:NSDictionary? = try fileManager.attributesOfItemAtPath(filePath!)
                    if let _attr = attr {
                        let localSize = Int64(_attr.fileSize())
                        if (localSize == remoteSize){
                         //   print("SAME FILE")
                            shoulDownload = false
                        }
                        
                    }
                }else{
                  //  print("FILE NOT AVAILABLE")
                }
                
                
            }
            
        } catch {
           // print("Unable to create Reachability")
            return
        }
        
        if (shoulDownload){
            reachability.whenReachable = { reachability in
                // this is called on a background thread, but UI updates must
                // be on the main thread, like this:
                dispatch_async(dispatch_get_main_queue()) {
                    if reachability.isReachableViaWiFi() {
                      //  print("Reachable via WiFi")
                        
                        
                        let networkHandler = NetworkHandler.sharedInstance
                        
                        let request = NSMutableURLRequest(URL: NSURL(string: self.urlVideo)!)
                        networkHandler.startBackgroundDownload(request)
                        
                        completionHandler(.NewData)
                        
                        
                    } else {
                      //  print("Reachable via Cellular")
                    }
                    
                    reachability.stopNotifier()
                }
            }
            reachability.whenUnreachable = { reachability in
                // this is called on a background thread, but UI updates must
                // be on the main thread, like this:
                dispatch_async(dispatch_get_main_queue()) {
                  //  print("Not reachable")
                    reachability.stopNotifier()
                }
            }
            
            do {
                try reachability.startNotifier()
            } catch {
               // print("Unable to start notifier")
            }
        }
        
    }
    
    // MARK: background session handling
    
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        //print("-- handleEventsForBackgroundURLSession --")
        let backgroundConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(identifier)
        let backgroundSession = NSURLSession(configuration: backgroundConfiguration, delegate: networkHandler, delegateQueue: nil)
        //print("Rejoining session \(backgroundSession)")
        
        networkHandler.addCompletionHandler(completionHandler, identifier: identifier)
    }
    
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Sandbox)
        
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            
            Alamofire.request(.POST, "http://app.codegto.gob.mx/code_web/src/app_php/notificaciones/registrar.php", parameters: ["Token": refreshedToken , "id_login_app": dict["id_login_app"]! , "os":"2"])
                .responseJSON {
                    response in switch response.result {
                    case .Success(let JSON):
                        print("Success with JSON: \(JSON)")
                        let response = JSON as! NSDictionary
                      //  print (".\(response).")
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                        //  print("Verifica tu conexión a internet")
                    }
            }
        }
    }
    
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
       print("Failed to register:", error)
    }
    
    
    
    
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("MessageID \(userInfo["gcm_message_id"]!) ")
        print(userInfo)
        
      /*  var notifiAlert = UIAlertView()
        var NotificationMessage : AnyObject? =  userInfo["alert"]
        notifiAlert.title =  userInfo["title"] as! String
        notifiAlert.message = NotificationMessage as? String
        notifiAlert.addButtonWithTitle("OK")
        notifiAlert.show()*/
        let dict = userInfo as NSDictionary;
        
        
        if(application.applicationState == .Active) {
            print("NOTIFY ACTIVE")
            var notifiAlert = UIAlertView()
            var NotificationMessage : AnyObject? =  userInfo["alert"]
            notifiAlert.title =  "CODE"
            notifiAlert.message = NotificationMessage as? String
            notifiAlert.addButtonWithTitle("OK")
            
            
            notifiAlert.show()
        /*   if let x = dict["gcm.notification.link_url"]{
                let nsurl = NSURL(string: x as! String)!
               UIApplication.sharedApplication().openURL(nsurl)
            }*/
            
        }else if(application.applicationState == .Background){
            print("NOTIFY BACKGROUND")
            if let x = dict["gcm.notification.link_url"]{
                var url:String = dict["gcm.notification.link_url"]as! String
                 UIApplication.sharedApplication().openURL(NSURL(string:url)!)
                  url = x as! String;
            }
            
        }else if(application.applicationState == .Inactive){
                     /* if let x = dict["gcm.notification.link_url"]{
                var url:String = dict["gcm.notification.link_url"]as! String
                let safari = SFSafariViewController(URL:NSURL(string: url)!)
                window?.rootViewController?.presentViewController(safari, animated: true, completion: nil)
            }*/
            if let x = dict["gcm.notification.link_url"]{
                let nsurl = NSURL(string: x as! String)!
                UIApplication.sharedApplication().openURL(nsurl)
              //  url = x as! String;
            }
            
           
          
        }
        
       
        
        
    }
    
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        
        
        //print("handleActionWithIdentifierwith forRemoteNotification ResponseInfo ")
    }
    
    
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        // 1
        //let aps = userInfo["aps"] as! [String: AnyObject]
        
       // print(aps)
        
        
       // print("handleActionWithIdentifier forRemoteNotification completionHandler")
        
        // 2
//        if let newsItem = createNewNewsItem(aps) {
//            (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
//            
//            // 3
//            if identifier == "VIEW_IDENTIFIER", let url = NSURL(string: newsItem.link) {
//                let safari = SFSafariViewController(URL: url)
//                window?.rootViewController?.presentViewController(safari, animated: true, completion: nil)
//            }
//        }
        
        // 4
        completionHandler()
    }
    
    
    
    // [START refresh_token]
    func tokenRefreshNotification(notification: NSNotification) {
        if let refreshedToken = FIRInstanceID.instanceID().token(){
            print("InstanceID token: \(refreshedToken)")
        
            // Connect to FCM since connection may have failed when attempted before having a token.
            connectToFcm()
        }
    }
    // [END refresh_token]
    
    // [START connect_to_fcm]
    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    // [END connect_to_fcm]

    
    
 }
 
 
