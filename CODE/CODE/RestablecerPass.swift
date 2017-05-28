//
//  RecuperarPassword.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez & Oscar Barrera Casillas on 12/05/16.
//  Copyright © 2016 CODE. All rights reserved.
// Class to recover the password, you enter to this view through RecuperarPassword. Put a password and you can change your password for a new one

import UIKit
import Alamofire

var newPassword = 0
class RestablecerPass: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var volverEnviarButton: UIButton!
    @IBOutlet weak var aceptarButton: UIButton!
    @IBOutlet weak var enviarButton: UIButton!
    @IBOutlet weak var codigoText: UITextField!
    @IBOutlet weak var nuevoPass: UITextField!
    @IBOutlet weak var confPass: UITextField!
    var nuevopas = 0
    var confpas = 0
    
    @IBOutlet weak var buttonAceptar: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        codigoText.delegate = self
        nuevoPass.delegate = self
        confPass.delegate = self
        self.enviarButton.backgroundColor = UIColor(red:0.23, green:0.33, blue:0.61, alpha:1.0)
        self.aceptarButton.backgroundColor = UIColor(red:0.23, green:0.33, blue:0.61, alpha:1.0)
        self.volverEnviarButton.backgroundColor = UIColor(red:0.23, green:0.33, blue:0.61, alpha:1.0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //If your code is valid you will get two text field for you new password and confirm your password
    @IBAction func enviarCodigo(sender: AnyObject) {
        let codigo = codigoText.text!
        if codigo.isEmpty  {
            self.publica("Ingrese un código valido")
        } else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            Alamofire.request(.POST, "http://app.codegto.gob.mx/code_web/src/app_php/login/comprobarCodigo.php", parameters: ["correo": correorecuperar, "codigo": codigo])
                .responseJSON { response in switch response.result {
                case .Success(let JSON):
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    //print("Success with JSON: \(JSON)")
                    if JSON as! NSObject == true {
                        self.codigoText.userInteractionEnabled = false
                        self.nuevoPass.hidden = false
                        self.confPass.hidden = false
                        self.buttonAceptar.hidden = false
                    } else {
                        self.publica("Verifica tu código")
                    }
                case .Failure(let error):
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                   // print("Request failed with error: \(error)")
                    self.publica("Verifica tu conexión a internet")
                    }
            }
        }
    }
    
    
    //function to return to RecuperarPassword
    @IBAction func volveraEnviar(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("RecuperarPassword") as! RecuperarPassword
        let centerNav = UINavigationController(rootViewController: nextViewController)
        self.presentViewController(centerNav, animated:true, completion:nil)
    }
    
    
    //function to connect with the server send the email and password and if it's success you will return to the login
    @IBAction func restablecerPass(sender: AnyObject) {
        let newPass = nuevoPass.text!
        let confPas = confPass.text!
      //  print(correorecuperar)
      //  print(nuevopas)
       // print(confpas)
        if (newPass.isEmpty  || confPas.isEmpty) || (newPass != confPas){
            self.publica("Verifica los campos de contraseña")
        } else if nuevopas == 0 || confpas == 0   {
            self.publica("Las contraseñas son mínimo 6")
        } else{
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            Alamofire.request(.POST, "http://app.codegto.gob.mx/code_web/src/app_php/login/cambiarPassword.php", parameters: ["correo": correorecuperar, "password": confPas])
                .responseString { response in switch response.result {
                case .Success(let JSON):
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                  //  print("Success with JSON: \(JSON)")
                    if JSON as! String == "success" {
                        newPassword = 1
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
                        let centerNav = UINavigationController(rootViewController: nextViewController)
                        self.presentViewController(centerNav, animated:true, completion:nil)
                    } else {
                        self.publica("Hubo al problema al cambiar la contraseña")
                    }
                case .Failure(let error):
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                   // print("Request failed with error: \(error)")
                    self.publica("Verifica tu conexión a internet")
                    }
            }
        }
        
    }
    
    
    //hide the keyboard when the uitexfield lost the focus
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
    //These three functions move the view controller 200 up to show the keyboard, prevent that the keyboard hides the input
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 100)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 100)
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
    
    
    
    //This function uses StringUtils.swift to check if is valid the value of the textfield for example isNumeric, doesNotContainCharactersIn,ContainCharactersIn How many characters
    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                                                 replacementString string: String)
        -> Bool
    {
        if string.characters.count == 0 {
            return true
        }
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        switch textField {
        case codigoText:
            return
                prospectiveText.characters.count <= 5
        case confPass:
            if prospectiveText.characters.count >= 6
            {
                nuevopas = 1
            } else{
                nuevopas = 0
            }
            return prospectiveText.characters.count <= 15
        case nuevoPass:
            if prospectiveText.characters.count >= 6
            {
                confpas = 1
              //  print("hola")
            } else{
                confpas = 0
               // print("adios")
            }
            return prospectiveText.characters.count <= 15
        default:
            return true
        }
        
    }
    
    
    
    
}
