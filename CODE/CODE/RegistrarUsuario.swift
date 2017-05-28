//
//  RegistrarUsuario.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez & Oscar Barrera Casillas on 15/05/16.
//  Copyright © 2016 CODE. All rights reserved.
//  class to check if the email exists in the database.  If doesn't exist the email you can use with your password

import UIKit
import Alamofire

//param correo  & password  & loginsave sent to NuevoUsuario.swift
// Save type of register if it's facebook  is 1 and it's the same for google and simple login
var correosave = ""
var passwordsave = ""
var loginsave = ""
var fbsave = ""
var googlesave = ""
class RegistrarUsuario: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var continuarButton: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var confpassText: UITextField!
    var nuevopas = 0
    var confpas = 0
    
    @IBOutlet weak var buttonAceptar: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailText.delegate = self
        passText.delegate = self
        confpassText.delegate = self
        self.continuarButton.backgroundColor = UIColor(red:0.23, green:0.33, blue:0.61, alpha:1.0)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Send to the server correo to check if exists in the database, if doesn`t exist change the view for NuevoUsuario
    @IBAction func continuarPressed(sender: AnyObject) {
        let correo = emailText.text!
        let pass = passText.text!
        let passconf = confpassText.text!
        if correo.isEmpty || pass.isEmpty {
            self.publica("Ingrese un correo")
        } else if isValidEmail(correo) == true  && confpas == 1 && nuevopas == 1  && pass == passconf {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            Alamofire.request(.POST, "http://app.codegto.gob.mx/code_web/src/app_php/registro/comprobarCorreo.php", parameters: ["correo": correo])
                .responseString { response in switch response.result {
                case .Success(let JSON):
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                   // print("Success with JSON: \(JSON)")
                    correorecuperar = correo
                    let response = JSON as! String
                    if  response == "true" {
                        self.publica("El correo ya se encuentra registrado")
                    }else{
                        correosave = correo
                        passwordsave = pass
                        loginsave = "1"
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("NuevoUsuario") as! NuevoUsuario
                        let centerNav = UINavigationController(rootViewController: nextViewController)
                        self.presentViewController(centerNav, animated:true, completion:nil)
                    }
                case .Failure(let error):
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                   // print("Request failed with error: \(error)")
                    self.publica("Verifica tu conexión a internet")
                    }
            }
        } else {
            self.publica("Verifica tu correo y 6 carácteres mínimo de contaseña")
        }
    }
    
    //function to return to login view
    @IBAction func leftButton(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
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
    
    //hide the keyboard when the uitexfield lost the focus
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
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
    
    
    //return true if the email is valid
    func isValidEmail(stringValue: String) ->Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(stringValue)
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
        case passText:
            if prospectiveText.characters.count >= 6
            {
                nuevopas = 1
            } else{
                nuevopas = 0
            }
            return prospectiveText.characters.count <= 15
        case confpassText:
            if prospectiveText.characters.count >= 6
            {
                confpas = 1
            } else{
                confpas = 0
            }
            return prospectiveText.characters.count <= 15
        default:
            return true
        }
        
    }
}

