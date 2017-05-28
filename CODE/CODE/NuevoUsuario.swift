//
//  RecuperarPassword.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez & Oscar Barrera Casillas on 12/05/16.
//  Copyright © 2016 CODE. All rights reserved.
// class to get complementary information and create a new user. You can enter to this view through RegistrarUsuario with email and password

import UIKit
import Alamofire

class NuevoUsuario: UIViewController, UITextFieldDelegate,  UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    @IBOutlet weak var registrarButton: UIButton!
    @IBOutlet weak var dateFecha: UIDatePicker!
    @IBOutlet weak var generoText: UITextField!
    @IBOutlet weak var animoText: UITextField!
    @IBOutlet weak var presionText: UITextField!
    @IBOutlet weak var glucosaText: UITextField!
    @IBOutlet weak var actividadText: UITextField!
    @IBOutlet weak var estaturaText: UITextField!
    @IBOutlet weak var kgText: UITextField!
    @IBOutlet weak var registrarLabel: UILabel!
    var pickerPresion = UIPickerView()
    var pickerGlucosa = UIPickerView()
    var pickerActividad = UIPickerView()
    var pickerAnimo = UIPickerView()
    var pickerGenero = UIPickerView()
    var pickerDataSource = ["Selecciona una respuesta","Sí", "No"];
    var pickerDataSourc = ["Selecciona una respuesta","Sí", "No" ];
    var pickerFisica = ["Selecciona una respuesta","Sí", "No"];
    var pickerEstado = ["Selecciona una respuesta", "Sí", "No" ];
    var pickerDataGeneroDatos = ["Género","Hombre", "Mujer"];
    var respuestaPresion = ""
    var respuestaGlucosa = ""
    var respuestaFisico = ""
    var respuestaEstado = ""
    var error = 0
    var minlength = 0
    var minlengthkg = 0
    var fechaText = ""
    var respuestaGenero = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        registrarLabel.userInteractionEnabled = true
        let aSelector : Selector = "lblTapped"
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        registrarLabel.addGestureRecognizer(tapGesture)
        
        
        
        
        self.registrarButton.backgroundColor = UIColor(red:0.23, green:0.33, blue:0.61, alpha:1.0)
        generoText.delegate = self;
        presionText.delegate = self;
        animoText.delegate = self;
        glucosaText.delegate = self;
        actividadText.delegate = self;
        self.pickerPresion.dataSource = self;
        self.pickerPresion.delegate = self;
        self.pickerGlucosa.dataSource = self;
        self.pickerGlucosa.delegate = self;
        self.pickerActividad.dataSource = self;
        self.pickerActividad.delegate = self;
        self.pickerAnimo.dataSource = self;
        self.pickerAnimo.delegate = self;
        self.pickerGenero.delegate = self;
        self.pickerGenero.dataSource = self;
        estaturaText.delegate = self;
        kgText.delegate = self;
        presionText.inputView = pickerPresion
        glucosaText.inputView = pickerGlucosa
        actividadText.inputView = pickerActividad
        animoText.inputView = pickerAnimo
        generoText.inputView = pickerGenero
        dateFecha.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard")))
    }
    
    
    //function to hide the datapicker in the textfield when they lost the focus
    func dismissKeyboard() {
        presionText.resignFirstResponder()
        animoText.resignFirstResponder()
        glucosaText.resignFirstResponder()
        actividadText.resignFirstResponder()
        kgText.resignFirstResponder()
        estaturaText.resignFirstResponder()
        generoText.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func lblTapped(){
        publicaPolitica("Comisión de Deporte del Estado de Guanajuato, mejor conocido como CODE Guanajuato, con domicilio en calle Carr. Gto Dolores Hgo. Km. 1.5, colonia Valenciana, ciudad Guanajuato, municipio o delegación Guanajuato, c.p.36000, en la entidad de Guanajuato, país México, y portal de internet codegto.gob.mx, es el responsable del uso y protección de sus datos personales, y al respecto le informamos lo siguiente:¿Para qué fines utilizaremos sus datos personales? Los datos personales que recabamos de usted, los utilizaremos para las siguientes finalidades que son necesarias para el servicio que solicita: Para verificar y confirmar su identidad y situación patrimonial Para administrar y operar los servicios que contrata con la Comisión Mercadotecnia o publicitaria Prospección comercial ¿Qué datos personales utilizaremos para estos fines? Para llevar a cabo las finalidades descritas en el presente aviso de privacidad, utilizaremos los siguientes datos personales: Datos de identificación Datos de contacto Datos sobre características físicas Datos laborales Datos académicos Datos migratorios Datos patrimoniales y/o financieros ¿Cómo puede acceder, rectificar o cancelar sus datos personales, u oponerse a su uso? Usted tiene derecho a conocer qué datos personales tenemos de usted, para qué los utilizamos y las condiciones del uso que les damos (Acceso). Asimismo, es su derecho solicitar la corrección de su información personal en caso de que esté desactualizada, sea inexacta o incompleta (Rectificación); que la eliminemos de nuestros registros o bases de datos cuando considere que la misma no está siendo utilizada adecuadamente (Cancelación); así como oponerse al uso de sus datos personales para fines específicos (Oposición). Estos derechos se conocen como derechos ARCO. Para el ejercicio de cualquiera de los derechos ARCO, usted deberá presentar la solicitud respectiva a través del siguiente medio: mediante escrito ante la oficina de la Unidad de Acceso, ubicada en Paseo de la Presa número 170, Zona Centro, Guanajuato, Guanajuato, C.P. 36000. Para conocer el procedimiento y requisitos para el ejercicio de los derechos ARCO, ponemos a su disposición el siguiente medio: mediante escrito Los datos de contacto de la persona o departamento de datos personales, que está a cargo de dar trámite a las solicitudes de derechos ARCO, son los siguientes: a.Nombre de la persona o departamento de datos personales: Unidad de Acceso a la Información b.Domicilio: calle San Sebastián 78, colonia Zona Centro, ciudad Guanajuato., municipio o delegación Guanajuato, c.p. 36000., en la entidad de Guanajuato, país México c.Correo electrónico: unidadacceso@guanajuato.gob.mx Usted puede revocar su consentimiento para el uso de sus datos personales Usted puede revocar el consentimiento que, en su caso, nos haya otorgado para el tratamiento de sus datos personales. Sin embargo, es importante que tenga en cuenta que no en todos los casos podremos atender su solicitud o concluir el uso de forma inmediata, ya que es posible que por alguna obligación legal requiramos seguir tratando sus datos personales. Asimismo, usted deberá considerar que para ciertos fines, la revocación de su consentimiento implicará que no le podamos seguir prestando el servicio que nos solicitó, o la conclusión de su relación con nosotros. Para revocar su consentimiento deberá presentar su solicitud a través del siguiente medio: Por escrito Para conocer el procedimiento y requisitos para la revocación del consentimiento, ponemos a su disposición el siguiente medio: Por escrito dirigido al titular de la Comisión ¿Cómo puede limitar el uso o divulgación de su información personal? Con objeto de que usted pueda limitar el uso y divulgación de su información personal, le ofrecemos los siguientes medios: Por escrito ¿Cómo puede conocer los cambios en este aviso de privacidad? El presente aviso de privacidad puede sufrir modificaciones, cambios o actualizaciones derivadas de nuevos requerimientos legales; de nuestras propias necesidades por los productos o servicios que ofrecemos; de nuestras prácticas de privacidad; de cambios en nuestro modelo de negocio, o por otras causas. Nos comprometemos a mantenerlo informado sobre los cambios que pueda sufrir el presente aviso de privacidad, a través de: Por medio escrito. El procedimiento a través del cual se llevarán a cabo las notificaciones sobre cambios o actualizaciones al presente aviso de privacidad es el siguiente: Solicitud por escrito.Su consentimiento para el tratamiento de sus datos personales Consiento que mis datos personales sean tratados de conformidad con los términos y condiciones informados en el presente aviso de privacidad.Sí acepto al presionar el botón de aceptar")
        
        
    }
    
    func publicaPolitica(messageBody : String) {
        
        let alertController = UIAlertController(title: "Aviso de Privacidad", message:
            messageBody, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,
            handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    
    
    //functions to get number of components of the pickview,
    //to know the number of rows, to set a title and array, to know what row did you select
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerPresion{
            return pickerDataSource.count;
        } else if  pickerView == pickerGlucosa{
            return pickerDataSourc.count;
        }
        else if  pickerView == pickerActividad{
            return pickerFisica.count;
        } else if pickerView == pickerGenero{
            return pickerDataGeneroDatos.count;
        }
        else{
            return pickerEstado.count;
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == pickerPresion {
            return pickerDataSource[row]
        } else if  pickerView == pickerGlucosa{
            return pickerDataSourc[row]
        }
        else if  pickerView == pickerActividad{
            return pickerFisica[row]
        } else if pickerView == pickerGenero{
            return pickerDataGeneroDatos[row]
        }else{
            return pickerEstado[row]
        }
        
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == pickerPresion {
            if(row == 0)
            {
                error = 1
            }
            else  if(row == 1)
            {
                presionText.text =  "Sí"
                respuestaPresion = "1"
                error = 0
                
            } else{
                presionText.text =  "No"
                respuestaPresion = "0"
                error = 0
            }
        } else if  pickerView == pickerGlucosa{
            if(row == 0)
            {
                error = 1
            }
            else if (row == 1)
            {
                glucosaText.text = "Sí"
                respuestaGlucosa="1"
                error = 0
            } else{
                glucosaText.text = "No"
                respuestaGlucosa="0"
                error = 0
            }
        }
        else if  pickerView == pickerActividad{
            if(row == 0)
            {
                error = 1
            }
            else if (row == 1)
            {
                actividadText.text = "Sí"
                respuestaFisico="1"
                error = 0
            } else{
                actividadText.text = "No"
                respuestaFisico="0"
                error = 0
            }
        }
        else if  pickerView == pickerGenero{
            if(row == 0)
            {
                error = 1
            }
            else if (row == 1)
            {
                generoText.text = "Hombre"
                respuestaGenero="1"
                error = 0
            } else{
                generoText.text = "Mujer"
                respuestaGenero="2"
                error = 0
            }
        }else{
            if(row == 0)
            {
                error = 1
            }
            else if(row == 1)
            {
                animoText.text = "Sí"
                respuestaEstado="1"
                error = 0
                
                
            }
            else if(row == 2)
            {
                animoText.text = "No"
                respuestaEstado="0"
                error = 0
                
            }
        }
        
    }
    
    
    //function to know if the datePicker was changed
    func datePickerChanged(datePicker:UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        fechaText = strDate
    }
    
    //These three functions move the view controller 200 up to show the keyboard, prevent that the keyboard hides the input
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 200)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 200)
    }
    
    
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
    
    //function to return to login view
    @IBAction func leftButtonPressed(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let centerNav = UINavigationController(rootViewController: nextViewController)
        self.presentViewController(centerNav, animated:true, completion:nil)
    }
    
    //If all fields content a value, It will send to the server the complete information to register a user with fb, google or normal session
    //If the process  finish ok you will go to the login with a message
    @IBAction func registrarButton(sender: AnyObject) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var strDate = dateFormatter.stringFromDate(dateFecha.date)
        fechaText = strDate
        var estatura = estaturaText.text!
        var kg = kgText.text!
        if  kg.isEmpty || estatura.isEmpty || error == 1 || glucosaText.text!.isEmpty || presionText.text!.isEmpty || actividadText.text!.isEmpty || animoText.text!.isEmpty || generoText.text!.isEmpty {
            self.publica("Llene todos los campos")
        } else  if  minlength == 0 && minlengthkg == 0  {
            self.publica("Verifique estatura y peso")
        } else{
            if loginsave == "1" {
                fbsave = "0"
                googlesave = "0"
            } else if fbsave == "1" {
                googlesave = "0"
                loginsave = "0"
            } else if googlesave == "1" {
                loginsave = "0"
                fbsave = "0"
            }
           // print(fechaText)
           // print(respuestaGenero)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            Alamofire.request(.POST, "http://app.codegto.gob.mx/code_web/src/app_php/registro/crearUsuario.php", parameters: ["correo": correosave, "password":  passwordsave, "facebook": fbsave, "google": googlesave , "estatura": estatura, "peso": kg,  "presion": respuestaPresion , "glucosa": respuestaGlucosa, "actividad": respuestaFisico, "lesion":  respuestaEstado, "genero": respuestaGenero,"fec_nacimiento": fechaText, "imc": 0 ])
                .responseString { response in switch response.result {
                case .Success(let JSON):
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                   // print("Success with JSON: \(JSON)")
                    let response = JSON as! String
                    if  response == "0" {
                        self.publica("Hubo un error en el servidor")
                    }else{
                        dict["id_login_app"] = response
                        dict["correo"] = correosave
                        dict["facebook"] =  fbsave
                        dict["google"] =  googlesave
                        
                        //extra
                        if NSUserDefaults.standardUserDefaults().objectForKey("DemoWalk")  == nil {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("WalkController") as! WalkController2
                            let centerNav = UINavigationController(rootViewController: nextViewController)
                            self.presentViewController(centerNav, animated:true, completion:nil)
                        }
                        
                        
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        let center = appDelegate.didLogin()
                        self.navigationController?.presentViewController(center, animated: true, completion: nil)
                    }
                case .Failure(let error):
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                   // print("Request failed with error: \(error)")
                    self.publica("Verifica tu conexión a internet")
                    }
            }
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
        case kgText:
            if prospectiveText.characters.count >= 2
            {
                minlengthkg = 1
            } else{
                minlengthkg = 0
            }
            return prospectiveText.isNumeric() &&
                prospectiveText.characters.count <= 5
        case estaturaText:
            if prospectiveText.characters.count >= 3
            {
                minlength = 1
            } else{
                minlength = 0
            }
            return prospectiveText.isNumeric() &&
                prospectiveText.characters.count <= 4
        default:
            return true
        }
        
    }
}



