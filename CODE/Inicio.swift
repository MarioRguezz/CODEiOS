//
//  Inicio.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez & Oscar Barrera Casillas on 01/05/16.
//  Copyright © 2016 CODE. All rights reserved.
//  Class to show a message only the first time that you use the app

import UIKit


class Inicio: UIViewController{
    
    @IBOutlet weak var comienzo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if NSUserDefaults.standardUserDefaults().objectForKey("inicio")  != nil {
            let homePage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            let homePageNav = UINavigationController (rootViewController: homePage)
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = homePageNav
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //function to set true if you pressed the button. Then in ViewController check with which view needs to start
    @IBAction func inicioAction(sender: AnyObject) {
        let inicio = 1
        NSUserDefaults.standardUserDefaults().setObject(inicio, forKey: "inicio")
        let homePage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let homePageNav = UINavigationController (rootViewController: homePage)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = homePageNav
    }
    
    
}
