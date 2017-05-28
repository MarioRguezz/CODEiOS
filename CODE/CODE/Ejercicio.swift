//
//  Ejercicio.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez  & Oscar Barrera Casillas on 01/05/16.
//  Copyright © 2016 CODE. All rights reserved.
//  Class Ejercicio to save advance each day  with realm

import UIKit
import RealmSwift

protocol cellModelChang {
    func cellModelSwitchTap(model: CellExercise, isSwitchOn: Bool, flag: Bool)
}



class Ejercicio: UIViewController, UITableViewDelegate, UITableViewDataSource, cellModelChang{
    
    @IBOutlet weak var TableViewExercise: UITableView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var minutosLabel: UILabel!
    var count = 0
    var cal = 0
    var feedModel: [CellModelExercise] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
       // allOff()
        setData()
        if verificaFecha() == false {
            addDate()
        }
        seteaData()
    }
    
    
    //check the user and due date
    func verificaFecha() -> Bool {
        let realm = try! Realm()
        let allBitacora = realm.objects(Bitacora)
        var date = allBitacora.filter("fecha = '\(fechaToday())' AND id_app_login = '\(dict["id_login_app"]!)'").count
        if date != 0 {
            return true
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Check the user and due date then you update the the value and set a new value in the progress bar
   /* @IBAction func altaEjercicio(sender: AnyObject) {
            }
    */
    
    //Check if the switch state was changed
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
    
    @IBAction func ActionInfo(sender: AnyObject) {
        publica2("Registra aquí el tiempo de activación por día. ​L​a meta son 150 minutos a la semana (mínimo) *Lista de Actividades calculada para una persona de 70 Kg aproximadamente. *Los datos mostrados pueden variar dependiendo de los factores físicos y metabólicos de la persona. *Datos tomados del Libro Alimentación y Nutrición de Grancisco Grande Covian.")
        
    }
    
    //function to show a alert controller
    func publica2 (messageBody : String) {
        let alertController = UIAlertController(title: "CODE", message:
            messageBody, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,
            handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    //clousure of counter to set value to progress bar
    var counter:Float = 0 {
        didSet {
            var fractionalProgress = counter / 100.0
            let animated = counter != 0
            //30
            if fractionalProgress >= 99.98 {
                fractionalProgress = 1.0
            }
            progressBar.setProgress(fractionalProgress, animated: animated)
            
        }
    }
    /*@IBAction func RegistrarEjercicio(sender: AnyObject) {
        //AQUI
    }
    */
    
    //show home
    @IBAction func buttonMenuLeft(sender: AnyObject) {
       /* let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as!    HomeViewController
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
    
    //make an autoincrement id
    func getNextKey() -> Int {
        let realm = try! Realm()
        let allBitacora = realm.objects(Bitacora)
        var id = allBitacora.count
        return id+1
    }
    
    //add a new insert unless exist
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
    
    //set the data when you open the view
    func seteaData(){
        var minutos = 0
        var calorias = 0
        let realm = try! Realm()
        let allBitacora = realm.objects(Bitacora)
        var valor = allBitacora.filter("fecha = '\(fechaToday())' AND id_app_login = '\(dict["id_login_app"]!)'")
        for bitacora in valor{
            minutos = bitacora.minutos_ejercicio
            calorias = bitacora.calorias_ejercicio
        }
        count = minutos
        cal = calorias
        if count >= 30 {
            counter =  100
        } else if count >= 20 && count <= 29 {
            counter = 66.66
        } else if count >= 10 && count <= 19 {
            counter = 33.33
        } else if count >= 1 && count <= 9 {
            counter = 16.66
        } else{
            counter = 0
        }
        minutosLabel.text = "\(count) minutos de ejercicio"
    }
    
    
    
    
    func cellModelSwitchTap(model: CellExercise, isSwitchOn: Bool, flag:Bool) {
        let model = feedModel[(TableViewExercise.indexPathForCell(model)?.row)!]
      //  model.isOn = isSwitchOn
        let realm = try! Realm()
        let bitacora = realm.objects(Bitacora).filter("fecha = '\(fechaToday())' AND id_app_login = '\(dict["id_login_app"]!)'").first
        if model.ejercicio == "Barrer"{
            counter = counter + 33.33;
            count = count + 10
            cal = cal + 35
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Trapear Suelo"{
            counter = counter + 33.33;
            count = count + 10
            cal = cal + 45 //45.5
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Lavar a mano"{
            counter = counter + 33.33;
            count = count + 10
            cal = cal + 49
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Lavar platos"{
            counter = counter + 33.33;
            count = count + 10
            cal = cal + 25 //25.9
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Subir Escaleras"{
            counter = counter + 33.33;
            count = count + 10
            cal = cal + 177 //177.8
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Correr"{
            counter = counter + 33.33;
            count = count + 10
            cal = cal + 211 //211.4
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Trotar"{
            counter = counter + 66.66;
            count = count + 20
            cal = cal + 135 //135.8
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Caminar"{
            counter = counter + 66.66;
            count = count + 20
            cal = cal + 71 //71.4
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Ciclismo"{
            counter = counter + 66.66;
            count = count + 20
            cal = cal + 224
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Cortar Jardín"{
            counter = counter + 66.66;
            count = count + 20
            cal = cal + 120 //120.4
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Bailar"{
            counter = counter + 66.66;
            count = count + 20
            cal = cal + 141 //141.4
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Baloncesto"{
            counter = counter + 100;
            count = count + 30
            cal = cal + 294
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Frontón"{
            counter = counter + 100;
            count = count + 30
            cal = cal + 319 //319.2
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Futbol"{
            counter = counter + 100;
            count = count + 30
            cal = cal + 287 //287.7
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Golf"{
            counter = counter + 100;
            count = count + 30
            cal = cal + 168
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Ping Pong"{
            counter = counter + 100;
            count = count + 30
            cal = cal + 117 //117.6
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Tenis"{
            counter = counter + 100;
            count = count + 30
            cal = cal + 228//228.7
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Escalar"{
            counter = counter + 100;
            count = count + 30
            cal = cal + 399
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Remar"{
            counter = counter + 100;
            count = count + 30
            cal = cal + 189
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        if model.ejercicio == "Nadar"{
            counter = counter + 100;
            count = count + 30
            cal = cal + 222 //222.6
            try! realm.write {
                bitacora?.minutos_ejercicio = count
                bitacora?.calorias_ejercicio = cal
            }
            model.isOn = false
            TableViewExercise.reloadData()
            minutosLabel.text = "\(count) minutos de ejercicio"
        }
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedModel.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = TableViewExercise.dequeueReusableCellWithIdentifier("cell") as! CellExercise
        /*tableViewWater.registerNib(UINib(nibName: "cellWater", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "cell")*/
        
        let model = feedModel[indexPath.row]
        cell.Ejercicio.text = model.ejercicio
        cell.Minutos.text = model.minutos
        cell.Calorias.text = model.calorias
        cell.ChangeSwitch.setOn(model.isOn, animated: true)
        cell.delegate = self
        return cell
    }

    
    func setData() {
        let cellModel7: CellModelExercise = CellModelExercise(ejercicio: "Barrer", minutos:  "10 min",  calorias  : "35 kcal", isOn  : false)
        let cellModel9: CellModelExercise = CellModelExercise(ejercicio: "Trapear Suelo", minutos:  "10 min",  calorias  : "45.5 kcal", isOn  : false)
        let cellModel11: CellModelExercise = CellModelExercise(ejercicio: "Lavar a mano", minutos:  "10 min",  calorias  : "49 kcal", isOn  : false)
        let cellModel12: CellModelExercise = CellModelExercise(ejercicio: "Lavar platos", minutos:  "10 min",  calorias  : "25.9 kcal", isOn  : false)
        let cellModel14: CellModelExercise = CellModelExercise(ejercicio: "Subir Escaleras", minutos:  "10 min",  calorias  : "177 kcal", isOn  : false)
        let cellModel15: CellModelExercise = CellModelExercise(ejercicio: "Correr", minutos:  "20 min",  calorias  : "211 kcal", isOn  : false)
        let cellModel16: CellModelExercise = CellModelExercise(ejercicio: "Trotar", minutos:  "20 min",  calorias  : "135 kcal", isOn  : false)
        let cellModel17: CellModelExercise = CellModelExercise(ejercicio: "Caminar", minutos:  "20 min",  calorias  : "71.4 kcal", isOn  : false)
        let cellModel19: CellModelExercise = CellModelExercise(ejercicio: "Ciclismo", minutos:  "30 min",  calorias  : "224 kcal", isOn  : false)
        let cellModel20: CellModelExercise = CellModelExercise(ejercicio: "Cortar Jardín", minutos:  "20 min",  calorias  : "120 kcal", isOn  : false)
        let cellModel21: CellModelExercise = CellModelExercise(ejercicio: "Bailar", minutos:  "20 min",  calorias  : "141 kcal", isOn  : false)
        let cellModel22: CellModelExercise = CellModelExercise(ejercicio: "Baloncesto", minutos:  "30 min",  calorias  : "294 kcal", isOn  : false)
        let cellModel23: CellModelExercise = CellModelExercise(ejercicio: "Frontón", minutos:  " 30 min",  calorias  : "319 kcal", isOn  : false)
        let cellModel24: CellModelExercise = CellModelExercise(ejercicio: "Futbol", minutos:  " 30 min",  calorias  : "287 kcal", isOn  : false)
        let cellModel25: CellModelExercise = CellModelExercise(ejercicio: "Golf", minutos:  "30 min",  calorias  : "168 kcal", isOn  : false)
        let cellModel26: CellModelExercise = CellModelExercise(ejercicio: "Ping Pong", minutos:  "30 min",  calorias  : "117.6 kcal", isOn  : false)
        let cellModel27: CellModelExercise = CellModelExercise(ejercicio: "Tenis", minutos:  "30 min",  calorias  : "228 kcal", isOn  : false)
        let cellModel28: CellModelExercise = CellModelExercise(ejercicio: "Escalar", minutos:  "30 min",  calorias  : "399 kcal", isOn  : false)
        let cellModel29: CellModelExercise = CellModelExercise(ejercicio: "Remar", minutos:  "30 min",  calorias  : "189 kcal", isOn  : false)
        let cellModel30: CellModelExercise = CellModelExercise(ejercicio: "Nadar", minutos:  "30 min",  calorias  : "222 kcal", isOn  : false)
       
        feedModel.append(cellModel12)
        feedModel.append(cellModel7)
        feedModel.append(cellModel9)
        feedModel.append(cellModel11)
        feedModel.append(cellModel17)
        feedModel.append(cellModel26)
        feedModel.append(cellModel20)
        feedModel.append(cellModel16)
        feedModel.append(cellModel21)
        feedModel.append(cellModel25)
        feedModel.append(cellModel14)
        feedModel.append(cellModel29)
        feedModel.append(cellModel15)
        feedModel.append(cellModel30)
        feedModel.append(cellModel19)
        feedModel.append(cellModel27)
        feedModel.append(cellModel24)
        feedModel.append(cellModel22)
        feedModel.append(cellModel23)
        feedModel.append(cellModel28)
        
    }
    
    
    
}




//Apoyo realm
// print(Realm.Configuration.defaultConfiguration.fileURL!)
//fechaToday fecha = 2016-05-30   id = 1 sorted to ascending
/*  var one = allBitacora.filter("fecha = 'asd'").first
 if one != nil {
 print("hola")
 return true;
 }
 return false;*/

/*   for bitacora in one{
 print("\(bitacora.id)")
 
 
 func addHuman(){
 let date2 = NSDate()
 var dateFormatter = NSDateFormatter()
 dateFormatter.dateFormat = "yyyy-MM-dd"
 var strDate2 = dateFormatter.stringFromDate(date2)
 let mike = Bitacora()
 mike.id = 2
 mike.id_app_login = dict["id_login_app"]!
 mike.fecha = strDate2
 mike.minutos_ejercicio = 20
 mike.registro_agua = 15
 mike.calorias_ejercicio = 42
 let realm = try! Realm()
 try! realm.write{
 realm.add(mike)
 print (mike.fecha)
 print (mike.calorias_ejercicio)
 }
 }
 }*/

