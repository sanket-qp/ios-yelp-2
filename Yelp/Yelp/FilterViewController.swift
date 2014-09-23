//
//  FilterViewController.swift
//  Yelp
//
//  Created by sanket patel on 9/21/14.
//  Copyright (c) 2014 sanket patel. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var filterTable: UITableView!
    let sections = ["PriceCell", "RadiusCell", "SortCell", "CategoryCell"]
    /*
    let sections = [["name": "PriceCell", "class": PriceCell],
                    ["name": "RadiusCell", "class": RadiusCell],
                    ["name": "SortCell", "class": SortCell]]
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filterTable.delegate = self
        filterTable.dataSource = self
        filterTable.rowHeight =  UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //var cell: UITableViewCell!
        let sectionName = sections[indexPath.section]
        println("\(sectionName)")
        switch sectionName {
        
            case "PriceCell":
                var cell = tableView.dequeueReusableCellWithIdentifier("PriceCell") as PriceCell
                return cell
            
            case "SortCell":
                var cell = tableView.dequeueReusableCellWithIdentifier("SortCell") as SortCell
                return cell

            
            case "RadiusCell":
                var cell = tableView.dequeueReusableCellWithIdentifier("RadiusCell") as RadiusCell
                cell.populate(true)
                return cell

            
            case "CategoryCell":
                var cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as CategoryCell
                return cell

            
            default:
                var cell = UITableViewCell()
                return cell

        }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return sections.count
    }
    /*
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 0.8, alpha: 0.8 )
        var headerLabel = UILabel(frame: CGRect(x:10, y:0, width: 320, height: 50))
        headerLabel.text = "\(sections[section])"
        headerView.addSubview(headerLabel)
        return headerView
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
