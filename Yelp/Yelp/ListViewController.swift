//
//  ListViewController.swift
//  Yelp
//
//  Created by sanket patel on 9/21/14.
//  Copyright (c) 2014 sanket patel. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, FiltersChangedDelegate {

    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var filter2: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isLoading = false
    var searchTableView: UITableView!
    let consumerKey = "UqvuPXyQvL7ry65aw6CF2w"
    let consumerSecret = "3Vv_TwZd5x8FYdr_58AO_jXDHhM"
    let accessToken = "JGCPhfIy6DupUtQRvF3gY5z3ZkNFnGl6"
    let accessSecret = "j6-2z91Tq-PgkQrvGU1qZ0FCkKU"
    var yelpClient: YelpClient!
    var searchResults: [SearchResult] = []
    //var filterButton: UIBarButtonItem!
    var isSearch = false
    var filteredCategories: [String] = []
    let searchPreferences = SearchPreferences.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchDisplayController?.searchResultsTableView.delegate = self
        searchDisplayController?.searchResultsTableView.dataSource = self
        self.searchDisplayController?.displaysSearchBarInNavigationBar = true
        
        let fButton = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action:"clickFilter:")
        fButton.tintColor = .blackColor()
        self.navigationItem.leftBarButtonItem = fButton
        
        yelpClient = YelpClient(consumerKey: consumerKey, consumerSecret: consumerSecret, accessToken: accessToken, accessSecret: accessSecret)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshData:" , name: "searchFinished", object: nil)
        yelpClient.search(searchPreferences.searchTerm)
    }
    
    
    func clickFilter(sender: AnyObject) {
    
        performSegueWithIdentifier("filterSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData(sender: AnyObject) {
        
        searchPreferences.searchTerm = searchBar.text
        searchResults = yelpClient.searchResults!
        println("search results : \(searchResults.count)")
        if (isSearch) {
            
            println("search display")
            self.searchDisplayController?.active = false
            isSearch = false
        }
        
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableView == self.tableView ? searchResults.count : filteredCategories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var isSearch = (tableView == self.tableView) ? false : true
        if (isSearch) {
            
            var cell = UITableViewCell()
            cell.textLabel?.text = self.filteredCategories[indexPath.row]
            return cell
            
        } else  {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell") as SearchResultCell
            var searchResult = searchResults[indexPath.row]
            cell.populate(searchResult)
            return cell
        }
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        filterCategories(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        
        filterCategories(controller!.searchBar.text)
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var isSearch = (tableView == self.tableView) ? false : true
        if (isSearch) {
            
            var selected = self.filteredCategories[indexPath.row]
            self.searchDisplayController?.active = false
            self.searchDisplayController?.searchBar.text = selected
            yelpClient.search(selected)
            
        } else {
            
            // show details
            println("selected : \(indexPath.row)")
            
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        var searchFor = searchBar.text
        isSearch = true
        yelpClient.search(searchFor)
    }
    
    
    func filterCategories(searchText: String) {
        
        self.filteredCategories = YelpClient.supportedCategories().filter({
            (category: String) -> Bool in
            let stringMatch = category.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil)
            return stringMatch != nil
        })
        
        println(self.filteredCategories.count)
    }

    func filtersChanged(filters: SearchPreferences) {

        println("List :: Filters Changed :: \(filters.radiusText), \(filters.sortByText)")
        yelpClient.search(filters.searchTerm)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "filterSegue" {
        
            let filterNavigationController = segue.destinationViewController as UINavigationController
            let filterController = filterNavigationController.viewControllers[0] as FilterController
            filterController.delegate = self
        }
    }
}
