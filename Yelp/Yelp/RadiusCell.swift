//
//  RadiusCell.swift
//  Yelp
//
//  Created by sanket patel on 9/21/14.
//  Copyright (c) 2014 sanket patel. All rights reserved.
//

import UIKit

class RadiusCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var radiusTable: UITableView!
    let radiuses = ["Auto", "0.3 miles", "1 mile", "5 mile", "20 mile"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        println("init cell")
        
        radiusTable.delegate = self
        radiusTable.dataSource = self
        //radiusTable.rowHeight = UITableViewAutomaticDimension
        radiusTable.reloadData()
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return radiuses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        cell.textLabel?.text = radiuses[indexPath.row]
        return cell
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populate(reload: Bool) {
        
    }
    
    func hello() {
    
        println("Hello")
    }
}
