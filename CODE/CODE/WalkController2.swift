//
//  WalkController.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez on 17/07/16.
//  Copyright © 2016 CODE. All rights reserved.
//

import UIKit
import BWWalkthrough

class WalkController2: UIViewController, BWWalkthroughViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if !userDefaults.boolForKey("walkthroughPresented") {
            
            showWalk()
            
            userDefaults.setBool(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        }
    }
    
    @IBAction func showWalk() {
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewControllerWithIdentifier("walk") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewControllerWithIdentifier("walk0")
        let page_one = stb.instantiateViewControllerWithIdentifier("walk1")
        let page_two = stb.instantiateViewControllerWithIdentifier("walk2")
        let page_three = stb.instantiateViewControllerWithIdentifier("walk3")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.addViewController(page_one)
        walkthrough.addViewController(page_two)
        walkthrough.addViewController(page_three)
        walkthrough.addViewController(page_zero)
        
        self.presentViewController(walkthrough, animated: true, completion: nil)
    }
    
    
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(pageNumber: Int) {
       // print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let center = appDelegate.didLogin()
        self.navigationController?.presentViewController(center, animated: true, completion: nil)
    }


}
