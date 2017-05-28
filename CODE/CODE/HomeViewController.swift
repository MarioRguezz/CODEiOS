//
//  HomeViewController.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez  & Oscar Barrera Casillas on 19/04/16.
//  Copyright © 2016 CODE. All rights reserved.
//  Class to show the main view, the home with dashboard of water and exercise. Calendar, ads and a toolbar for go to Ejercicio o Hidratación

import UIKit
import RealmSwift
import CVCalendar
import Alamofire
import SwiftyJSON
import SafariServices
import BWWalkthrough
import PKHUD

//images and imagesLink was changed here because you need to keep the information to show after and not download again
var download = false;
var Images: [String] = []
var ImagesLink: [String] = []

class HomeViewController: UIViewController, GIDSignInUIDelegate, UITableViewDataSource, UITableViewDelegate , BWWalkthroughViewControllerDelegate{
    
    
    var t1 = mach_absolute_time()
    
    @IBOutlet weak var ejercicioLabel: UILabel!
    @IBOutlet weak var hidratacionLabel: UILabel!
    @IBOutlet weak var tableviewEventos: UITableView!
    @IBOutlet weak var fechaMes: UILabel!
    @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var minutosLabel: UILabel!
    @IBOutlet weak var litrosCantidad: UILabel!
    @IBOutlet weak var barEjercicio: UIProgressView!
    @IBOutlet weak var publicidadImage: UIImageView!
    var timer = NSTimer()
    @IBOutlet weak var barAgua: UIProgressView!
    var count = 0
    var count2 = 0.0
    var url = ""
    var Arra: [Evento] = []
    
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    
    @IBAction func walkButtonEvent(sender: AnyObject) {
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Help", bundle: nil)
        let walkthrough = stb.instantiateViewControllerWithIdentifier("walk") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewControllerWithIdentifier("walk0")
        let page_one = stb.instantiateViewControllerWithIdentifier("walk1")
        let page_two = stb.instantiateViewControllerWithIdentifier("walk2")
        let page_three = stb.instantiateViewControllerWithIdentifier("walk3")
        let page_four = stb.instantiateViewControllerWithIdentifier("walk4")
        let page_five = stb.instantiateViewControllerWithIdentifier("walk5")
        let page_six = stb.instantiateViewControllerWithIdentifier("walk6")
        let page_seven = stb.instantiateViewControllerWithIdentifier("walk7")
        let page_eight = stb.instantiateViewControllerWithIdentifier("walk8")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.addViewController(page_zero)
        walkthrough.addViewController(page_one)
        walkthrough.addViewController(page_two)
        walkthrough.addViewController(page_three)
        walkthrough.addViewController(page_four)
        walkthrough.addViewController(page_five)
        walkthrough.addViewController(page_six)
        walkthrough.addViewController(page_seven)
        walkthrough.addViewController(page_eight)

        self.presentViewController(walkthrough, animated: true, completion: nil)
    }
    
    
    func walkthroughCloseButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let center = appDelegate.didLogin()
        self.navigationController?.presentViewController(center, animated: true, completion: nil)
    }
    
    
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
      /*  if download == true && Images.count > 0{
             let url = NSURL(string: "http://app.codegto.gob.mx/code_web/src/res/imagenes/\(Images[0])")
             let data = NSData(contentsOfURL: url!)
             publicidadImage.image = UIImage(data: data!)
            chooseUrl(0)
            download = false
        } else{
            progressBarDisplayer("Cargando", true)
        recibeImagenes()
        recibeEventos()
             self.messageFrame.removeFromSuperview()
        }
        cronometro()
      //  firstimage()
        seteaData()
        seteaData2()
        updateViews()*/
        
        // LlenaArray()
        var tap = UITapGestureRecognizer(target: self, action: Selector("changeAd"))
        publicidadImage.addGestureRecognizer(tap)
        publicidadImage.userInteractionEnabled = true
        GIDSignIn.sharedInstance().uiDelegate = self;
        //print(dict)
        NSUserDefaults.standardUserDefaults().setObject(dict, forKey: "toDoList")
        NSUserDefaults.standardUserDefaults().setObject("1", forKey: "DemoWalk")
        var tap2 = UITapGestureRecognizer(target: self, action: Selector("changeAdd"))
        hidratacionLabel.addGestureRecognizer(tap2)
        hidratacionLabel.userInteractionEnabled = true
        var tap3 = UITapGestureRecognizer(target: self, action: Selector("changeAddd"))
        ejercicioLabel.addGestureRecognizer(tap3)
        ejercicioLabel.userInteractionEnabled = true
        
        // Do any additional setup after loading the view.
        
        
        /*  let alertController = UIAlertController(title: "Error", message:
         "Contrato para el consentimiento del titular de sus datos personales en el aplicación móvil de Code.  La Comisión de Deporte del Estado de Guanajuato, se obliga a proteger y hacer un adecuado uso de los datos personales recabados, de conformidad con la Ley de   Protección de Datos Personales para el Estado y los Municipios de Guanajuato, el Reglamento de Procedimientos de la Ley de Protección de Datos Personales para el Estado y los Municipios de Guanajuato, en el Poder Ejecutivo, así como la demás normatividad aplicable. Los datos personales que se resguardan tienen la  finalidad de funcionar como insumos para la gestión de actividades relacionadas con el deporte; dicha información se incorpora a la base de datos de la Comisión de Deporte del", preferredStyle: UIAlertControllerStyle.Alert)
         alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,
         handler: nil))
         var imageView = UIImageView(frame: CGRectMake(10, 10, 250, 400))
         imageView.image = UIImage(named: "face.jpg")
         
         alertController.view.addSubview(imageView)
         
         self.presentViewController(alertController, animated: true, completion: nil)*/
        
        
        
    }
   
    
    func changeAdd()
    {
        // barAgua
        let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Agua") as!    Agua
        let centerNavController = UINavigationController(rootViewController: centerViewController)
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.centerViewController = centerNavController
    }
    
    func changeAddd()
    {
        let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Ejercicio") as!    Ejercicio
        let centerNavController = UINavigationController(rootViewController: centerViewController)
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.centerViewController = centerNavController
    }
    
    
    
    
    
    //Show a video if exits an local alert
    override func viewDidAppear(animated: Bool) {
         HUD.show(HUDContentType.Progress)
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            
            if download == true && Images.count > 0{
                let url = NSURL(string: "http://app.codegto.gob.mx/code_web/src/res/imagenes/\(Images[0])")
                let data = NSData(contentsOfURL: url!)
                self.publicidadImage.image = UIImage(data: data!)
                self.chooseUrl(0)
                download = false
            } else{
                self.progressBarDisplayer("Cargando", true)
                self.recibeImagenes()
                self.recibeEventos()
                self.messageFrame.removeFromSuperview()
            }
           
            //  firstimage()
            self.seteaData()
            self.seteaData2()
            

            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                 self.cronometro()
                self.updateViews()
                  HUD.hide()
            }
        }
        
        download = true
        tableviewEventos.reloadData()
        if let cc = calendarView.contentController as? CVCalendarMonthContentViewController {
            cc.refreshPresentedMonth()
        }
        if(launchVideo){
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            do {
                let x = try appDelegate.playVideo()
            } catch AppError.InvalidResource(let name, let type) {
               // debugPrint("Could not find resource \(name).\(type)")
            } catch {
                //debugPrint("Generic error")
            }
        }
    }
    
    //Get elements and add to array
    func LlenaArray(){
        //  print(Realm.Configuration.defaultConfiguration.fileURL!)
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
    

    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        // print(Arra[indexPath.row])
        let realm = try! Realm()
        try! realm.write {
            let DeletedNotifications = realm.objects(Evento).filter("id_evento == \(Arra[indexPath.row].id_evento) AND titulo == '\(Arra[indexPath.row].titulo)' AND esLocal == \(Arra[indexPath.row].esLocal) AND descripcion == '\(Arra[indexPath.row].descripcion)'")
            realm.delete(DeletedNotifications)
        }
        Arra.removeAtIndex(indexPath.row)
        tableviewEventos.reloadData()
        if let cc = calendarView.contentController as? CVCalendarMonthContentViewController {
            cc.refreshPresentedMonth()
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableviewEventos.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! cellEventoHome
        let titulo = Arra.map { $0.titulo }
        let descripcion = Arra.map { $0.descripcion }
        cell.tituloLabel.text = titulo[indexPath.row]
        if cell.tituloLabel.text == "" {
            cell.fechaLabel.text = ""
        }else{
            cell.fechaLabel.text = calendarView.presentedDate.commonDescription
        }
      //  print( descripcion[indexPath.row])
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
            print("hola \(fechaEnviar)")
        }else{
            fechaEnviar = NSUserDefaults.standardUserDefaults().objectForKey("fecha") as! String
            print("adios")
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.POST, "http://app.codegto.gob.mx/code_web/src/app_php/eventos/nuevosEventos.php", parameters: ["fecha_actualizacion": fechaEnviar])
            .responseJSON { response in switch response.result {
            case .Success(let JSONA):
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                print("Success with JSON: \(JSONA)")
                let swiftyJsonVar = JSON(response.result.value!)
                for (index, x) in swiftyJsonVar.enumerate() {
                    print("el indice del array es \(index) y su valor es \(x)")
                    dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)) {
                      
                    self.guardarEventos(Int(swiftyJsonVar[index]["id_evento"].string!)!,  titulo: swiftyJsonVar[index]["titulo"].string!, descripcion: swiftyJsonVar[index]["descripcion"].string!, fecha_inicio: swiftyJsonVar[index]["fecha_inicio"].string!, fecha_fin: swiftyJsonVar[index]["fecha_fin"].string!, fecha_actualizacion: swiftyJsonVar[index]["fecha_actualizacion"].string!,  tipo: Int(swiftyJsonVar[index]["tipo"].string!)!, esLocal: false, estado:    Int(swiftyJsonVar[index]["estado"].string!)!,  fechain: swiftyJsonVar[index]["fecha_inicio"].string!, fechafn: swiftyJsonVar[index]["fecha_fin"].string! )
                        }
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
        //print(fecha_actualizacion)
        
        var inicio = dateFormatter2.dateFromString(fecha_inicio)
        var fin = dateFormatter2.dateFromString(fecha_fin)
        var actual = dateFormatter2.dateFromString(fecha_actualizacion)
        let fullNameArr = fechain.characters.split{$0 == "-" || $0 == " "}.map(String.init)
        var newDate  = " "
        newDate = "\(fullNameArr[0])-\(fullNameArr[1])-\(fullNameArr[2]) 12:00:00"
        let fullNameArr2 = fechafn.characters.split{$0 == "-" || $0 == " "}.map(String.init)
        var newDate2  = " "
        newDate2 = "\(fullNameArr2[0])-\(fullNameArr2[1])-\(fullNameArr2[2]) 12:00:00"
        var ini =  dateFormatter2.dateFromString(newDate)
        var fn =  dateFormatter2.dateFromString(newDate2)
        //optional
        /*
         if inicio! = inicio! {
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
    
    
    
    func recibeImagenes(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.POST, "http://app.codegto.gob.mx/code_web/src/app_php/imagenes/imagenes.php", parameters: [:])
            .responseJSON { response in switch response.result {
            case .Success(let JSONA):
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                print("Success with JSON ramon: \(JSONA)")
                let swiftyJsonVar = JSON(response.result.value!)
                
                for (index, x) in swiftyJsonVar.enumerate() {
                    //print("el indice del array es \(index) y su valor es \(x)")
                  //   dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)) {
                    self.seteaArray(swiftyJsonVar[index]["img"].string!, link: swiftyJsonVar[index]["link"].string!)
                    }
                self.guardaImages()
            //    print(self.Images)
            //    print(self.ImagesLink)
            case .Failure(let error):
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                print("Request failed with error: \(error)")
                self.publicidadImage.image =  UIImage(named: "pub2.jpg")
                //  self.publica("Verifica tu conexión a internet", "Error")
                }
        }
    }
    
    
    
    func seteaArray (image:String, link:String){
        Images.append(image)
        ImagesLink.append(link)
        
    }
    func guardaImages(){
        var ran = arc4random_uniform(UInt32( Images.count))
      //  print(ran)
      //  print(Images.last)
        var selectorUrl = 0
       // if Images.count < 2 {
        if Images.count == 0 {
            publicidadImage.image =  UIImage(named: "pub1.jpg")
        }else {
            selectorUrl = Int(ran)
            chooseUrl(selectorUrl)
            if let url = NSURL(string: "http://app.codegto.gob.mx/code_web/src/res/imagenes/\(Images[Int(ran)])") {
                if let data = NSData(contentsOfURL: url) {
                    publicidadImage.image = UIImage(data: data)
                } else{
                    publicidadImage.image =  UIImage(named: "pub\(ran).jpg")
                }
            }
        }
           }
    
    //event if you pressed the button you would go the web page depends of the case
    func chooseUrl(option:Int) -> String {
         if Images.count == 0 {
        url = "http://code.guanajuato.gob.mx/"
         } else{
              url =  ImagesLink[option]
        }
       
        return url
        
       /* switch (option) {
        case 0:
            if ImagesLink.count == 0 {
                url = "http://code.guanajuato.gob.mx/"
            }else {
            url =  ImagesLink[0]
            }
            break
        case 1:
            if ImagesLink.count == 0  {
                url = "http://code.guanajuato.gob.mx/"
            }else {
                if ImagesLink.count < 2 {
                url = ImagesLink[0]
                } else{
                url = ImagesLink[1]
                }
            }
            break
        default:
            break
        }
        return url*/
    }
    
    //Timer that change the ads
    func cronometro() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self , selector:("imageChange") , userInfo: nil, repeats: true)
    }
    
    //change the image with the name pub(random).jpg
    func imageChange(){
        
        count++
        var selectorUrl = 0
        if count == 10 {
            var ran = arc4random_uniform(UInt32(Images.count))
            count = 0
            if Images.count == 0 {
                publicidadImage.image =  UIImage(named: "pub1.jpg")
            }else {
            if let url = NSURL(string: "http://app.codegto.gob.mx/code_web/src/res/imagenes/\(Images[Int(ran)])") {
                if let data = NSData(contentsOfURL: url) {
                    publicidadImage.image = UIImage(data: data)
                } else{
                    publicidadImage.image =  UIImage(named: "pub\(ran).jpg")
                }
            }
        }
             selectorUrl = Int(ran)
             chooseUrl(selectorUrl)
        }
    }
    
    
    //random number to change each 10 seconds the ads
    func changeAd()
    {
       // print(arc4random_uniform(2))
       // print("URL \(url)")
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    
    //func firstimage(){
        //   var ran = arc4random_uniform(2) + 1
        //  var selectorUrl = 0
        //  print("http://app.codegto.gob.mx/code_web/src/res/imagenes/\(Images)")
        //  publicidadImage.image = UIImage(named: "http://app.codegto.gob.mx/code_web/src/res/imagenes/\(Images[1])")
        //  selectorUrl = Int(ran)
        // chooseUrl(selectorUrl)
   // }
    /*
     //change the image with the name pub(random).jpg
     func imageChange(){
     count++
     var selectorUrl = 0
     var ran = arc4random_uniform(2) + 1
     if count == 10 {
     count = 0
     publicidadImage.image = UIImage(named: "pub\(ran).jpg")
     selectorUrl = Int(ran)
     }
     chooseUrl(selectorUrl)
     }
     
     //show a random image in the ads
     func firstimage(){
     var ran = arc4random_uniform(2) + 1
     var selectorUrl = 0
     publicidadImage.image = UIImage(named: "pub\(ran).jpg")
     selectorUrl = Int(ran)
     chooseUrl(selectorUrl)
     }
     
     //event if you pressed the button you would go the web page depends of the case
     func chooseUrl(option:Int) -> String {
     switch (option) {
     case 1:
     url =  "http://code.guanajuato.gob.mx/"
     break
     case 2:
     url =  "http://code.guanajuato.gob.mx/"
     break
     default:
     break
     }
     return url
     }
     
     //Timer that change the ads
     func cronometro() {
     timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self , selector:("imageChange") , userInfo: nil, repeats: true)
     }
     
     
     */
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
    
    //Function to show the menu
    @IBAction func leftPressed(sender: AnyObject) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    //function to show Ejercicio wiht the button of toolbar Ejercicio
    @IBAction func ejercicioButton(sender: AnyObject) {
        let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Ejercicio") as!    Ejercicio
        let centerNavController = UINavigationController(rootViewController: centerViewController)
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.centerViewController = centerNavController
        // appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
        
    }
    //function to show Agua wiht the button of toolbar Agua
    @IBAction func aguaButton(sender: AnyObject) {
        let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Agua") as!    Agua
        let centerNavController = UINavigationController(rootViewController: centerViewController)
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.centerViewController = centerNavController
    }
    
    //return in String the due date
    func fechaToday() -> String {
        let date2 = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var strDate2 = dateFormatter.stringFromDate(date2)
        return strDate2
    }
    
    //clousure to var counter  to set the progressbar of exercise
    var counter:Float = 0 {
        didSet {
            var fractionalProgress = counter / 100.0
            let animated = counter != 0
            //30
            if fractionalProgress >= 99.98 {
                fractionalProgress = 1.0
            }
            barEjercicio.setProgress(fractionalProgress, animated: animated)
            
        }
    }
    
    //clousure to var counter2  to set the progressbar of water
    var counter2:Float = 0 {
        didSet {
            var fractionalProgress = counter2 / 100.0
            let animated = counter2 != 0
            barAgua.setProgress(fractionalProgress, animated: animated)
        }
    }
    
    //Check in realm the data of Bitacora and set the progressbar of ejercicio
    func seteaData(){
        var minutos = 0
        let realm = try! Realm()
        let allBitacora = realm.objects(Bitacora)
        var valor = allBitacora.filter("fecha = '\(fechaToday())' AND id_app_login = '\(dict["id_login_app"]!)'")
        for bitacora in valor{
            minutos = bitacora.minutos_ejercicio
        }
        count = minutos
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
    //Check in realm the data of Bitacora and set the progressbar of water
    func seteaData2(){
        var litros = 0.0
        let realm = try! Realm()
        let allBitacora = realm.objects(Bitacora)
        var valor = allBitacora.filter("fecha = '\(fechaToday())' AND id_app_login = '\(dict["id_login_app"]!)'")
        for bitacora in valor{
            litros = bitacora.registro_agua
        }
        count2 = litros
        if count2 >= 2.0 {
            counter2 =  100
        } else if count2 >= 1.5 && count2 <= 1.9 {
            counter2 = 75
        } else if count2 >= 1.0 && count2 <= 1.4 {
            counter2 = 60
        } else if count2 >= 0.5 && count2 <= 0.9 {
            counter2 = 37
        } else if count2 >= 0.1 && count2 <= 0.4{
            counter2 = 15
        }
        else{
            counter2 = 0
        }
        litrosCantidad.text = "\(count2) minutos de ejercicio"
    }
    
    func updateViews(){
        
        //fecha.text = calendarView.presentedDate.commonDescription
        fechaMes.text = calendarView.presentedDate.globalDescription
        
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
    
    
}


// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension HomeViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
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
        
        
        let t2 = mach_absolute_time()
        
        let elapsed = t2 - t1
        var timeBaseInfo = mach_timebase_info_data_t()
        mach_timebase_info(&timeBaseInfo)
        let elapsedNano = elapsed * UInt64(timeBaseInfo.numer) / UInt64(timeBaseInfo.denom);
        
        t1 = mach_absolute_time()
        
        //print("aqui: \(elapsedNano)")
        
        if(elapsedNano < 100308708){
            return
        }
        
        
        //println(elapsedNano)
        
        let fullName = date.commonDescription
        let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
        //print(fullNameArr[0]) // day
      //  print(fullNameArr[1]) // month
        //print(fullNameArr[2]) // year
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
       // print(newDate)
        var inicio = dateFormatter2.dateFromString(newDate)
       // print("\(inicio) aqui")
       // print(date.commonDescription)
        let realm = try! Realm()
        if(inicio != nil){
            let p1 = NSPredicate(format: "%@ >=fecha_inicioc", inicio!)
            let p2 = NSPredicate(format: "%@ <= fecha_finc ", inicio!)
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
            //  let predicate = NSPredicate(format: "fecha_inicio <= %@ AND fecha_fin >= %@", inicio!, inicio! )
            let results = realm.objects(Evento).filter(predicate).filter("estado == 1")
            Arra.removeAll()
            for bitacora in results{
                Arra.append(bitacora)
            }
            tableviewEventos.reloadData()
        }
        //  tableviewEventos.reloadData()
    }
    
    
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    //do a point if the day == x
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        // return false
        //   print(dayView.date.convertedDate()?.description)
        let fullName =  dayView.date.commonDescription
        let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
        //print(fullNameArr[0]) // day
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
        //  dateFormatter2.lenient = true
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
        /*  if day == 10 {
         return true
         }*/
        
        return false
    }
}


// MARK: - CVCalendarViewAppearanceDelegate

extension HomeViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}

// MARK: - IB Actions



// MARK: - Convenience API Demo

extension HomeViewController {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
       // print("aqui toggle")
    }
    
    func didShowNextMonthView(date: NSDate)
    {
        //        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        //print("Showing Month: \(components.month)")
    }
    
    
    func didShowPreviousMonthView(date: NSDate)
    {
        //        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
       // print("Showing Month: \(components.month)")
    }
    
    
    /*
     IMPORTANT
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}