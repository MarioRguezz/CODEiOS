//
//  cellEventoHome.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez on 16/06/16.
//  Copyright © 2016 CODE. All rights reserved.
//

import UIKit

class cellEventoHome: UITableViewCell {
    
    @IBOutlet weak var descripLabel: UITextView!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var tituloLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    


override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(false, animated: animated)
}

}