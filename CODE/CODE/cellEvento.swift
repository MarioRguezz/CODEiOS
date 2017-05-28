//
//  cellEvento.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez on 12/06/16.
//  Copyright © 2016 CODE. All rights reserved.
//

import UIKit

class cellEvento: UITableViewCell {
    
    @IBOutlet weak var descripLabel: UITextView!
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}
