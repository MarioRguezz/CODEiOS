//
//  ColaboradoresCode.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez  & Oscar Barrera Casillas on 01/05/16.
//  Copyright © 2016 CODE. All rights reserved.
//  Class to show the iOS developers

import UIKit

/*
class Team{
    var image: UIImage!
    var name: String!
    var email: String!
    
    
    init(image: UIImage, name:String,  email: String) {
        self.image = image
        self.name = name
        self.email = email
    }
}*/

class ColaboradoresCode: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var Arra: [Team] = []
    @IBOutlet weak var tableViewColaboradores: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadArray()
        //  circleImages(imageA)
        // circleImages(imageB)
        /*  self.imageA.layer.cornerRadius = 10.0
         self.imageB.layer.cornerRadius = 10.0
         self.imageA.clipsToBounds = true
         self.imageB.clipsToBounds = true
         self.imageA.layer.borderColor = UIColor( red:0.00, green:0.65, blue: 0.90, alpha: 1.0).CGColor
         self.imageB.layer.borderColor = UIColor( red:0.00, green:0.65, blue: 0.90, alpha: 1.0).CGColor
         self.imageA.layer.borderWidth = 3.0
         self.imageB.layer.borderWidth = 3.0*/
        // Do any additional setup after loading the view.
    }
    
    func loadArray() {
        let integrante1 = Team(image:  UIImage(named: "computadora.png")!, name: "Sistemas.code@guanajuato.gob.mx", email: "Dirección de Planeación y Desarrollo")
        let integrante2 = Team(image:  UIImage(named: "doctor")!, name: "jcelayao@guanajuato.gob.mx", email: "Dirección de Investigación y Medicina")
        let integrante3 = Team(image:  UIImage(named: "correr")!, name:"culturafisica.code@guanajuato.gob.mx", email: "Dirección de Cultura Física")
        Arra.append(integrante1)
        Arra.append(integrante2)
        Arra.append(integrante3)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func buttonLeftPressed(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ColaboradoresRoot") as! ColaboradoresRoot
        let centerNav = UINavigationController(rootViewController: nextViewController)
        self.presentViewController(centerNav, animated:true, completion:nil)
    }
    
    func circleImages(image: UIImageView ){
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.blackColor().CGColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  Arra.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableViewColaboradores.dequeueReusableCellWithIdentifier("cell",forIndexPath: indexPath) as! TableViewColaboradoresCode
        cell.imageCell.image = Arra[indexPath.row].image
        cell.imageCell.layer.cornerRadius = 10.0
        cell.imageCell.clipsToBounds = true
        cell.imageCell.layer.borderColor = UIColor( red:0.00, green:0.65, blue: 0.90, alpha: 1.0).CGColor
        cell.imageCell.layer.borderWidth = 3.0
        cell.nombreCell.text =  Arra[indexPath.row].name
        cell.correoCell.text = Arra[indexPath.row].email
        /* cell =  names[indexPath.row]
         cell.direccionLabel.text = direccion[indexPath.row]
         cell.telefonoLabel.text = telefono[indexPath.row]*/
        /*
         
         imageCell: UIImageView!
         @IBOutlet weak var nombreCell: UILabel!
         @IBOutlet weak var correoCell:
         */
        
        let v = UIView()
        v.backgroundColor = UIColor( red:0.00, green:0.65, blue: 0.90, alpha: 1.0)
        //self.darkerColor(UIColor.blueColor())
        cell.selectedBackgroundView = v;
        
        
        
        
        return cell
    }
    
}

