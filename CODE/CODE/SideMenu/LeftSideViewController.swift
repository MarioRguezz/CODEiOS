//
//  LeftSideViewController.swift
//  Code
//
//  Created by Mario Alberto Negrete Rodríguez & Oscar Barrera Casillas on 10/03/16.
//  Copyright © 2016 MarioRguezz. All rights reserved.
//  class to choose an option of the menu

import UIKit;
import FBSDKLoginKit;
import FBSDKCoreKit;

class LeftSideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var menuItems:[String] = ["Mi Perfil","Home", "Cerrar Sesión", "Datos de Usuario", "Actividades", "Calendario de Activación", "Registrar Agua","Registrar Ejercicio","Alarmas de Activación", "Ver Reportes" ,"Ayuda", "Personalizar Alarmas","Directorio de Instalaciones","Acerca de"];
    let headerTitles = ["Inicio", "Actividades", "General"]
    let data = [["Home","Mi Perfil", "Cerrar Sesión"], ["Calendario de activación", "Registrar ejercicio", "Registrar agua", "Alarmas de activación", "Ver reportes", "Notificaciones"],["Instalaciones deportivas","Acerca de"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //title of the section
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headerTitles[section]
        
    }
    
    //number of the sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.headerTitles.count
    }
    
    
    
    
    //number of rows for section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.data[section].count
        
    }
    
    
    //custom cell for each section
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var mycell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! SideMenuTableViewCell
        // mycell.menuItemLabel.text = menuItems[indexPath.row]
        mycell.menuItemLabel.text = self.data[indexPath.section][indexPath.row]
        let v = UIView()
        v.backgroundColor = UIColor( red:0.00, green:0.65, blue: 0.90, alpha: 1.0)
        //self.darkerColor(UIColor.blueColor())
        mycell.selectedBackgroundView = v;
        
        return mycell;
        
    }
    
    
    
    //action with each cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
       // print(indexPath.row)
        if indexPath.section == 0 {
            switch(indexPath.row)
            {
            case 0:
                let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as!    HomeViewController
                let centerNavController = UINavigationController(rootViewController: centerViewController)
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.centerContainer!.centerViewController = centerNavController
                appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                break;
            case 1:
                let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MiPerfil") as!    MiPerfil
                let centerNavController = UINavigationController(rootViewController: centerViewController)
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.centerContainer!.centerViewController = centerNavController
                appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                break;
            case 2:
                if dict["google"] == "1" {
                    dict["google"] = ""
                    dict["id_login_app"] = ""
                    dict["correo"] = ""
                    dict["facebook"] = ""
                    NSUserDefaults.standardUserDefaults().setObject(dict, forKey: "toDoList")
                    GIDSignIn.sharedInstance().signOut()
                    let signInPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
                    let signInPageNav = UINavigationController(rootViewController: signInPage)
                    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.window?.rootViewController = signInPageNav
                } else if dict["facebook"] == "1"{
                    dict["google"] = ""
                    dict["id_login_app"] = ""
                    dict["correo"] = ""
                    dict["facebook"] = ""
                    NSUserDefaults.standardUserDefaults().setObject(dict, forKey: "toDoList")
                    let loginManager = FBSDKLoginManager()
                    loginManager.logOut()
                    let signInPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
                    let signInPageNav = UINavigationController(rootViewController: signInPage)
                    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.window?.rootViewController = signInPageNav
                } else{
                    dict["google"] = ""
                    dict["id_login_app"] = ""
                    dict["correo"] = ""
                    dict["facebook"] = ""
                    NSUserDefaults.standardUserDefaults().setObject(dict, forKey: "toDoList")
                    let signInPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
                    let signInPageNav = UINavigationController(rootViewController: signInPage)
                    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.window?.rootViewController = signInPageNav
                }
                break;
            default: break
              //  print("\(menuItems[indexPath.row]) is selected");
            }
        }
        if indexPath.section == 1 {
            switch(indexPath.row)
            {
            case 0:
                let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Calendario") as!    Calendario
                let centerNavController = UINavigationController(rootViewController: centerViewController)
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.centerContainer!.centerViewController = centerNavController
                appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                break;
            case 1:
                let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Ejercicio") as!    Ejercicio
                let centerNavController = UINavigationController(rootViewController: centerViewController)
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.centerContainer!.centerViewController = centerNavController
                appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                break;
            case 2:
                let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Agua") as!    Agua
                let centerNavController = UINavigationController(rootViewController: centerViewController)
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.centerContainer!.centerViewController = centerNavController
                appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                break;
            case 3:
                let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TodoTableViewController") as!    TodoTableViewController
                let centerNavController = UINavigationController(rootViewController: centerViewController)
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.centerContainer!.centerViewController = centerNavController
                appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                
                break;
            case 4:
                let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Reportes") as!    Reportes
                let centerNavController = UINavigationController(rootViewController: centerViewController)
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.centerContainer!.centerViewController = centerNavController
                appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                break;
            case 5:
                let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UrlNotificacion") as!    UrlNotificacion
                let centerNavController = UINavigationController(rootViewController: centerViewController)
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.centerContainer!.centerViewController = centerNavController
                appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                break;
            default: break
               // print("\(menuItems[indexPath.row]) is selected");
            }
        }
        
        if indexPath.section == 2 {
            switch(indexPath.row)
            {
            case 0:
                let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Directorio") as!    Directorio
                let centerNavController = UINavigationController(rootViewController: centerViewController)
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.centerContainer!.centerViewController = centerNavController
                appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                break;
            case 1:
                let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ColaboradoresRoot") as!    ColaboradoresRoot
                let centerNavController = UINavigationController(rootViewController: centerViewController)
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.centerContainer!.centerViewController = centerNavController
                appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                break;
            default: break
              //  print("\(menuItems[indexPath.row]) is selected");
            }
        }
    }
}


