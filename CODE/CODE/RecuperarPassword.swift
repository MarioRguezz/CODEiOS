//
//  RecuperarPassword.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez  & Oscar Barrera Casillason 12/05/16.
//  Copyright © 2016 CODE. All rights reserved.
// Class to verify if the email exists in the database, and if this it's true you will go to RestablecerPass

import UIKit
import Alamofire

var correorecuperar = ""
class RecuperarPassword: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var recuperarButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailText.delegate = self
        self.recuperarButton.backgroundColor = UIColor(red:0.23, green:0.33, blue:0.61, alpha:1.0)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //This function send to the server the email and if this email exists in database you will go to RestablecerPass
    @IBAction func recuperarPass(sender: AnyObject) {
        let correo = emailText.text!
        if correo.isEmpty  {
            self.publica("Ingrese un correo")
        } else if isValidEmail(correo) == true {
            var status = " "
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            Alamofire.request(.POST, "http://app.codegto.gob.mx/code_web/src/app_php/login/recuperarContrasena.php", parameters: ["correo": correo])
                .responseJSON { response in switch response.result {
                case .Success(let JSON):
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                   // print("Success with JSON: \(JSON)")
                    correorecuperar = correo
                    let response = JSON as! NSDictionary
                    status = response.objectForKey("status")! as! String
                    if  status == "invalid" {
                        self.publica("El correo no se encuentra registrado")
                    }else{
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("RestablecerPass") as! RestablecerPass
                        let centerNav = UINavigationController(rootViewController: nextViewController)
                        self.presentViewController(centerNav, animated:true, completion:nil)
                        
                    }
                case .Failure(let error):
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                   // print("Request failed with error: \(error)")
                    self.publica("Verifica tu conexión a internet")
                    }
            }
        } else{
            self.publica("Ingrese un correo valido")
            
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
    
    //function to return to login
    @IBAction func leftButtonPressed(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let centerNav = UINavigationController(rootViewController: nextViewController)
        self.presentViewController(centerNav, animated:true, completion:nil)
    }
    
    //return true if the email is valid
    func isValidEmail(stringValue: String) ->Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(stringValue)
    }
}
