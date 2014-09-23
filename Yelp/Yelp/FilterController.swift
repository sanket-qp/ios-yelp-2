//
//  FilterController.swift
//  Yelp
//
//  Created by sanket patel on 9/22/14.
//  Copyright (c) 2014 sanket patel. All rights reserved.
//

import UIKit
protocol FiltersChangedDelegate {


    func filtersChanged(filters: SearchPreferences)
}


class FilterController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: FiltersChangedDelegate? = nil
    //var sections = ["Price", "Distance", "Sort By", "Categories"]
    var sections = ["Distance", "Sort By", "Categories"]
    var isExpanded: [Int: Bool] = [Int: Bool]()
    let categories = YelpClient.supportedCategories()
    let radiuses = ["Auto", "0.3 miles", "1 mile", "5 mile", "20 mile"]
    var sortBy = ["Best Match", "Distance", "Highest Rated"]
    var items: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .blackColor()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        items = [radiuses.count, sortBy.count, 10]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return sections.count
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let expanded = isExpanded[section] {
        
            let itemsInSection = items[section]
            return expanded ? itemsInSection : 1
            
        } else {
            
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let expanded = isExpanded[indexPath.section] {
            
            isExpanded[indexPath.section] = !expanded
        } else {
            
            isExpanded[indexPath.section] = true
            
        }
        
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let expanded = isExpanded[indexPath.section] ?? false
        let sectionName = sections[indexPath.section]
        println("\(sectionName)")
        switch sectionName {
            
        case "Price":
            return priceCell()

        case "Distance":
            return distanceCell(indexPath.row, expanded: expanded)
            

        case "Sort By":
            return sortCell(indexPath.row, expanded: expanded)

        case "Categories":
            return categoryCell(indexPath.row, expanded: expanded)

        default:
            var cell = UITableViewCell()
            return cell
            
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section]
    }
    
    func priceCell() -> UITableViewCell {

        println("Price Cell")
        let segmentControl = UISegmentedControl(items: ["$", "$$", "$$$", "$$$$"])
        var cell = UITableViewCell()
        cell.addSubview(segmentControl!)
        return cell
    }
    
    func distanceCell(row: Int, expanded: Bool) -> UITableViewCell  {
    
        return getCell(radiuses[row], expanded: expanded, selected: false)
        /*
        var cell = UITableViewCell()
        cell.textLabel?.text = radiuses[row]
        return cell */
    }
    
    func sortCell(row: Int, expanded: Bool) -> UITableViewCell {
    
        var cell = UITableViewCell()
        cell.textLabel?.text = sortBy[row]
        return cell
    }
    
    func categoryCell(row: Int, expanded: Bool) -> UITableViewCell {
    
        var cell = UITableViewCell()
        cell.textLabel?.text = categories[row]
        return cell
    }
    
    
    func getCell(text: String, expanded: Bool, selected: Bool) -> UITableViewCell {
    
        var cell = UITableViewCell()
        cell.textLabel?.text = ("Hello : \(text)")
        
        if (!expanded) {
        
            let view = UIImageView(image: UIImage(named: "Cell Expander"))
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark;
            //cell.accessoryType = UITableViewCellAccessoryType.Checkmark;
            cell.accessoryView = view
        }
        
        if (selected) {
        
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark;
        }

        cell.accessoryType = UITableViewCellAccessoryType.Checkmark;
        return cell
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func searchClicked(sender: AnyObject) {
        
        println("search clicked")
        let prefs = SearchPreferences()
        
        if delegate != nil {
            
            delegate?.filtersChanged(prefs)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
