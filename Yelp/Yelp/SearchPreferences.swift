//
//  SearchPreferences.swift
//  Yelp
//
//  Created by sanket patel on 9/22/14.
//  Copyright (c) 2014 sanket patel. All rights reserved.
//

import Foundation
class SearchPreferences {

    // default values
    var searchTerm = "food"
    var priceRange = 0
    var radiusText = "Auto"
    var radius = 1609
    var sortByText = "Best Match"
    var sortBy = 1
    var categories: [String] = []
    
    struct Static {
    
        static var instance: SearchPreferences?
    }
    
    
    class var sharedInstance: SearchPreferences {
    
    
        if (Static.instance == nil) {
        
            Static.instance = SearchPreferences()
        
        }
        
        return Static.instance!
    }
    
    
    func removeCategory(category: String) {
    
        if let index = find(categories, category) {
        
            categories.removeAtIndex(index)
        }
    }
    
    func addCategory(category: String) {
    
    
        if let index = find(categories, category) {
        
            
        } else {
        
            categories.append(category)
        }
    }
    
    func save() {
    
    
    }
}