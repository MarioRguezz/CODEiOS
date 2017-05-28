//
//  ViewController.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez & Oscar Barrera Casillas on 19/04/16.
//  Copyright © 2016 CODE. All rights reserved.
//  Class login of application with options to recover the password, create a user, login with google or facebook or just log in

import UIKit
import FBSDKLoginKit
import Alamofire



//this dictionary keep the information with shared preferences
var dict = ["id_login_app":"", "correo": "", "facebook": "", "google": ""]

class ViewController: UIViewController, GIDSignInUIDelegate , FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var recuperarPass: UILabel!
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPass: UITextField!
    @IBOutlet weak var ingresarButton: UIButton!
    @IBOutlet weak var registrarUsuario: UIButton!
    @IBOutlet weak var acuerdoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ingresarButton.backgroundColor = UIColor(red:0.23, green:0.33, blue:0.61, alpha:1.0)
        self.recuperarPass.backgroundColor = UIColor(red:0.23, green:0.33, blue:0.61, alpha:1.0)
        self.registrarUsuario.backgroundColor = UIColor(red:0.23, green:0.33, blue:0.61, alpha:1.0)
       // self.view.contentMode = UIViewContentMode.Center;
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "loginback.jpg")!)
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "loginback")
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        var gradient = CAGradientLayer()
        let colorTop = UIColor(red:0.51, green:0.62, blue:0.97, alpha:0.7)
        gradient.frame = backgroundImage.frame
        gradient.colors = [
             UIColor(white: 0, alpha: 0.6).CGColor,
            colorTop.CGColor
           
        ]
        backgroundImage.layer.insertSublayer(gradient, atIndex: 0)
        
        
        
        
        self.view.insertSubview(backgroundImage, atIndex: 0)
        //print(mailGoogle)
        //print("\(newPassword)")
        //If the user had a session he will enter to the home
        if NSUserDefaults.standardUserDefaults().objectForKey("toDoList")  != nil {
            dict = NSUserDefaults.standardUserDefaults().objectForKey("toDoList") as! [String:String]
        }
        if dict["correo"] != "" {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let center = appDelegate.didLogin()
            self.navigationController?.presentViewController(center, animated: true, completion: nil)
        }
        //If the user changed the password he will get a messsage (alert view)
        if  newPassword == 1{
            publica2("Tu contraseña ha sido cambiada")
            newPassword = 0
        }
        recuperarPass.userInteractionEnabled = true
        let aSelector : Selector = "lblTapped"
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        recuperarPass.addGestureRecognizer(tapGesture)
        
        acuerdoLabel.userInteractionEnabled = true
        let Selector2 : Selector = "lblTapped2"
        let tapGesture2 = UITapGestureRecognizer(target: self, action: Selector2)
        tapGesture2.numberOfTapsRequired = 1
        acuerdoLabel.addGestureRecognizer(tapGesture2)
        GIDSignIn.sharedInstance().uiDelegate = self;
        // Do any additional setup after loading the view, typically from a nib.
        //  Alamofire.request(.GET, "http://app.codegto.gob.mx/code_web/src/app_php/registro/comprobarCorreo.php").responseJSON { (response) -> Void in
        //    if let JSON = response.result.value {
        //      print(JSON)
        //}
        // }
        
        if (FBSDKAccessToken.currentAccessToken() == nil){
            //print ("User is not logged in ")
        }else{
           // print ("user is logged in")
        }
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.presentViewController(viewController, animated: true, completion: nil)
       // print("sign in presented")
    }
    
    
    
    func publicaPolitica(messageBody : String) {
        
        let alertController = UIAlertController(title: "Aviso de Privacidad", message:
            messageBody, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,
            handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    func lblTapped2(){
        publicaPolitica("Comisión de Deporte del Estado de Guanajuato, mejor conocido como CODE Guanajuato, con domicilio en calle Carr. Gto Dolores Hgo. Km. 1.5, colonia Valenciana, ciudad Guanajuato, municipio o delegación Guanajuato, c.p.36000, en la entidad de Guanajuato, país México, y portal de internet codegto.gob.mx, es el responsable del uso y protección de sus datos personales, y al respecto le informamos lo siguiente:¿Para qué fines utilizaremos sus datos personales? Los datos personales que recabamos de usted, los utilizaremos para las siguientes finalidades que son necesarias para el servicio que solicita: Para verificar y confirmar su identidad y situación patrimonial Para administrar y operar los servicios que contrata con la Comisión Mercadotecnia o publicitaria Prospección comercial ¿Qué datos personales utilizaremos para estos fines? Para llevar a cabo las finalidades descritas en el presente aviso de privacidad, utilizaremos los siguientes datos personales: Datos de identificación Datos de contacto Datos sobre características físicas Datos laborales Datos académicos Datos migratorios Datos patrimoniales y/o financieros ¿Cómo puede acceder, rectificar o cancelar sus datos personales, u oponerse a su uso? Usted tiene derecho a conocer qué datos personales tenemos de usted, para qué los utilizamos y las condiciones del uso que les damos (Acceso). Asimismo, es su derecho solicitar la corrección de su información personal en caso de que esté desactualizada, sea inexacta o incompleta (Rectificación); que la eliminemos de nuestros registros o bases de datos cuando considere que la misma no está siendo utilizada adecuadamente (Cancelación); así como oponerse al uso de sus datos personales para fines específicos (Oposición). Estos derechos se conocen como derechos ARCO. Para el ejercicio de cualquiera de los derechos ARCO, usted deberá presentar la solicitud respectiva a través del siguiente medio: mediante escrito ante la oficina de la Unidad de Acceso, ubicada en Paseo de la Presa número 170, Zona Centro, Guanajuato, Guanajuato, C.P. 36000. Para conocer el procedimiento y requisitos para el ejercicio de los derechos ARCO, ponemos a su disposición el siguiente medio: mediante escrito Los datos de contacto de la persona o departamento de datos personales, que está a cargo de dar trámite a las solicitudes de derechos ARCO, son los siguientes: a.Nombre de la persona o departamento de datos personales: Unidad de Acceso a la Información b.Domicilio: calle San Sebastián 78, colonia Zona Centro, ciudad Guanajuato., municipio o delegación Guanajuato, c.p. 36000., en la entidad de Guanajuato, país México c.Correo electrónico: unidadacceso@guanajuato.gob.mx Usted puede revocar su consentimiento para el uso de sus datos personales Usted puede revocar el consentimiento que, en su caso, nos haya otorgado para el tratamiento de sus datos personales. Sin embargo, es importante que tenga en cuenta que no en todos los casos podremos atender su solicitud o concluir el uso de forma inmediata, ya que es posible que por alguna obligación legal requiramos seguir tratando sus datos personales. Asimismo, usted deberá considerar que para ciertos fines, la revocación de su consentimiento implicará que no le podamos seguir prestando el servicio que nos solicitó, o la conclusión de su relación con nosotros. Para revocar su consentimiento deberá presentar su solicitud a través del siguiente medio: Por escrito Para conocer el procedimiento y requisitos para la revocación del consentimiento, ponemos a su disposición el siguiente medio: Por escrito dirigido al titular de la Comisión ¿Cómo puede limitar el uso o divulgación de su información personal? Con objeto de que usted pueda limitar el uso y divulgación de su información personal, le ofrecemos los siguientes medios: Por escrito ¿Cómo puede conocer los cambios en este aviso de privacidad? El presente aviso de privacidad puede sufrir modificaciones, cambios o actualizaciones derivadas de nuevos requerimientos legales; de nuestras propias necesidades por los productos o servicios que ofrecemos; de nuestras prácticas de privacidad; de cambios en nuestro modelo de negocio, o por otras causas. Nos comprometemos a mantenerlo informado sobre los cambios que pueda sufrir el presente aviso de privacidad, a través de: Por medio escrito. El procedimiento a través del cual se llevarán a cabo las notificaciones sobre cambios o actualizaciones al presente aviso de privacidad es el siguiente: Solicitud por escrito.Su consentimiento para el tratamiento de sus datos personales Consiento que mis datos personales sean tratados de conformidad con los términos y condiciones informados en el presente aviso de privacidad.Sí acepto al presionar el botón de aceptar")
        

    }
    
    
    
    
    
    
    
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
       // print ("sign in dismiss" )
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    
    //Connection with the server to verify if the user exists. If the user uses his type of login he will get in FACEBOOK
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        var inserted = 0
        var id_login = ""
        if (error != nil){
           // print (error.localizedDescription)
            return
        }
        if let userToken = result.token{
            //get user access token
           // print ("Token = \(FBSDKAccessToken.currentAccessToken().tokenString)")
          //  print ("User ID = \(FBSDKAccessToken.currentAccessToken().userID)")
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: userToken.tokenString, version: nil, HTTPMethod: "GET")
            req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
                if(error == nil)
                {
                   // print("result \(result)")
                   // print(result.valueForKey("email"))
                    // print(result.valueForKey("name"))
                    let mail = result.valueForKey("email") as? String
                    let name = result.valueForKey("name") as? String
                    print("mail \(mail!)")
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                    Alamofire.request(.POST, "http://app.codegto.gob.mx/code_web/src/app_php/login/loginFacebook.php", parameters: ["correo": mail! ])
                        .responseJSON { response in switch response.result {
                            
                        case .Success(let JSON):
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                           // print("Success with JSON: \(JSON)")
                            let response = JSON as! NSDictionary
                            //print ("\(response)")
                            if let id_login = response.objectForKey("id_login_app") as? String {
                              //  print ("\(id_login)")
                                if id_login == "-1" {
                                    self.publica("Este usuario inicia con otro tipo de acceso")
                                }else{
                                    inserted = response.objectForKey("inserted")! as! Int
                                    if inserted == 1 {
                                        fbsave = "1"
                                        correosave = mail!
                                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("NuevoUsuario") as! NuevoUsuario
                                        let centerNav = UINavigationController(rootViewController: nextViewController)
                                        self.presentViewController(centerNav, animated:true, completion:nil)
                                    } else{
                                        //extra
                                        if NSUserDefaults.standardUserDefaults().objectForKey("DemoWalk")  == nil {
                                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("WalkController") as! WalkController2
                                            let centerNav = UINavigationController(rootViewController: nextViewController)
                                            self.presentViewController(centerNav, animated:true, completion:nil)
                                        }
                                        
                                        let id_login_app = response.objectForKey("id_login_app")! as! String
                                        let a = response.objectForKey("correo")! as! String
                                        let b = response.objectForKey("facebook")! as! String
                                        let c = response.objectForKey("google")! as! String
                                        dict["id_login_app"] = id_login_app
                                        dict["correo"] = a
                                        dict["facebook"] = b
                                        dict["google"] = c
                                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                        let center = appDelegate.didLogin()
                                        self.navigationController?.presentViewController(center, animated: true, completion: nil)
                                    }
                                }
                                
                            }
                            else{
                                inserted = response.objectForKey("inserted")! as! Int
                                if inserted == 1 {
                                    fbsave = "1"
                                    correosave = mail!
                                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                    let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("NuevoUsuario") as! NuevoUsuario
                                    let centerNav = UINavigationController(rootViewController: nextViewController)
                                    self.presentViewController(centerNav, animated:true, completion:nil)
                                } else{
                                    let id_login_app = response.objectForKey("id_login_app")! as! String
                                    let a = response.objectForKey("correo")! as! String
                                    let b = response.objectForKey("facebook")! as! String
                                    let c = response.objectForKey("google")! as! String
                                    dict["id_login_app"] = id_login_app
                                    dict["correo"] = a
                                    dict["facebook"] = b
                                    dict["google"] = c
                                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                    let center = appDelegate.didLogin()
                                    self.navigationController?.presentViewController(center, animated: true, completion: nil)
                                }
                            }
                        case .Failure(let error):
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                          //  print("Request failed with error: \(error)")
                            self.publica("Verifica tu conexión a internet")
                            }
                    }
                    
                }
                else
                {
                   // print("error \(error)")
                }
            })
        }
        
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
       // print("user is logged out")
    }
    
    
    //hide the keyboard when the uitexfield lost the focus
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //cancela la edición y focus del elemento al presionar un elemento sin foco
        self.view.endEditing(true)
    }
    
    //Connection with the server to verify if the user exists. If the user uses his type of login he will get in NORMAL
    @IBAction func iniciarSesionPressed(sender: AnyObject) {
        let correo = textEmail.text!
        let password = textPass.text!
        if correo.isEmpty  || password.isEmpty{
            self.publica("Llene todos los campos")
        } else if isValidEmail(correo) == true {
            var id_login_app = " "
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            Alamofire.request(.POST, "http://app.codegto.gob.mx/code_web/src/app_php/login/loginSimple.php", parameters: ["correo": correo , "password" :password ])
                .responseJSON { response in switch response.result {
                case .Success(let JSON):
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    //print("Success with JSON: \(JSON)")
                    
                    let response = JSON as! NSDictionary
                    
                    //extra
                    if NSUserDefaults.standardUserDefaults().objectForKey("DemoWalk")  == nil {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("WalkController") as! WalkController2
                        let centerNav = UINavigationController(rootViewController: nextViewController)
                        self.presentViewController(centerNav, animated:true, completion:nil)
                    }
                    //example if there is an id
                    id_login_app = response.objectForKey("id_login_app")! as! String
                    if  id_login_app != "0" {
                        let a = response.objectForKey("correo")! as! String
                        let b = response.objectForKey("facebook")! as! String
                        let c = response.objectForKey("google")! as! String
                        dict["id_login_app"] = id_login_app
                        dict["correo"] = a
                        dict["facebook"] = b
                        dict["google"] = c
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        let center = appDelegate.didLogin()
                        self.navigationController?.presentViewController(center, animated: true, completion: nil)
                        
                    }
                    else {
                        self.publica("Verifique su usuario y/o contraseña o el tipo de registro")
                    }
                //   if dict["facebook"] == "1" ||  dict["google"] == "1"  || id_login_app == "0"{
                case .Failure(let error):
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    //print("Request failed with error: \(error)")
                    self.publica("Verifica tu conexión a internet")
                    }
            }
        } else{
            self.publica("Ingrese un correo valido")
        }
    }
    
    //Function to label to show RecuperarPassowrd
    func lblTapped(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("RecuperarPassword") as! RecuperarPassword
        let centerNav = UINavigationController(rootViewController: nextViewController)
        self.presentViewController(centerNav, animated:true, completion:nil)
    }
    
    
    //Function to show RegistrarUsuario
    @IBAction func registrarUsuario(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("RegistrarUsuario") as! RegistrarUsuario
        let centerNav = UINavigationController(rootViewController: nextViewController)
        self.presentViewController(centerNav, animated:true, completion:nil)
        
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
    func publica2 (messageBody : String) {
        let alertController = UIAlertController(title: "CODE", message:
            messageBody, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,
            handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    //return true if the email is valid
    func isValidEmail(stringValue: String) ->Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(stringValue)
    }
    
}

