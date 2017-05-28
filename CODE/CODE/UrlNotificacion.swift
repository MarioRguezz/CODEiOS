//
//  UrlNotificacion.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez on 27/10/16.
//  Copyright © 2016 CODE. All rights reserved.
//

import UIKit
import RealmSwift

class UrlNotificacion: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL (string: "http://app.codegto.gob.mx/historial/index.php");
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //show home
    @IBAction func buttonMenuLeft(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    


    
    
    
    
    
}