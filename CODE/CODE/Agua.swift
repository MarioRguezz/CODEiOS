//
//  Agua.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez  & Oscar Barrera Casillas on 01/05/16.
//  Copyright © 2016 CODE. All rights reserved.
//  class to set progress bar of agua and update data with realm

import UIKit
import RealmSwift

protocol cellModelChanged {
    func cellModelSwitchTapped(model: cellWater, isSwitchOn: Bool, flag: Bool)
}


class Agua: UIViewController, UITableViewDelegate, UITableViewDataSource, cellModelChanged{

    @IBOutlet weak var tableViewWater: UITableView!
    @IBOutlet weak var litrosCantidad: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    var count = 0.0
    var feedModel: [CellModelWater] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
               //  allOff()
        if verificaFecha() == false {
            addDate()
        }
       
    }
    
    @IBAction func HelpButton(sender: AnyObject) {
        
        
        publicaPolitica("Registra aquí tu consumo de agua diario ​en la búsqueda de una mejor salud para ti.")
    }
    
    
    func publicaPolitica(messageBody : String) {
        
        let alertController = UIAlertController(title: "CODE", message:
            messageBody, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,
            handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //check if the switch state was changed
    func revisarCheck(check: UISwitch) -> Bool{
        var flag = false
        if check.on {
            check.setOn(false, animated:true)
            flag = true
        } else {
            flag = false
        }
        return flag
        
    }
    
    //clousure of counter to change the value of progress bar
    var counter:Float = 0 {
        didSet {
            var fractionalProgress = counter / 100.0
            let animated = counter != 0
            progressBar.setProgress(fractionalProgress, animated: animated)
        }
    }
    
    //switch off
   /* func allOff (){
        switchA.setOn(false, animated:true)
        switchB.setOn(false, animated:true)
        switchC.setOn(false, animated:true)
        //    progressBar.setProgress(0, animated: false)
    }*/
    
    // show home
    @IBAction func menuLeftPressed(sender: AnyObject) {
        /*let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as!    HomeViewController
        let centerNavController = UINavigationController(rootViewController: centerViewController)
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.centerViewController = centerNavController*/
        // appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
    }
    
    //get due date in String
    func fechaToday() -> String {
        let date2 = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var strDate2 = dateFormatter.stringFromDate(date2)
        return strDate2
    }
    
    //make an autoincrement data id
    func getNextKey() -> Int {
        let realm = try! Realm()
        let allBitacora = realm.objects(Bitacora)
        var id = allBitacora.count
        return id+1
    }
    
    //check if the due date has a record
    func verificaFecha() -> Bool {
        let realm = try! Realm()
        let allBitacora = realm.objects(Bitacora)
        var date = allBitacora.filter("fecha = '\(fechaToday())' AND id_app_login = '\(dict["id_login_app"]!)'").count
        if date != 0 {
            return true
        }
        return false
    }
    
    //add insert if doesn't exist
    func addDate(){
        let date = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var strDate = dateFormatter.stringFromDate(date)
        let bitacora = Bitacora()
        bitacora.id = getNextKey()
        bitacora.id_app_login = dict["id_login_app"]!
        bitacora.fecha = strDate
        bitacora.minutos_ejercicio = 0
        bitacora.registro_agua = 0.0
        bitacora.calorias_ejercicio = 0
        let realm = try! Realm()
        try! realm.write{
            realm.add(bitacora)
        }
    }
    
    //set the data when you open de view
    func seteaData(){
        var litros = 0.0
        let realm = try! Realm()
        let allBitacora = realm.objects(Bitacora)
        var valor = allBitacora.filter("fecha = '\(fechaToday())' AND id_app_login = '\(dict["id_login_app"]!)'")
        for bitacora in valor{
            litros = bitacora.registro_agua
        }
        count = litros
        if count >= 2.0 {
            counter =  100
        } else if count >= 1.5 && count <= 1.9 {
            counter = 75
        } else if count >= 1.0 && count <= 1.4 {
            counter = 60
        } else if count >= 0.5 && count <= 0.9 {
            counter = 37
        } else if count >= 0.1 && count <= 0.4{
            counter = 15
        }
        else{
            counter = 0
        }
        litrosCantidad.text = "\(count) litros de agua"
    }
    
    
    //se ejecuta cada vez que se muestre el viewcontroller
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var litros = 0.0
        let realm = try! Realm()
        let allBitacora = realm.objects(Bitacora)
        var valor = allBitacora.filter("fecha = '\(fechaToday())' AND id_app_login = '\(dict["id_login_app"]!)'")
        for bitacora in valor{
            litros = bitacora.registro_agua
        }
        count = litros
        if count >= 2.0 {
            counter =  100
        } else if count >= 1.5 && count <= 1.9 {
            counter = 75
        } else if count >= 1.0 && count <= 1.4 {
            counter = 60
        } else if count >= 0.5 && count <= 0.9 {
            counter = 37
        } else if count >= 0.1 && count <= 0.4{
            counter = 15
        }
        else{
            counter = 0
        }
        litrosCantidad.text = "\(count) litros de agua"
    }
    
    //Check the user and due date then you update the the value and set a new value in the progress bar
    @IBAction func registrarAgua(sender: AnyObject) {
        
       /* let realm = try! Realm()
        let bitacora = realm.objects(Bitacora).filter("fecha = '\(fechaToday())' AND id_app_login = '\(dict["id_login_app"]!)'").first
        if revisarCheck(switchA) {
            counter = counter + 12;
            count = count + 0.24
            try! realm.write {
                bitacora?.registro_agua = count
            }
            if count >= 2.0 {
                count = 2.0
            }
            litrosCantidad.text = "\(count) litros de agua"
        }
        if revisarCheck(switchB) {
            counter = counter + 15;
            count = count + 0.30
            try! realm.write {
                bitacora?.registro_agua = count
            }
            if count >= 2.0 {
                count = 2.0
            }
            litrosCantidad.text = "\(count) litros de agua"
        }
        if revisarCheck(switchC){
            counter = counter + 25;
            count = count + 0.50
            try! realm.write {
                bitacora?.registro_agua = count
            }
            if count >= 2.0 {
                count = 2.0
            }
            litrosCantidad.text = "\(count) litros de agua"
        }
        
    }*/
    }
    
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return feedModel.count
        }
  
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableViewWater.dequeueReusableCellWithIdentifier("cell") as! cellWater
            /*tableViewWater.registerNib(UINib(nibName: "cellWater", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "cell")*/

            let model = feedModel[indexPath.row]
            cell.Recipientes.text = model.recipiente
            cell.mlLabel.text = model.mlLabel
            cell.`switch`.setOn(model.isOn, animated: true)
            cell.delegate = self
            return cell
        }
        
    func cellModelSwitchTapped(model: cellWater, isSwitchOn: Bool, flag:Bool) {
        let model = feedModel[(tableViewWater.indexPathForCell(model)?.row)!]
        model.isOn = isSwitchOn
        let realm = try! Realm()
        let bitacora = realm.objects(Bitacora).filter("fecha = '\(fechaToday())' AND id_app_login = '\(dict["id_login_app"]!)'").first
        if model.recipiente == "Botella Chica" {
            counter = counter + 12.5;
            count = count + 0.25
            if count >= 2.0 {
                count = 2.0
            }
            try! realm.write {
                bitacora?.registro_agua = count
            }
            model.isOn = false
            tableViewWater.reloadData()
            litrosCantidad.text = "\(count) litros de agua"
        }
        if model.recipiente == "Botella Mediana" {
            counter = counter + 25;
            count = count + 0.50
            if count >= 2.0 {
                count = 2.0
            }
            try! realm.write {
                bitacora?.registro_agua = count
            }
            model.isOn = false
            tableViewWater.reloadData()
            litrosCantidad.text = "\(count) litros de agua"
        }
        if model.recipiente == "Botella Grande" {
            counter = counter + 50;
            count = count + 1.00
            if count >= 2.0 {
                count = 2.0
            }
            try! realm.write {
                bitacora?.registro_agua = count
            }
            
            model.isOn = false
            tableViewWater.reloadData()
            litrosCantidad.text = "\(count) litros de agua"
        }
        if model.recipiente == "Botella Extra grande" {
            counter = counter + 75;
            count = count + 1.50
            if count >= 2.0 {
                count = 2.0
            }
            try! realm.write {
                bitacora?.registro_agua = count
            }
            
            model.isOn = false
            tableViewWater.reloadData()
            litrosCantidad.text = "\(count) litros de agua"
        }
        if model.recipiente == "Vaso Chico" {
            counter = counter + 12.5;
            count = count + 0.25
            if count >= 2.0 {
                count = 2.0
            }
            try! realm.write {
                bitacora?.registro_agua = count
            }
            
            model.isOn = false
            tableViewWater.reloadData()
            litrosCantidad.text = "\(count) litros de agua"
        }
        if model.recipiente == "Vaso Grande" {
            counter = counter + 25;
            count = count + 0.50
            if count >= 2.0 {
                count = 2.0
            }
            try! realm.write {
                bitacora?.registro_agua = count
            }
            
            litrosCantidad.text = "\(count) litros de agua"
        }
        if model.recipiente == "Taza Grande" {
            counter = counter + 25;
            count = count + 0.50
            if count >= 2.0 {
                count = 2.0
            }
            try! realm.write {
                bitacora?.registro_agua = count
            }
            
            model.isOn = false
            tableViewWater.reloadData()
            litrosCantidad.text = "\(count) litros de agua"
        }

        
        }
    


    func setData() {
         let cellModel: CellModelWater = CellModelWater(recipiente: "Botella Chica", mlLabel: "250 ml",  isOn  : false)
         let cellModel1: CellModelWater = CellModelWater(recipiente: "Botella Mediana", mlLabel: "500 ml",  isOn  : false)
         let cellModel2: CellModelWater = CellModelWater(recipiente: "Botella Grande", mlLabel: "1 L",  isOn  : false)
         let cellModel3: CellModelWater = CellModelWater(recipiente: "Botella Extra grande", mlLabel: "1.5 L",  isOn  : false)
         let cellModel4: CellModelWater = CellModelWater(recipiente: "Vaso Chico", mlLabel: "250 ml",  isOn  : false)
         let cellModel5: CellModelWater = CellModelWater(recipiente: "Vaso Grande", mlLabel: "500 ml",  isOn  : false)
         let cellModel6: CellModelWater = CellModelWater(recipiente: "Taza Grande", mlLabel: "500 ml",  isOn  : false)
        feedModel.append(cellModel)
        feedModel.append(cellModel1)
        feedModel.append(cellModel2)
        feedModel.append(cellModel3)
        feedModel.append(cellModel4)
        feedModel.append(cellModel5)
        feedModel.append(cellModel6)
    }
        
        
        
        
}
