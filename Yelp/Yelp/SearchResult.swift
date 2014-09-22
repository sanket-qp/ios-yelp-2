//
//  SearchResult.swift
//  Yelp
//
//  Created by sanket patel on 9/21/14.
//  Copyright (c) 2014 sanket patel. All rights reserved.
//

import Foundation
class SearchResult {
    
    var name: String!
    var stars: String!
    var numOfReviews: Int!
    var address: String!
    var city: String!
    var state: String!
    var country: String!
    var zipcode: String!
    var categories: [String]! = []
    var imageUrl: String!
    var categoryStr: String!
    var neighborhood: String!
    
    init(dict: NSDictionary) {
        
        self.name = dict["name"] as String
        self.imageUrl = (dict["image_url"] ?? "") as String
        self.stars = dict["rating_img_url"] as String
        self.numOfReviews = dict["review_count"] as Int
        var location = dict["location"] as NSDictionary
        var address = (location["address"] ?? [""]) as [String]
        self.address = (address.count > 0 ) ? address[0] : ""
        self.city = location["city"] as String
        self.state = location["state_code"] as String
        self.zipcode = (location["postal_code"] ?? "") as String
        self.categories = ["thai", "vegetarian", "salad"]
        self.categoryStr = combine(categories, separator: ", ")
        var neighborhoods = location["neighborhoods"] != nil ? location["neighborhoods"] as [String] : []
        self.neighborhood = neighborhoods.count > 0 ? neighborhoods[0] : ""
    }
    
    func combine(list: [String], separator: String) -> String{
        var str : String = ""
        for (idx, item) in enumerate(list) {
            str += "\(item)"
            if idx < list.count-1 {
                str += separator
            }
        }
        return str
    }
    
}