//
//  Calendario.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez  & Oscar Barrera Casillas on 01/05/16.
//  Copyright © 2016 CODE. All rights reserved.
//  Class to show a calendar with a table for the events with Realm

import UIKit
import RealmSwift
import CVCalendar
import Alamofire
import SwiftyJSON


class Calendario: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var arrRes = [[String:AnyObject]]()
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
    @IBOutlet weak var fechaMes: UILabel!
    var Arra: [Evento] = []
    
    @IBOutlet weak var tableviewEventos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        recibeEventos()
         print(Realm.Configuration.defaultConfiguration.fileURL!)
        // LlenaArray()
    }
    
    @IBAction func Helpbutton(sender: AnyObject) {
        
        publicaPolitica("Registra tus​ actividades físicas en nuestro calendario y entérate de los eventos deportivos​ de la CODE")
    }
    
    
    func publicaPolitica(messageBody : String) {
        
        let alertController = UIAlertController(title: "CODE", message:
            messageBody, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,
            handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    //Get elements and add to array
    func LlenaArray(){
       // print(Realm.Configuration.defaultConfiguration.fileURL!)
        let realm = try! Realm()
        let allBitacora = realm.objects(Evento)
        var one = allBitacora
        for bitacora in one{
            Arra.append(bitacora)
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  Arra.count
    }
    
    
    
    @IBAction func trash(sender: AnyObject) {
         tableviewEventos.setEditing(!tableviewEventos.editing, animated: true);
        
    }
    
    
    
    
    //se ejecuta cada vez que se muestre el viewcontroller
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableviewEventos.reloadData()
        if let cc = calendarView.contentController as? CVCalendarMonthContentViewController {
            cc.refreshPresentedMonth()
        }
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
       // print(Arra[indexPath.row])
        let realm = try! Realm()
        try! realm.write {
            //let DeletedNotifications = realm.objects(Evento).filter("id_evento == \(Arra[indexPath.row].id_evento) AND titulo == '\(Arra[indexPath.row].titulo)' AND esLocal == \(Arra[indexPath.row].esLocal) AND descripcion == \(Arra[indexPath.row].descripcion)")
            let DeletedNotifications = realm.objects(Evento).filter("id_evento == \(Arra[indexPath.row].id_evento) AND titulo == '\(Arra[indexPath.row].titulo)' AND esLocal == \(Arra[indexPath.row].esLocal)")
           realm.delete(DeletedNotifications)
          //  print(DeletedNotifications)
        }
        Arra.removeAtIndex(indexPath.row)
        tableviewEventos.reloadData()
        if let cc = calendarView.contentController as? CVCalendarMonthContentViewController {
            cc.refreshPresentedMonth()
        }
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableviewEventos.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! cellEvento
        let titulo = Arra.map { $0.titulo }
        let descripcion = Arra.map { $0.descripcion }
        cell.tituloLabel.text = titulo[indexPath.row]
        if cell.tituloLabel.text == "" {
            cell.fechaLabel.text = ""
        }else{
            cell.fechaLabel.text = calendarView.presentedDate.commonDescription
        }
        cell.descripLabel.text = descripcion[indexPath.row]
        let v = UIView()
        v.backgroundColor = UIColor( red:0.00, green:0.65, blue: 0.90, alpha: 1.0)
        //self.darkerColor(UIColor.blueColor())
        cell.selectedBackgroundView = v;
        return cell
    }
    
    
    
    
    
    func recibeEventos() {
        var fechaEnviar = ""
        if NSUserDefaults.standardUserDefaults().objectForKey("fecha")  == nil {
            fechaEnviar = DueDate()
           // print("hola \(fechaEnviar)")
        }else{
            fechaEnviar = NSUserDefaults.standardUserDefaults().objectForKey("fecha") as! String
           // print("adios")
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.POST, "http://app.codegto.gob.mx/code_web/src/app_php/eventos/nuevosEventos.php", parameters: ["fecha_actualizacion": fechaEnviar])
            .responseJSON { response in switch response.result {
            case .Success(let JSONA):
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                //print("Success with JSON: \(JSONA)")
                let swiftyJsonVar = JSON(response.result.value!)
                for (index, x) in swiftyJsonVar.enumerate() {
                    //print("el indice del array es \(index) y su valor es \(x)")
                    self.guardarEventos(Int(swiftyJsonVar[index]["id_evento"].string!)!,  titulo: swiftyJsonVar[index]["titulo"].string!, descripcion: swiftyJsonVar[index]["descripcion"].string!, fecha_inicio: swiftyJsonVar[index]["fecha_inicio"].string!, fecha_fin: swiftyJsonVar[index]["fecha_fin"].string!, fecha_actualizacion: swiftyJsonVar[index]["fecha_actualizacion"].string!,  tipo: Int(swiftyJsonVar[index]["tipo"].string!)!, esLocal: false, estado:    Int(swiftyJsonVar[index]["estado"].string!)!,  fechain: swiftyJsonVar[index]["fecha_inicio"].string!, fechafn: swiftyJsonVar[index]["fecha_fin"].string! )
                }
            case .Failure(let error):
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
               // print("Request failed with error: \(error)")
                //  self.publica("Verifica tu conexión a internet", "Error")
                }
        }
        tableviewEventos.reloadData()
        if let cc = calendarView.contentController as? CVCalendarMonthContentViewController {
            cc.refreshPresentedMonth()
        }
        NSUserDefaults.standardUserDefaults().setObject(DueDate(), forKey: "fecha")
    }
    
    
    func DueDate() -> String {
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var convertedDate = dateFormatter.stringFromDate(currentDate)
        return convertedDate
    }
    
    
    
    func guardarEventos(id_evento:Int, titulo:String, descripcion:String, fecha_inicio:String, fecha_fin:String, fecha_actualizacion:String, tipo:Int, esLocal:Bool, estado:Int, fechain:String, fechafn:String) {
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
         dateFormatter2.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
         dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        //optional
        var inicio = dateFormatter2.dateFromString(fecha_inicio)
        var fin = dateFormatter2.dateFromString(fecha_fin)
        //print(fecha_actualizacion)
        var actual = dateFormatter2.dateFromString(fecha_actualizacion)
        let fullNameArr = fechain.characters.split{$0 == "-" || $0 == " "}.map(String.init)
        var newDate  = " "
        newDate = "\(fullNameArr[0])-\(fullNameArr[1])-\(fullNameArr[2]) 12:00:00"
        let fullNameArr2 = fechafn.characters.split{$0 == "-" || $0 == " "}.map(String.init)
        var newDate2  = " "
        //cambio día extra
        newDate2 = "\(fullNameArr2[0])-\(fullNameArr2[1])-\(fullNameArr2[2]) 12:00:00"
        //print(newDate2)
        var ini =  dateFormatter2.dateFromString(newDate)
        var fn =  dateFormatter2.dateFromString(newDate2)
        //optional
        //print(inicio!)
        /*
        var horas : NSDate? = nil
        if inicio! == horas {
            let optional1 = fecha_inicio.characters.split{$0 == "-" || $0 == " "}.map(String.init)
            var nuevaFecha1  = " "
            nuevaFecha1 = "\(optional1[0])-\(optional1[1])-\(optional1[2]) 12:00:00"
            inicio = dateFormatter2.dateFromString(nuevaFecha1)
            print("1")
        }
        if fin! == horas {
            let optional2 = fecha_fin.characters.split{$0 == "-" || $0 == " "}.map(String.init)
            var nuevaFecha2  = " "
            nuevaFecha2 = "\(optional2[0])-\(optional2[1])-\(optional2[2]) 12:00:00"
            fin = dateFormatter2.dateFromString(nuevaFecha2)
            print("2")
        }
        if actual! == horas {
            let optional3 = fecha_actualizacion.characters.split{$0 == "-" || $0 == " "}.map(String.init)
            var nuevaFecha3  = " "
            nuevaFecha3 = "\(optional3[0])-\(optional3[1])-\(optional3[2]) 12:00:00"
            actual = dateFormatter2.dateFromString(nuevaFecha3)
            print("3")
            
        }
 */
        let eventos = Evento()
        let realm = try! Realm()
        let evento = realm.objects(Evento).filter("id_evento == \(id_evento)").first
        if  evento?.id_evento != nil {
            try! realm.write {
                evento!.id_evento = id_evento
                evento!.titulo = titulo
                evento!.descripcion =  descripcion
                evento!.fecha_inicio =  inicio!
                evento!.fecha_fin = fin!
                evento!.fecha_actualizacion = actual!
                evento!.tipo = tipo
                evento!.esLocal = esLocal
                evento!.estado = estado
                evento!.fecha_inicioc = ini!
                evento!.fecha_finc = fn!
            } }  else {
            eventos.id_evento = id_evento
            eventos.titulo = titulo
            eventos.descripcion =  descripcion
            eventos.fecha_inicio =  inicio!
            eventos.fecha_fin = fin!
            eventos.fecha_actualizacion = actual!
            eventos.tipo = tipo
            eventos.esLocal = esLocal
            eventos.estado = estado
            eventos.fecha_inicioc = ini!
            eventos.fecha_finc = fn!
            try! realm.write{
                realm.add(eventos)
            }
        }
        
    }
    
    
    
    
    func updateViews(){
        //fecha.text = calendarView.presentedDate.commonDescription
        fechaMes.text = calendarView.presentedDate.globalDescription
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendarView.commitCalendarViewUpdate()
        calendarMenuView.commitMenuViewUpdate()
        
    }
    
    
    @IBAction func nextMonthPressed(sender: AnyObject) {
        calendarView.loadNextView()
    }
    
    @IBAction func previousMonthPressed(sender: AnyObject) {
        calendarView.loadPreviousView()
    }
    
    
    @IBAction func buttonLeftPressed(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
    }
    
    
}



// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension Calendario: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    
    
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    // MARK: Optional methods
    
    
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    func presentedDateUpdated(date: Date) {
        // fecha.text = date.commonDescription
        fechaMes.text = date.globalDescription
        
        
        let fullName = date.commonDescription
        let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
        //  print(fullNameArr[0]) // day
        // print(fullNameArr[1]) // month
        // print(fullNameArr[2]) // year
        var newDate  = " "
        if fullNameArr[1] == "January," || fullNameArr[1] == "enero," {
            newDate = "\(fullNameArr[0])-01-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "February," || fullNameArr[1] == "febrero,"  {
            newDate = "\(fullNameArr[0])-02-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "March," || fullNameArr[1] == "marzo," {
            newDate = "\(fullNameArr[0])-03-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "April," || fullNameArr[1] == "abril,"{
            newDate = "\(fullNameArr[0])-04-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "May," || fullNameArr[1] == "mayo,"{
            newDate = "\(fullNameArr[0])-05-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "June," || fullNameArr[1] == "junio," {
            newDate = "\(fullNameArr[0])-06-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "July," || fullNameArr[1] == "julio,"  {
            newDate = "\(fullNameArr[0])-07-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "August," || fullNameArr[1] == "agosto," {
            newDate = "\(fullNameArr[0])-08-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "September," || fullNameArr[1] == "septiembre," {
            newDate = "\(fullNameArr[0])-09-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "October," || fullNameArr[1] == "octubre," {
            newDate = "\(fullNameArr[0])-10-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "November," || fullNameArr[1] == "noviembre," {
            newDate = "\(fullNameArr[0])-11-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "December," || fullNameArr[1] == "diciembre," {
            newDate = "\(fullNameArr[0])-12-\(fullNameArr[2]) 12:00:00"
        }
        let dateFormatter2 = NSDateFormatter()
        //  dateFormatter2.locale = NSLocale.currentLocale()
        dateFormatter2.dateFormat = "dd-MM-yyyy HH:mm:ss"
         dateFormatter2.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        var inicio = dateFormatter2.dateFromString(newDate)
        //print(inicio)
       // print(date.commonDescription)
        let realm = try! Realm()
        if(inicio != nil){
            let p1 = NSPredicate(format: "%@ >=fecha_inicioc", inicio!)
            let p2 = NSPredicate(format: "%@ <= fecha_finc ", inicio!)
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
            //  let predicate = NSPredicate(format: "fecha_inicio <= %@ AND fecha_fin >= %@", inicio!, inicio! )
            let results = realm.objects(Evento).filter(predicate).filter("estado == 1")
            Arra.removeAll()
           /* if results.count == 0 {
                
                let p1 = NSPredicate(format: "%@ >=fecha_inicioc", inicio!)
                let p2 = NSPredicate(format: "%@ <= fecha_finc ", inicio!)
                // let p3 = NSPredicate(format: "fecha_inicio BETWEEN {3, 5}", inicio!)
                let predicate = NSPredicate(format: "fecha_inicioc >= %@ AND fecha_finc <= %@", inicio!, inicio!)
                //  let predicate = NSPredicate(format: "fecha_inicio <= %@ AND fecha_fin >= %@", inicio!, inicio! )
                let results = realm.objects(Evento).filter(p1)
                realm.objects(Evento)
                for bitacora in results{
                    Arra.append(bitacora)
                    print("esta \(results)")
                }
            } else {*/
            for bitacora in results{
                Arra.append(bitacora)
            }
           // }
            //Better scroll with null object
            let eventos = Evento()
            eventos.titulo = ""
            eventos.descripcion =  ""
            Arra.append(eventos)
            tableviewEventos.reloadData()
        }
        
        
    }
    
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    
    
    
    
    
    //do a point if the day == x
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        // return false
        //print(dayView.date.convertedDate()?.description)
        let fullName =  dayView.date.commonDescription
        let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
        //  print(fullNameArr[0]) // day
        // print(fullNameArr[1]) // month
        // print(fullNameArr[2]) // year
        var newDate  = " "
        if fullNameArr[1] == "January," || fullNameArr[1] == "enero," {
            newDate = "\(fullNameArr[0])-01-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "February," || fullNameArr[1] == "febrero,"  {
            newDate = "\(fullNameArr[0])-02-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "March," || fullNameArr[1] == "marzo," {
            newDate = "\(fullNameArr[0])-03-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "April," || fullNameArr[1] == "abril,"{
            newDate = "\(fullNameArr[0])-04-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "May," || fullNameArr[1] == "mayo,"{
            newDate = "\(fullNameArr[0])-05-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "June," || fullNameArr[1] == "junio," {
            newDate = "\(fullNameArr[0])-06-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "July," || fullNameArr[1] == "julio," {
            newDate = "\(fullNameArr[0])-07-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "August," || fullNameArr[1] == "agosto," {
            newDate = "\(fullNameArr[0])-08-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "September," || fullNameArr[1] == "septiembre," {
            newDate = "\(fullNameArr[0])-09-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "October," || fullNameArr[1] == "octubre," {
            newDate = "\(fullNameArr[0])-10-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "November," || fullNameArr[1] == "noviembre," {
            newDate = "\(fullNameArr[0])-11-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "December," || fullNameArr[1] == "diciembre," {
            newDate = "\(fullNameArr[0])-12-\(fullNameArr[2]) 12:00:00"
        }
        let dateFormatter2 = NSDateFormatter()
        //  dateFormatter2.locale = NSLocale.currentLocale()
        dateFormatter2.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter2.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        var inicio = dateFormatter2.dateFromString(newDate)
        let realm = try! Realm()
        if(inicio != nil){
            let p1 = NSPredicate(format: "%@ >=fecha_inicioc", inicio!)
            let p2 = NSPredicate(format: "%@ <= fecha_finc ", inicio!)
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
            //  let predicate = NSPredicate(format: "fecha_inicio <= %@ AND fecha_fin >= %@", inicio!, inicio! )
            let results = realm.objects(Evento).filter(predicate).filter("estado == 1")
            for bitacora in results{
                return true
            }
        }
        
        return false
    }
    
    // give color and number of points
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        /*let red = CGFloat(arc4random_uniform(600) / 255)
         let green = CGFloat(arc4random_uniform(600) / 255)
         let blue = CGFloat(arc4random_uniform(600) / 255)
         
         let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
         
         //        let numberOfDots = Int(arc4random_uniform(3) + 1)
         let numberOfDots = Int(arc4random_uniform(3) + 1)
         switch(numberOfDots) {
         case 2:
         return [color, color]
         case 3:
         return [color, color, color]
         default:
         return [color] // return 1 dot
         }*/
        
        let fullName =  dayView.date.commonDescription
        let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
        //  print(fullNameArr[0]) // day
        // print(fullNameArr[1]) // month
        // print(fullNameArr[2]) // year
        var newDate  = " "
        if fullNameArr[1] == "January," || fullNameArr[1] == "enero," {
            newDate = "\(fullNameArr[0])-01-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "February," || fullNameArr[1] == "febrero,"  {
            newDate = "\(fullNameArr[0])-02-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "March," || fullNameArr[1] == "marzo," {
            newDate = "\(fullNameArr[0])-03-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "April," || fullNameArr[1] == "abril,"{
            newDate = "\(fullNameArr[0])-04-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "May," || fullNameArr[1] == "mayo,"{
            newDate = "\(fullNameArr[0])-05-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "June," || fullNameArr[1] == "junio," {
            newDate = "\(fullNameArr[0])-06-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "July," || fullNameArr[1] == "julio,"  {
            newDate = "\(fullNameArr[0])-07-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "August," || fullNameArr[1] == "agosto," {
            newDate = "\(fullNameArr[0])-08-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "September," || fullNameArr[1] == "septiembre," {
            newDate = "\(fullNameArr[0])-09-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "October," || fullNameArr[1] == "octubre," {
            newDate = "\(fullNameArr[0])-10-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "November," || fullNameArr[1] == "noviembre," {
            newDate = "\(fullNameArr[0])-11-\(fullNameArr[2]) 12:00:00"
        }
        if fullNameArr[1] == "December," || fullNameArr[1] == "diciembre," {
            newDate = "\(fullNameArr[0])-12-\(fullNameArr[2]) 12:00:00"
        }
        let dateFormatter2 = NSDateFormatter()
        //  dateFormatter2.locale = NSLocale.currentLocale()
        dateFormatter2.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter2.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        var inicio = dateFormatter2.dateFromString(newDate)
        let realm = try! Realm()
        let p1 = NSPredicate(format: "%@ >=fecha_inicioc", inicio!)
        let p2 = NSPredicate(format: "%@ <= fecha_finc ", inicio!)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
        //  let predicate = NSPredicate(format: "fecha_inicio <= %@ AND fecha_fin >= %@", inicio!, inicio! )
        let results = realm.objects(Evento).filter(predicate).filter("estado == 1")
        var cont: Int = 0
        for bitacora in results{
            cont = cont+1
        }
        
        
        
        let color = UIColor( red:0.00, green:0.65, blue: 0.90, alpha: 1.0)
        
        
        switch(cont) {
        case 1:
            return [color] // return 1 dot
        case 2:
            return [color, color]
        case 3:
            return [color, color, color]
        default:
            return [color, color, color]
            
        }
        
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    //size of the point
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 15
    }
    
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .Short
    }
    
    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRectMake(0, 0, $0.width, $0.height)) }
    }
    
    func shouldShowCustomSingleSelection() -> Bool {
        return false
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
        circleView.fillColor = .colorFromCode(0xCCCCCC)
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        let π = M_PI
        
        let ringSpacing: CGFloat = 3.0
        let ringInsetWidth: CGFloat = 1.0
        let ringVerticalOffset: CGFloat = 1.0
        var ringLayer: CAShapeLayer!
        let ringLineWidth: CGFloat = 4.0
        let ringLineColour: UIColor = .blueColor()
        
        let newView = UIView(frame: dayView.bounds)
        
        let diameter: CGFloat = (newView.bounds.width) - ringSpacing
        let radius: CGFloat = diameter / 2.0
        
        let rect = CGRectMake(newView.frame.midX-radius, newView.frame.midY-radius-ringVerticalOffset, diameter, diameter)
        
        ringLayer = CAShapeLayer()
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.CGColor
        
        let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
        let ringRect: CGRect = CGRectInset(rect, ringLineWidthInset, ringLineWidthInset)
        let centrePoint: CGPoint = CGPointMake(ringRect.midX, ringRect.midY)
        let startAngle: CGFloat = CGFloat(-π/2.0)
        let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
        let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        ringLayer.path = ringPath.CGPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        
        let day = dayView.date?.day
        /*if day == 10 {
         return true
         }*/
        
        return false
    }
}


// MARK: - CVCalendarViewAppearanceDelegate

extension Calendario: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}

// MARK: - IB Actions



// MARK: - Convenience API Demo

extension Calendario {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
    
    func didShowNextMonthView(date: NSDate)
    {
        //        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
       // print("Showing Month: \(components.month)")
    }
    
    
    func didShowPreviousMonthView(date: NSDate)
    {
        //        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
       // print("Showing Month: \(components.month)")
    }
    
}
