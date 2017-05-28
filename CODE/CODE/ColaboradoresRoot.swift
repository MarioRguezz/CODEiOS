//
//  ColaboradoresRoot.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez on 13/07/16.
//  Copyright © 2016 CODE. All rights reserved.
//

import UIKit

class ColaboradoresRoot: UIViewController{
    
    @IBOutlet weak var colaboradoresTec: UIImageView!
    @IBOutlet weak var colaboradoresGto: UIImageView!
    
    @IBOutlet weak var facebook: UIImageView!
    @IBOutlet weak var twitter: UIImageView!
    
    @IBOutlet weak var instagram: UIImageView!
    @IBOutlet weak var youtube: UIImageView!
      override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ColaboradoresRoot.changeAd))
        colaboradoresTec.addGestureRecognizer(tap)
        colaboradoresTec.userInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(ColaboradoresRoot.changeAd2))
        colaboradoresGto.addGestureRecognizer(tap2)
        colaboradoresGto.userInteractionEnabled = true
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(ColaboradoresRoot.changeAd3))
        facebook.addGestureRecognizer(tap3)
        facebook.userInteractionEnabled = true
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(ColaboradoresRoot.changeAd4))
        twitter.addGestureRecognizer(tap4)
        twitter.userInteractionEnabled = true
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(ColaboradoresRoot.changeAd5))
        youtube.addGestureRecognizer(tap5)
        youtube.userInteractionEnabled = true
        let tap6 = UITapGestureRecognizer(target: self, action: #selector(ColaboradoresRoot.changeAd6))
        instagram.addGestureRecognizer(tap6)
        instagram.userInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    func changeAd()
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("Colaboradores") as! Colaboradores
        let centerNav = UINavigationController(rootViewController: nextViewController)
        self.presentViewController(centerNav, animated:true, completion:nil)

    }
    
    
    func changeAd2()
    {
       // UIApplication.sharedApplication().openURL(NSURL(string: "http://www.codegto.gob.mx/index.php/directorio/")!)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ColaboradoresCode") as! ColaboradoresCode
        let centerNav = UINavigationController(rootViewController: nextViewController)
        self.presentViewController(centerNav, animated:true, completion:nil)
    }
    
    
    
    //show home
    @IBAction func buttonLeftPressed(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let center = appDelegate.didLogin()
        self.navigationController?.presentViewController(center, animated: true, completion: nil)
    }
    
    
    func changeAd3()
    {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/GuanajuatoCODE/?fref=ts")!)
    }
    func changeAd4()
    {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/guanajuatocode")!)
    }
    func changeAd5()
    {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.youtube.com/user/CODEGuanajuato")!)
    }
    
        func changeAd6()
        {
            UIApplication.sharedApplication().openURL(NSURL(string: "https://www.instagram.com/guanajuatocode/")!)
    }

 
}

