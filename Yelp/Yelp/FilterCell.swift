//
//  FilterCell.swift
//  Yelp
//
//  Created by sanket patel on 9/23/14.
//  Copyright (c) 2014 sanket patel. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

    
    @IBOutlet weak var filterLabel: UILabel!
    
    @IBOutlet weak var filterSwitch: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchDidChange(sender: AnyObject) {
        
        var state = filterSwitch.state
        println(state.rawValue)
    }
    
    func toggleSwitch() {
    
        filterSwitch.on ? filterSwitch.setOn(false, animated: true) : filterSwitch.setOn(true, animated: true)    
    }
}
