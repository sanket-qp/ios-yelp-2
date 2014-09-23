//
//  TempCell.swift
//  Yelp
//
//  Created by sanket patel on 9/22/14.
//  Copyright (c) 2014 sanket patel. All rights reserved.
//

import UIKit

class TempCell: UITableViewCell {

    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var fontLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
