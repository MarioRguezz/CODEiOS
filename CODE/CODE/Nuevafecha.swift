//
//  Nuevafecha.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez on 08/06/16.
//  Copyright © 2016 CODE. All rights reserved.
//


import UIKit
import RealmSwift



class Nuevafecha: UIViewController{
    @IBOutlet weak var tituloText: UITextField!
    @IBOutlet weak var descripcionText: UITextField!
    @IBOutlet weak var inicioDate: UIDatePicker!
    @IBOutlet weak var finDate: UIDatePicker!
    @IBOutlet weak var GuardarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard")))
        self.GuardarButton.backgroundColor = UIColor(red:0.23, green:0.33, blue:0.61, alpha:1.0)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        var strDate = dateFormatter.stringFromDate(inicioDate.date)
        var endDate = dateFormatter.stringFromDate(finDate.date)
        if inicioDate.date > finDate.date {
            publica("La fecha de finalización no puede ser anterior a la de inicio",messageTitle: "Error")
        }else{
            if tituloText.text!.isEmpty || descripcionText.text!.isEmpty{
                publica("Verifique que todos los campos esten llenos",messageTitle: "Error")
            }
            else{
                guardarEventos(getNextKey(), titulo: tituloText.text!, descripcion: descripcionText.text!, fecha_inicio: strDate, fecha_fin: endDate, fecha_actualizacion: strDate, tipo: 0, esLocal: true, estado: 1, fechain: strDate, fechafn: endDate,inicioDate:inicioDate.date)
                self.navigationController?.popToRootViewControllerAnimated(true) // return to list view
            }
            // guardaEvento()
        }
        /*
         var dateFmt = NSDateFormatter()
         dateFmt.timeZone = NSTimeZone.defaultTimeZone()
         dateFmt.dateFormat = "dd-MM-yyyy HH:mm"
         
         // Get NSDate for the given string
         var date = dateFmt.dateFromString(strDate)
         print("mariO")
         print(date!)
         */
        
    }
    
    //hide the keyboard
    func dismissKeyboard() {
        tituloText.resignFirstResponder()
        descripcionText.resignFirstResponder()
    }
    
    
    
    func guardarEventos(id_evento:Int, titulo:String, descripcion:String, fecha_inicio:String, fecha_fin:String, fecha_actualizacion:String, tipo:Int, esLocal:Bool, estado:Int, fechain:String, fechafn:String, inicioDate:NSDate) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "dd-MM-yyyy HH:mm:ss"
         dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
         dateFormatter2.locale = NSLocale(localeIdentifier: "en_US_POSIX")
      /*  let dateFormatter = NSDateFormatter()
        var dateFormatter2 = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter2.locale = NSLocale(localeIdentifier: "en_US_POSIX")*/
        
      //  print(fecha_inicio)
       // print(fecha_fin)
        
        //optional
        var inicio = dateFormatter2.dateFromString(fecha_inicio)
      //  print(inicio)
        var fin = dateFormatter2.dateFromString(fecha_fin)
      //  print(fin)
        var actual = dateFormatter2.dateFromString(fecha_actualizacion)
        let fullNameArr = fechain.characters.split{$0 == "-" || $0 == " "}.map(String.init)
        var newDate  = " "
        newDate = "\(fullNameArr[0])-\(fullNameArr[1])-\(fullNameArr[2]) 12:00:00"
        let fullNameArr2 = fechafn.characters.split{$0 == "-" || $0 == " "}.map(String.init)
        var newDate2  = " "
        newDate2 = "\(fullNameArr2[0])-\(fullNameArr2[1])-\(fullNameArr2[2]) 12:00:00"
       // print("esta es una \(String(Int(fullNameArr2[0])!+1))")
        var ini =  dateFormatter2.dateFromString(newDate)
        var fn =  dateFormatter2.dateFromString(newDate2)
        //optional
        let eventos = Evento()
        let realm = try! Realm()
        let evento = realm.objects(Evento)
        eventos.id_evento = id_evento
        eventos.titulo = titulo
        eventos.descripcion =  descripcion
        eventos.fecha_inicio =  inicioDate
        eventos.fecha_fin = fin!
        eventos.fecha_actualizacion = actual!
        eventos.tipo = tipo
        eventos.esLocal = esLocal
        eventos.estado = estado
        eventos.fecha_inicioc = ini!
        eventos.fecha_finc = fn!
        try! realm.write{
            realm.add(eventos)
           // print("entra")
        }
    }
    
    
    //make an autoincrement id
    func getNextKey() -> Int {
        let realm = try! Realm()
        let allBitacora = realm.objects(Evento)
        var id = allBitacora.count
        return id+1
    }
    
    
    
    //function to show a alert controller
    func publica (messageBody : String, messageTitle: String) {
        let alertController = UIAlertController(title: messageTitle, message:
            messageBody, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,
            handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }
