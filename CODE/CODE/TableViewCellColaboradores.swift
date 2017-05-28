//
//  TableViewCellColaboradores.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez on 27/06/16.
//  Copyright © 2016 CODE. All rights reserved.
//
import UIKit

class TableViewCellColaboradores: UITableViewCell {
    
    @IBOutlet weak var correoCell: UILabel!
    @IBOutlet weak var nombreCell: UILabel!
    @IBOutlet weak var imageCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}
