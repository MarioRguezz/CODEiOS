//
//  MyCustomTableViewCell.swift
//  Code
//
//  Created by Mario Alberto Negrete Rodríguez  & Oscar Barrera Casillas on 10/03/16.
//  Copyright © 2016 MarioRguezz. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuItemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //pierde el foco al seleccionar
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    /*
     Con esta forma queda seleccionada la celda
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
 */
}
 