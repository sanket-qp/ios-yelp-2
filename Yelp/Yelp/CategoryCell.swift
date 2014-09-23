//
//  CategoryCell.swift
//  Yelp
//
//  Created by sanket patel on 9/21/14.
//  Copyright (c) 2014 sanket patel. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var categories = ["Restaurants", "Active Life", "Hiking", "Sports"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }

}
