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
    var categories = YelpClient.supportedCategories()
    var radiuses = ["Auto", "0.3 Miles", "1 Mile", "5 Mile", "20 Mile"]
    var sortBy = ["Best Match", "Distance", "Highest Rated"]
    var items: [Int] = []
    
    let sortBySection = ["Best Match": 0, "Distance": 1, "Highest Rated": 2]
    let distanceSection = ["Auto": 160, "0.3 Mile": 482, "1 Mile": 1609, "5 Mile": 8044, "20 Mile":  32186]
    //let categoriesSection = YelpClient.categoryDict
    var allSections: [String: [String: String]]! = nil
    var searchPreference = SearchPreferences.sharedInstance
    
    var chosenRadiusString: String = "Auto"
    var chosenRadius: Int = 160
    
    var chosenSortString = "Best Match"
    var chosenSort = 0
    var chosenCategories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .blackColor()
        
        // load preferences
        chosenRadius = searchPreference.radius
        chosenRadiusString = searchPreference.radiusText
        chosenCategories = searchPreference.categories
        chosenSort = searchPreference.sortBy
        chosenSortString = searchPreference.sortByText
        
        // Do any additional setup after loading the view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        items = [radiuses.count, sortBy.count, 10]
        //allSections = ["Distance": distanceSection, "Sort By": sortBySection, "Categories": categoriesSection]
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
        
        toggleSection(indexPath)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let expanded = isExpanded[indexPath.section] ?? false
        let sectionName = sections[indexPath.section]
        var cell: FilterCell! = nil
        
        switch sectionName {
            
        case "Price":
            cell = priceCell()

        case "Distance":
            cell =  distanceCell(indexPath.row, expanded: expanded)
            

        case "Sort By":
            cell = sortCell(indexPath.row, expanded: expanded)

        case "Categories":
            cell = categoryCell(indexPath.row, expanded: expanded)

        default:
            cell = FilterCell()
            
        }

        if !expanded {
            
            //cell.filterSwitch.hidden = true
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section]
    }
    
    func toggleSection(indexPath: NSIndexPath) {
    
        let expanded = isExpanded[indexPath.section] ?? false
        
        expanded ? collapseSection(indexPath) : expandSection(indexPath)
        
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)

    }
    
    func collapseSection(indexPath: NSIndexPath) {
    
        let section = indexPath.section
        let row = indexPath.row
        let sectionName = sections[section]
        let cell = tableView.cellForRowAtIndexPath(indexPath) as FilterCell
        let selected = cell.filterLabel.text
        
        switch sectionName {
            
        case "Price":
            break
            
        case "Distance":
            // if expanded then move the selected cell to the top and set the search preference
            var r = distanceSection[selected!]
            chosenRadius = r ?? 160
            chosenRadiusString = selected!
            println("Choosing : \(selected) : \(chosenRadius)")
            cell.filterSwitch.setOn(true, animated: true)
            //swapCells(indexPath.row, to: 0)
            isExpanded[section] = false
            

        case "Sort By":
            var s = sortBySection[selected!]
            chosenSort = s ?? 0
            chosenSortString = selected!
            cell.toggleSwitch()
            isExpanded[section] = false
            
        case "Categories":
            // we just toggle switch here, we never collapse categories section once it's expanded
            //cell.filterSwitch.on ? searchPreference.removeCategory(selected!) : searchPreference.addCategory(selected!)
            cell.filterSwitch.on ? removeCategory(selected!) : addCategory(selected!)
            cell.toggleSwitch()
            println(chosenCategories)
            
        default:
            break
            
        }
    }
    
    func expandSection(indexPath: NSIndexPath) {
    
    
        isExpanded[indexPath.section] = true
    }
    
    
    func addCategory(category: String) {
    
    
        if let index = find(chosenCategories, category) {
            
            
        } else {
            
            chosenCategories.append(category)
        }
    
    }
    
    func removeCategory(category: String) {
    
        
        if let index = find(chosenCategories, category) {
            
            chosenCategories.removeAtIndex(index)
        }
    }
    
    func priceCell() -> FilterCell {

        let segmentControl = UISegmentedControl(items: ["$", "$$", "$$$", "$$$$"])
        var cell = FilterCell()
        cell.addSubview(segmentControl!)
        return cell
    }
    
    func distanceCell(row: Int, expanded: Bool) -> FilterCell  {
        
        if !expanded {
        
            println("returning chosen cell only")
            return getCell(chosenRadiusString, expanded: false, selected: true)
        }
        
        //let distances = [String](distanceSection.keys)
        let distanceString = radiuses[row]
        let selected = chosenRadius == distanceSection[distanceString] ? true : false
        return getCell(radiuses[row], expanded: expanded, selected: selected)
    }
    
    func sortCell(row: Int, expanded: Bool) -> FilterCell {

        if !expanded {
            
            return getCell(chosenSortString, expanded: false, selected: true)
        }
        
        let sortString = sortBy[row]
        let selected = chosenSort == sortBySection[sortString] ? true : false
        return getCell(sortBy[row], expanded: expanded, selected: selected)
    }
    
    func categoryCell(row: Int, expanded: Bool) -> FilterCell {
    
        
        return getCell(categories[row], expanded: expanded, selected: false)
    }
    
    
    func getCell(text: String, expanded: Bool, selected: Bool) -> FilterCell {

        var cell = tableView.dequeueReusableCellWithIdentifier("FilterCell") as FilterCell
        cell.filterLabel.text = text
        cell.filterSwitch.setOn(selected, animated: true)
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
        
        // restore the old searchPreferences
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func searchClicked(sender: AnyObject) {
        
        // persist preferences
        searchPreference = SearchPreferences.sharedInstance
        searchPreference.radius = chosenRadius
        searchPreference.radiusText = chosenRadiusString
        searchPreference.sortBy = chosenSort
        searchPreference.sortByText = chosenSortString
        searchPreference.categories = chosenCategories
        
        if delegate != nil {
            
            delegate?.filtersChanged(searchPreference)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
