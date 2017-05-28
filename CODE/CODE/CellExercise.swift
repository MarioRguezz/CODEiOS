//
//  CellExercise.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez  & Oscar Barrera on 14/07/16.
//  Copyright © 2016 CODE. All rights reserved.
//
import UIKit

class CellExercise: UITableViewCell {
    
    
    @IBOutlet weak var ChangeSwitch: UISwitch!
    @IBOutlet weak var Calorias: UILabel!
    @IBOutlet weak var Minutos: UILabel!
    @IBOutlet weak var Ejercicio: UILabel!
    
    
    var delegate: cellModelChang!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        ChangeSwitch.setOn(false, animated: false)
        Calorias.text = ""
        Minutos.text = ""
        Ejercicio.text = ""
    }
    
    
    @IBAction func switchChange(sender: AnyObject) {
       let invSwitch = sender as! UISwitch
       delegate.cellModelSwitchTap(self, isSwitchOn: invSwitch.on, flag: true)
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}
