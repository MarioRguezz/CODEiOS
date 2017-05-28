//
//  ReporteTableViewCell.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez  & Oscar Barrera Casillas on 25/05/16.
//  Copyright © 2016 CODE. All rights reserved.
//  Class for the custom cell of Reporte

import UIKit

class ReporteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageAgua: UIImageView!
    @IBOutlet weak var labelAgua: UILabel!
    @IBOutlet weak var imageEjercicio: UIImageView!
    @IBOutlet weak var labelEjercicio: UILabel!
    @IBOutlet weak var labelFecha: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
