//
//  TableViewCellDirectorio.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez  & Oscar Barrera Casillas on 24/05/16.
//  Copyright © 2016 CODE. All rights reserved.
//  Class for the custom cell of Directorio

import UIKit

class TableViewCellDirectorio: UITableViewCell {
    
    @IBOutlet weak var direccionLabel: UITextView!
    @IBOutlet weak var telefonoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}
