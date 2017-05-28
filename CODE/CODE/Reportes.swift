//
//  Reportes.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez  & Oscar Barrera Casillas on 01/05/16.
//  Copyright © 2016 CODE. All rights reserved.
//  Class to show Reportes about Agua and Ejercicio using Realm

import UIKit
import RealmSwift



class Reportes: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableReporte: UITableView!
    
    //var fecha = ["27-02-2016", "25-09-1992", "29-11-2020"]
    var aguaimage = [UIImage(named:"simle"), UIImage(named:"sad"), UIImage(named:"simle")]
    var ejercicioimage = [UIImage(named:"simle"), UIImage(named:"sad"), UIImage(named:"sad")]
    var minutos = ["30 min", "20 min", "10 min"]
    var agua = ["2 lts", "300 mls", "3 lts"]
    var Arra: [Bitacora] = []
    
    
    //Get elements in descending and add to array
    func LlenaArray(){
        // print(Realm.Configuration.defaultConfiguration.fileURL!)
        //fechaToday fecha = 2016-05-30   id = 1 sorted to ascending
        let realm = try! Realm()
        let allBitacora = realm.objects(Bitacora).sorted("id", ascending: false)
        var one = allBitacora
        for bitacora in one{
            Arra.append(bitacora)
        }
       // print(Arra)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LlenaArray()
        modalTransitionStyle = .FlipHorizontal
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    //show home  in the comments there is other animation to change the view
    @IBAction func lefButton(sender: AnyObject) {
        /*let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
         .TransitionCrossDissolve
         UIView.transitionWithView(appDelegate.window!, duration: 0.4, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
         let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as!    HomeViewController
         let centerNavController = UINavigationController(rootViewController: centerViewController)
         appDelegate.centerContainer!.centerViewController = centerNavController
         }, completion: nil)
         appDelegate.window?.rootViewController?.presentViewController(appDelegate.tabBarController!, animated: true, completion: nil)*/
        /*let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as!    HomeViewController
        let centerNavController = UINavigationController(rootViewController: centerViewController)
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.centerViewController = centerNavController*/
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  Arra.count
    }
    
    //set a face depends of the result of each consult
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableReporte.dequeueReusableCellWithIdentifier("cellReport", forIndexPath: indexPath) as! ReporteTableViewCell
        let fecha = Arra.map { $0.fecha }
        cell.labelFecha.text = fecha[indexPath.row]
        let agua = Arra.map { $0.registro_agua }
        cell.labelAgua.text = ("\(agua[indexPath.row]) lts")
        //String(agua[indexPath.row])
        let ejerimag = Arra.map { $0.minutos_ejercicio }
        if ejerimag[indexPath.row] >= 30 {
            cell.imageEjercicio.image = UIImage(named:"simleb2")
        }else{
            cell.imageEjercicio.image = UIImage(named:"sadb2")
        }
        let aguaimag = Arra.map { $0.registro_agua }
        if aguaimag[indexPath.row] >= 2.0 {
            cell.imageAgua.image = UIImage(named:"simleb2")
        }else{
            cell.imageAgua.image = UIImage(named:"sadb2")
        }
        let minuEjer = Arra.map { $0.minutos_ejercicio }
        cell.labelEjercicio.text = "\(minuEjer[indexPath.row]) min"
        //String(minuEjer[indexPath.row])
        let v = UIView()
        v.backgroundColor = UIColor( red:0.00, green:0.65, blue: 0.90, alpha: 1.0)
        //self.darkerColor(UIColor.blueColor())
        cell.selectedBackgroundView = v;
        return cell
    }
}
