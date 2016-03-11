//
//  TodoCell.swift
//  week4echt
//
//  Created by bob on 26/02/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var todoText: UIView!
    
    @IBOutlet weak var todoTextfield: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
