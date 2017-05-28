//
//  MiPerfil.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez   & Oscar Barrera Casillas on 01/05/16.
//  Copyright © 2016 CODE. All rights reserved.
//  Class for the user's profile

import UIKit
import Alamofire
import PKHUD



class MiPerfil: UIViewController,  UITextFieldDelegate,  UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    
    @IBOutlet weak var actualizarPerfilButton: UIButton!
    @IBOutlet weak var messageIMCText: UILabel!
    @IBOutlet weak var imcLabel: UILabel!
    @IBOutlet weak var estaturaText: UITextField!
    @IBOutlet weak var pesoText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var actualizarButton: UIButton!
    @IBOutlet weak var switchPolitica: UISwitch!
    @IBOutlet weak var nombreText: UITextField!
    // @IBOutlet weak var fechaText: UITextField!
    @IBOutlet weak var codigoText: UITextField!
    @IBOutlet weak var celularText: UITextField!
    @IBOutlet weak var generoText: UITextField!
    @IBOutlet weak var ocupacionText: UITextField!
    @IBOutlet weak var actividadFisicaText: UITextField!
    @IBOutlet weak var presionText: UITextField!
    @IBOutlet weak var glucosaText: UITextField!
    @IBOutlet weak var lesionText: UITextField!
    var pickerDataActividad = UIPickerView()
    var pickerDataPresion =  UIPickerView()
    var pickerDataGlucosa =  UIPickerView()
    var pickerDataLesion =  UIPickerView()
    var pickerDataGenero = UIPickerView()
    var pickerDataOcupacion = UIPickerView()
    var pickerDataGeneroDatos = ["Género","Hombre", "Mujer"];
    var pickerDataOcupacionDatos = ["Ocupación","Profesor", "Empleado", "Empresario", "Abogado", "Estudiante", "Ingeniero", "Doctor", "Arquitecto", "Ama de casa", "Empleado Calzado", "Obrero", "Comerciante", "Enfermera"];
    var pickerDataActividadDatos = ["Sí", "No"];
    var pickerDataPresionDatos = ["Sí", "No"];
    var pickerDataGlucosaDatos = ["Sí", "No"];
    var pickerDataLesionDatos = ["Sí", "No"];
    var respuestaPresion = ""
    var respuestaGlucosa = ""
    var respuestaFisico = ""
    var respuestaLesion = ""
    var respuestaEstado = ""
    var respuestaGenero = ""
    var respuestaOcupacion = ""
    var error = 0
    var minlengthnombre = 0
    var minlengtcodigo = 0
    var minlengtcelular = 0
    var fechaText = ""
    
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
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
    //Connect with the server to update the information
    @IBAction func datosButton(sender: AnyObject) {
        var nombre = ""
        var codigo = ""
        var tel = ""
        var peso = ""
        var estatura = ""
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        fechaText = strDate
        nombre = nombreText.text!
        codigo = codigoText.text!
        tel = celularText.text!
        peso = pesoText.text!
        estatura = estaturaText.text!
        //print("lesion \(respuestaLesion) glucosa \(respuestaGlucosa) fisico \(respuestaFisico)  presion \(respuestaPresion) ")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        HUD.show(HUDContentType.Progress)
        Alamofire.request(.POST, "http://app.codegto.gob.mx/code_web/src/app_php/registro/actualizarPerfil.php", parameters: ["id_login_app":dict["id_login_app"]!, "nombre": nombre , "genero": respuestaGenero, "fec_nacimiento": fechaText , "ocupacion": respuestaOcupacion, "codigo_postal": codigo,  "telefono": tel, "peso": peso, "estatura": estatura,"presion": respuestaPresion, "glucosa":respuestaGlucosa, "actividad": respuestaFisico, "lesion": respuestaLesion  ])
            .responseString { response in switch response.result {
            case .Success(let JSON):
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                //print("Success with JSON: \(JSON)")
                let response = JSON as! String
                if  response == "success" {
                   // if DeviceType.isIPhone4 {
                   // } else{
                       self.publicabien("Datos actualizados")
                 //   self.publica("Verifica tu conexión a internet")
                   // }
                }
            case .Failure(let error):
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                //print("Request failed with error: \(error)")
                //if DeviceType.isIPhone4 {
              //  } else{
                    self.publica("Verifica tu conexión a internet")
                //}
                }
                  HUD.hide()
        }
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.actualizarPerfilButton.backgroundColor = UIColor(red:0.23, green:0.33, blue:0.61, alpha:1.0)
        self.pickerDataOcupacion.dataSource = self;
        initialComponent()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard")))
        switchPolitica.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        datePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        nombreText.delegate = self
        codigoText.delegate = self
        celularText.delegate = self
        progressBarDisplayer("Cargando", true)
        cargaDatos()
        self.messageFrame.removeFromSuperview()
           }
    
    
    func operacion(){
        let imc:Double
        let peso = pesoText.text
        let estatura = estaturaText.text
        if peso == "" || estatura == "" {
            imc = 0.0
            imcLabel.text = "0"
            publica("ingresa un valor")
        }else{
            imc =   Double(peso!)! / (Double(estatura!)! *  Double(estatura!)! )
            let value =  String(imc.roundToPlaces(2))
            imcLabel.text = value
            if imc < 25.0 {
                 messageIMCText.text = " "
            }
            if imc  >= 25.0  && imc <= 29.9 {
                messageIMCText.text = "Cuidado, tu IMC indica un sobrepeso"
            }
            if imc > 30.0{
                 messageIMCText.text = "Cuidado, tu IMC indica obesidad"
            }
        }
         var x = imcLabel.text
        if imcLabel.text == "nan" {
            imcLabel.text = "0"
        }
    }
    
   
    @IBAction func HelpButton(sender: AnyObject) {
        publicaPolitica2("El valor del IMC debe confirmarse ​con un especialista o en las instalaciones de la CODE ya que no se consideran valores de músculo y grasa. Tampoco aplica para menores de edad.")
    }
    
    
    func publicaPolitica2(messageBody : String) {
        
        let alertController = UIAlertController(title: "CODE", message:
            messageBody, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,
            handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    
    
    
    
    func initialComponent(){
        switchPolitica.setOn(false, animated:true)
        generoText.delegate = self;
        ocupacionText.delegate = self;
        self.pickerDataGenero.dataSource = self;
        self.pickerDataGenero.delegate = self;
        self.pickerDataOcupacion.dataSource = self;
        self.pickerDataOcupacion.delegate = self;
        generoText.inputView = pickerDataGenero
        ocupacionText.inputView = pickerDataOcupacion
        actividadFisicaText.delegate = self
        presionText.delegate = self
        glucosaText.delegate = self
        lesionText.delegate = self
        self.pickerDataActividad.dataSource = self;
        self.pickerDataActividad.delegate = self;
        self.pickerDataPresion.dataSource = self;
        self.pickerDataPresion.delegate = self;
        self.pickerDataGlucosa.dataSource = self;
        self.pickerDataGlucosa.delegate = self;
        self.pickerDataLesion.dataSource = self;
        self.pickerDataLesion.delegate = self;
        actividadFisicaText.inputView = pickerDataActividad
        presionText.inputView = pickerDataPresion
        glucosaText.inputView = pickerDataGlucosa
        lesionText.inputView = pickerDataLesion

    }
    
    //hide the keyboard
    func dismissKeyboard() {
        nombreText.resignFirstResponder()
        //   fechaText.resignFirstResponder()
        codigoText.resignFirstResponder()
        celularText.resignFirstResponder()
        generoText.resignFirstResponder()
        ocupacionText.resignFirstResponder()
        pesoText.resignFirstResponder()
        estaturaText.resignFirstResponder()
        actividadFisicaText.resignFirstResponder()
        presionText.resignFirstResponder()
        glucosaText.resignFirstResponder()
        lesionText.resignFirstResponder()
        operacion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    //number of components in the view
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Number of row for each picker view
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerDataGenero{
            return pickerDataGeneroDatos.count;
        } else  if  pickerView ==  pickerDataActividad{
            return pickerDataActividadDatos.count;
        } else if pickerView == pickerDataPresion {
            return pickerDataPresionDatos.count;
        } else if pickerView == pickerDataGlucosa {
            return pickerDataGlucosaDatos.count;
        } else if pickerView == pickerDataLesion{
            return pickerDataLesionDatos.count;
        } else {
            return pickerDataOcupacionDatos.count;
        }
        
    }
    
    //name of each picker view
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == pickerDataGenero {
            return pickerDataGeneroDatos[row]
        } else  if  pickerView ==  pickerDataActividad{
            return pickerDataActividadDatos[row];
        } else if pickerView == pickerDataPresion {
            return pickerDataPresionDatos[row];
        } else if pickerView == pickerDataGlucosa {
            return pickerDataGlucosaDatos[row];
        } else if pickerView == pickerDataLesion{
            return pickerDataLesionDatos[row];
        }else{
            return pickerDataOcupacionDatos[row]
        }
        
    }
    
    //function of each row
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == pickerDataGenero {
            if(row == 0)
            {
                error = 1
            }
            else  if(row == 1)
            {
                generoText.text =  "Hombre"
                respuestaGenero = "1"
                
            } else{
                generoText.text =  "Mujer"
                respuestaGenero = "2"
            }
        } else if pickerView == pickerDataActividad {
            if(row == 0)
            {
                actividadFisicaText.text =  "Sí"
                respuestaFisico = "1"
                error = 0
                
                
            }
            else  if(row == 1)
            {
                actividadFisicaText.text =  "No"
                respuestaFisico = "0"
                error = 0
                
            }
        } else if pickerView == pickerDataGlucosa {
           // print(row)
            if(row == 0)
            {
                glucosaText.text =  "Sí"
                respuestaGlucosa = "1"
                error = 0
            }
            else  if(row == 1)
            {
                
                glucosaText.text =  "No"
                respuestaGlucosa = "0"
                error = 0
                
            }
        } else  if pickerView == pickerDataPresion {
            if(row == 0)
            {
                presionText.text =  "Sí"
                respuestaPresion = "1"
                error = 0

            }
            else  if(row == 1)
            {
                presionText.text =  "No"
                respuestaPresion = "0"
                error = 0
 
            }
        } else if pickerView == pickerDataLesion {
            if(row == 0)
            {
                lesionText.text =  "Sí"
                respuestaLesion = "1"
                error = 0
            }
            else  if(row == 1)
            {
                lesionText.text =  "No"
                respuestaLesion = "0"
                error = 0
            }
            
        }
        else {
            if(row == 0)
            {
                error = 1
            }
            else if (row == 1)
            {
                ocupacionText.text = "Profesor"
                respuestaOcupacion="1"
            }else if (row == 2)
            {
                ocupacionText.text = "Empleado"
                respuestaOcupacion="2"
            }
            else if (row == 3)
            {
                ocupacionText.text = "Empresario"
                respuestaOcupacion="3"
            }
            else if (row == 4)
            {
                ocupacionText.text = "Abogado"
                respuestaOcupacion="4"
            }
            else if (row == 5)
            {
                ocupacionText.text = "Estudiante"
                respuestaOcupacion="5"
            }
            else if (row == 6)
            {
                ocupacionText.text = "Ingeniero"
                respuestaOcupacion="6"
            }
            else if (row == 7)
            {
                ocupacionText.text = "Doctor"
                respuestaOcupacion="7"
            }
            else if (row == 8)
            {
                ocupacionText.text = "Arquitecto"
                respuestaOcupacion="8"
            }
            else if (row == 9)
            {
                ocupacionText.text = "Ama de casa"
                respuestaOcupacion="9"
            }
            else if (row == 10)
            {
                ocupacionText.text = "Empleado Calzado"
                respuestaOcupacion="10"
            }
            else if (row == 11)
            {
                ocupacionText.text = "Obrero"
                respuestaOcupacion="11"
            }
            else if (row == 12)
            {
                ocupacionText.text = "Comerciante"
                respuestaOcupacion="12"
            }
            else{
                ocupacionText.text = "Enfermera"
                respuestaOcupacion="13"
            }
        }
        
    }
    
    //move the view to have enough space for the keyboard
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    //function to show a alert controller
    
    func publica (messageBody : String) {
        let alertController = UIAlertController(title: "Error", message:
            messageBody, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,
            handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    //function to show a alert controller
    
    func publicabien(messageBody : String) {
        
        let alertController = UIAlertController(title: "CODE", message:
            messageBody, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,
            handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    func publicaPolitica(messageBody : String) {
        
        let alertController = UIAlertController(title: "Aviso de Privacidad", message:
            messageBody, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,
            handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    //show home view
    @IBAction func buttonLeft(sender: AnyObject) {
        /*let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as!    HomeViewController
        let centerNavController = UINavigationController(rootViewController: centerViewController)
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.centerViewController = centerNavController*/
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    
    
    func convertString(string: String) -> String {
        var data = string.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        return NSString(data: data!, encoding: NSASCIIStringEncoding) as! String
    }
    
    
    
    //check if the switch state was changed
    func stateChanged(switchState: UISwitch) {
        if DeviceType.isIPhone4 {
            if switchState.on {
                actualizarButton.hidden = false
            } else {
                actualizarButton.hidden = true
            }
        }else{
            if switchState.on {
                publicaPolitica("Comisión de Deporte del Estado de Guanajuato, mejor conocido como CODE Guanajuato, con domicilio en calle Carr. Gto Dolores Hgo. Km. 1.5, colonia Valenciana, ciudad Guanajuato, municipio o delegación Guanajuato, c.p.36000, en la entidad de Guanajuato, país México, y portal de internet codegto.gob.mx, es el responsable del uso y protección de sus datos personales, y al respecto le informamos lo siguiente:¿Para qué fines utilizaremos sus datos personales? Los datos personales que recabamos de usted, los utilizaremos para las siguientes finalidades que son necesarias para el servicio que solicita: Para verificar y confirmar su identidad y situación patrimonial Para administrar y operar los servicios que contrata con la Comisión Mercadotecnia o publicitaria Prospección comercial ¿Qué datos personales utilizaremos para estos fines? Para llevar a cabo las finalidades descritas en el presente aviso de privacidad, utilizaremos los siguientes datos personales: Datos de identificación Datos de contacto Datos sobre características físicas Datos laborales Datos académicos Datos migratorios Datos patrimoniales y/o financieros ¿Cómo puede acceder, rectificar o cancelar sus datos personales, u oponerse a su uso? Usted tiene derecho a conocer qué datos personales tenemos de usted, para qué los utilizamos y las condiciones del uso que les damos (Acceso). Asimismo, es su derecho solicitar la corrección de su información personal en caso de que esté desactualizada, sea inexacta o incompleta (Rectificación); que la eliminemos de nuestros registros o bases de datos cuando considere que la misma no está siendo utilizada adecuadamente (Cancelación); así como oponerse al uso de sus datos personales para fines específicos (Oposición). Estos derechos se conocen como derechos ARCO. Para el ejercicio de cualquiera de los derechos ARCO, usted deberá presentar la solicitud respectiva a través del siguiente medio: mediante escrito ante la oficina de la Unidad de Acceso, ubicada en Paseo de la Presa número 170, Zona Centro, Guanajuato, Guanajuato, C.P. 36000. Para conocer el procedimiento y requisitos para el ejercicio de los derechos ARCO, ponemos a su disposición el siguiente medio: mediante escrito Los datos de contacto de la persona o departamento de datos personales, que está a cargo de dar trámite a las solicitudes de derechos ARCO, son los siguientes: a.Nombre de la persona o departamento de datos personales: Unidad de Acceso a la Información b.Domicilio: calle San Sebastián 78, colonia Zona Centro, ciudad Guanajuato., municipio o delegación Guanajuato, c.p. 36000., en la entidad de Guanajuato, país México c.Correo electrónico: unidadacceso@guanajuato.gob.mx Usted puede revocar su consentimiento para el uso de sus datos personales Usted puede revocar el consentimiento que, en su caso, nos haya otorgado para el tratamiento de sus datos personales. Sin embargo, es importante que tenga en cuenta que no en todos los casos podremos atender su solicitud o concluir el uso de forma inmediata, ya que es posible que por alguna obligación legal requiramos seguir tratando sus datos personales. Asimismo, usted deberá considerar que para ciertos fines, la revocación de su consentimiento implicará que no le podamos seguir prestando el servicio que nos solicitó, o la conclusión de su relación con nosotros. Para revocar su consentimiento deberá presentar su solicitud a través del siguiente medio: Por escrito Para conocer el procedimiento y requisitos para la revocación del consentimiento, ponemos a su disposición el siguiente medio: Por escrito dirigido al titular de la Comisión ¿Cómo puede limitar el uso o divulgación de su información personal? Con objeto de que usted pueda limitar el uso y divulgación de su información personal, le ofrecemos los siguientes medios: Por escrito ¿Cómo puede conocer los cambios en este aviso de privacidad? El presente aviso de privacidad puede sufrir modificaciones, cambios o actualizaciones derivadas de nuevos requerimientos legales; de nuestras propias necesidades por los productos o servicios que ofrecemos; de nuestras prácticas de privacidad; de cambios en nuestro modelo de negocio, o por otras causas. Nos comprometemos a mantenerlo informado sobre los cambios que pueda sufrir el presente aviso de privacidad, a través de: Por medio escrito. El procedimiento a través del cual se llevarán a cabo las notificaciones sobre cambios o actualizaciones al presente aviso de privacidad es el siguiente: Solicitud por escrito.Su consentimiento para el tratamiento de sus datos personales Consiento que mis datos personales sean tratados de conformidad con los términos y condiciones informados en el presente aviso de privacidad.Sí acepto al presionar el botón de aceptar")
                //marcando en la siguiente casilla: No acepto.
                actualizarButton.hidden = false
            } else {
                actualizarButton.hidden = true
            }
        }
    }
    
    //get the date when use the date
    func datePickerChanged(datePicker:UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        fechaText = strDate
    }
    
    //load information of the server
    func cargaDatos(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        HUD.show(HUDContentType.Progress)
            // Completion Handler
        Alamofire.request(.POST, "http://app.codegto.gob.mx/code_web/src/app_php/registro/obtenerPerfil.php", parameters: ["id_login_app":dict["id_login_app"]!])
            .responseJSON{
                response in switch response.result {
                case .Success(let JSON):
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    //print("Success with JSON: \(JSON)  \(dict["id_login_app"])")
                    let response = JSON as! NSDictionary
                    print ("\(response)")
                    if let success = response.objectForKey("success") as? String {
                        if success == "true" {
                           // print(String(response.objectForKey("nombre")!))
                            if String(response.objectForKey("nombre")!) == "<null>" {
                                
                            } else{
                                self.nombreText.text = String(response.objectForKey("nombre")!)
                            }
                            self.respuestaGenero = String(response.objectForKey("id_genero")!)
                            self.asignGenero(self.respuestaGenero)
                            if String(response.objectForKey("codigo_postal")!) == "<null>" {
                                
                            }else{
                                self.codigoText.text = String(response.objectForKey("codigo_postal")!)
                            }
                            let strDate = String(response.objectForKey("fec_nacimiento")!)
                            self.asignDate(strDate)
                            if String(response.objectForKey("telefono")!) == "<null>" {
                                
                            }else{
                                self.celularText.text = String(response.objectForKey("telefono")!)
                            }
                            if String(response.objectForKey("id_ocupacion")!)  == "<null>" {
                                
                            }else {
                                self.respuestaOcupacion = String(response.objectForKey("id_ocupacion")!)
                                self.asignTrabajo(self.respuestaOcupacion)
                            }
                            if String(response.objectForKey("peso")!)  == "<null>" {
                                
                            }else {
                                self.pesoText.text = String(response.objectForKey("peso")!)
                            }
                            if String(response.objectForKey("actividad_fisica")!)  == "<null>" {
                                
                            }else {
                                self.respuestaFisico = String(response.objectForKey("actividad_fisica")!)
                                self.asignEjercicio(self.respuestaFisico)
                            }
                            if String(response.objectForKey("presion")!)  == "<null>" {
                                
                            }else {
                                self.respuestaPresion = String(response.objectForKey("presion")!)
                                self.asignPresion(self.respuestaPresion)
                            }
                            if String(response.objectForKey("glucosa_elevada")!)  == "<null>" {
                                
                            }else {
                                self.respuestaGlucosa = String(response.objectForKey("glucosa_elevada")!)
                                self.asignGlucosa(self.respuestaGlucosa)
                            }
                            if String(response.objectForKey("lesion")!)  == "<null>" {
                                
                            }else {
                                self.respuestaLesion = String(response.objectForKey("lesion")!)
                                self.asignLesion(self.respuestaLesion)
                            }
                            
                            if String(response.objectForKey("estatura")!)  == "<null>" {
                                
                            }else {
                                self.estaturaText.text = String(response.objectForKey("estatura")!)
                            }
                        }else{
                        }
                        self.operacion()
                    }
                case .Failure(let error):
                   // print(dict["id_login_app"])
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    print("Request failed with error: \(error)")
                    if DeviceType.isIPhone4 {
                    } else{
                        self.publica("Verifica tu conexión a internet")
                    }
                }
                
                HUD.hide()
        }
        
    }
    
    
    
    
    //asign a number of the data from the sever
    func asignEjercicio(respuestaEjercicio: String){
        if(respuestaEjercicio == "0")
        {
            actividadFisicaText.text = "No"
        }
        else if (respuestaEjercicio == "1")
        {
            actividadFisicaText.text = "Sí"
        }
    }
    
        //asign a presion of the data from the sever
        func asignPresion(respuestaPresion: String){
            if(respuestaPresion == "0")
            {
                 presionText.text = "No"
            }
            else if (respuestaPresion == "1")
            {
                presionText.text = "Sí"
            }
        }
        
            
            //asign a number of the data from the sever
            func asignGlucosa(respuestaGlucosa: String){
                if(respuestaGlucosa == "0")
                {
                    glucosaText.text = "No"
                    print("Hola")
                }
                else if (respuestaGlucosa == "1")
                {
                    glucosaText.text = "Sí"
                    print("Adios")
                }
            }
        
        //asign a number of the data from the sever
        func asignLesion(respuestaLesion: String){
            if(respuestaLesion == "0")
            {
                lesionText.text = "No"
            }
            else if (respuestaLesion == "1")
            {
                lesionText.text = "Sí"
            }
        }
        
        
        
    
    //asign a date of the data from the sever
    func asignDate(strDate: String) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.datePicker.date = dateFormatter.dateFromString( strDate )!
    }
    
    //asign a gender of the data from the sever
    func asignGenero(respuestaGenero:String) {
        if self.respuestaGenero == "1"{
            self.generoText.text = "Hombre"
        } else{
            self.generoText.text = "Mujer"
        }
        
    }
    
    
        
        
        
    
    //asign a job of the data from the sever
    func asignTrabajo(respuestaOcupacion: String){
        if(respuestaOcupacion == "0")
        {
            error = 1
        }
        else if (respuestaOcupacion == "1")
        {
            ocupacionText.text = "Profesor"
        }else if (respuestaOcupacion == "2")
        {
            ocupacionText.text = "Empleado"
        }
        else if (respuestaOcupacion == "3")
        {
            ocupacionText.text = "Empresario"
        }
        else if (respuestaOcupacion == "4")
        {
            ocupacionText.text = "Abogado"
        }
        else if (respuestaOcupacion == "5")
        {
            ocupacionText.text = "Estudiante"
        }
        else if (respuestaOcupacion == "6")
        {
            ocupacionText.text = "Ingeniero"
        }
        else if (respuestaOcupacion == "7")
        {
            ocupacionText.text = "Doctor"
        }
        else if (respuestaOcupacion == "8")
        {
            ocupacionText.text = "Arquitecto"
        }
        else if (respuestaOcupacion == "9")
        {
            ocupacionText.text = "Ama de casa"
        }
        else if (respuestaOcupacion == "10")
        {
            ocupacionText.text = "Empleado Calzado"        }
        else if (respuestaOcupacion == "11")
        {
            ocupacionText.text = "Obrero"
        }
        else if (respuestaOcupacion == "12")
        {
            ocupacionText.text = "Comerciante"
        }
        else{
            ocupacionText.text = "Enfermera"
        }
    }
    
    
    //This function uses StringUtils.swift to check if is valid the value of the textfield for example isNumeric, doesNotContainCharactersIn,ContainCharactersIn How many characters
    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                                                 replacementString string: String)
        -> Bool
    {
        // We ignore any change that doesn't add characters to the text field.
        // These changes are things like character deletions and cuts, as well
        // as moving the insertion point.
        //
        // We still return true to allow the change to take place.
        if string.characters.count == 0 {
            return true
        }
        
        // Check to see if the text field's contents still fit the constraints
        // with the new content added to it.
        // If the contents still fit the constraints, allow the change
        // by returning true; otherwise disallow the change by returning false.
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        switch textField {
            
            // Allow only digits in this field,
        // and limit its contents to a maximum of 3 characters.
        case nombreText:
            if prospectiveText.characters.count >= 5
            {
                minlengthnombre = 1
            } else{
                minlengthnombre = 0
            }
            return prospectiveText.doesNotContainCharactersIn("123456789") &&
                prospectiveText.characters.count <= 50
        case celularText:
            if prospectiveText.characters.count >= 7
            {
                minlengtcelular = 1
            } else{
                minlengtcelular = 0
            }
            return prospectiveText.isNumeric() &&
                prospectiveText.characters.count <= 20
        case pesoText:
                return prospectiveText.isNumeric() &&
                prospectiveText.characters.count <= 4
        case estaturaText:
            return prospectiveText.isNumeric() &&
                prospectiveText.characters.count <= 4
        case codigoText:
            if prospectiveText.characters.count >= 5
            {
                minlengtcodigo = 1
            } else{
                minlengtcodigo = 0
            }
            return prospectiveText.isNumeric() &&
                prospectiveText.characters.count <= 5
        default:
            return true
        }
        
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}

extension CALayer {
    var borderColorFromUIColor: UIColor {
        get {
            return UIColor(CGColor: self.borderColor!)
        } set {
            self.borderColor = newValue.CGColor
        }
    }
}