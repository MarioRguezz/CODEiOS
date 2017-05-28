//
//  cellWater.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez on 13/07/16.
//  Copyright © 2016 CODE. All rights reserved.
//

import UIKit

class cellWater: UITableViewCell {
    
    @IBOutlet weak var Recipientes: UILabel!
    
    @IBOutlet weak var mlLabel: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    
   
     var delegate: cellModelChanged!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        `switch`.setOn(false, animated: false)
        mlLabel.text = ""
        Recipientes.text = ""
    }
    
    @IBAction func switchValueChangel(sender: AnyObject) {
        let invSwitch = sender as! UISwitch
        delegate.cellModelSwitchTapped(self, isSwitchOn: invSwitch.on, flag: true)
    }
    
    

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}
