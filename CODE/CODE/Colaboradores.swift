//
//  Colaboradores.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez  & Oscar Barrera Casillas on 01/05/16.
//  Copyright © 2016 CODE. All rights reserved.
//  Class to show the iOS developers

import UIKit


class Team{
    var image: UIImage!
    var name: String!
    var email: String!
    
    
    init(image: UIImage, name:String,  email: String) {
        self.image = image
        self.name = name
        self.email = email
    }
}

class Colaboradores: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var Arra: [Team] = []
    @IBOutlet weak var tableViewColaboradores: UITableView!
    @IBOutlet weak var colaboradores: UILabel!
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
        let integrante1 = Team(image:  UIImage(named: "oscar1.jpg")!, name: "Oscar Barrera", email: "obc993@gmail.com") 
        let integrante2 = Team(image:  UIImage(named: "mario.jpg")!, name: "Mario Negrete", email: "mariorguezz@gmail.com")
        let integrante3 = Team(image:  UIImage(named: "uriel.jpg")!, name: "Uriel Infante", email: "ur13l.infante@gmail.com")
        let integrante4 = Team(image:  UIImage(named: "chema.jpg")!, name: "Chema Cruz ", email: "chema-cruz@live.com")
        let integrante5 = Team(image:  UIImage(named: "x.jpg")!, name: "José Camacho", email: "jose.camacho@inquality.com")
         Arra.append(integrante1)
         Arra.append(integrante2)
         Arra.append(integrante3)
         Arra.append(integrante4)
         Arra.append(integrante5)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    //show home  
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
        var cell = self.tableViewColaboradores.dequeueReusableCellWithIdentifier("cell",forIndexPath: indexPath) as! TableViewCellColaboradores
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

