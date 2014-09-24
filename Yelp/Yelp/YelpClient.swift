//
//  YelpClient.swift
//  yelp
//
//  Created by sanket patel on 9/19/14.
//  Copyright (c) 2014 sanket patel. All rights reserved.
//

import Foundation
import UIKit

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    var searchResults: [SearchResult]? {
        
        didSet {
            
            println("search done")
            NSNotificationCenter.defaultCenter().postNotificationName("searchFinished", object: self)
        }
    }
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func search(term: String, location: String = "San Francisco", limit: Int = 10) {
        
        var parameters = ["term": term, "location": location, "limit": limit]
        var data = self.GET("search", parameters: parameters, success: { (operation, response) -> Void in
            
            var object = response as NSDictionary
            var businesses = object["businesses"] as [NSDictionary]
            let mapped = businesses.map({ (business: NSDictionary) -> SearchResult in
                
                SearchResult(dict: business)
            })
            
            self.searchResults = mapped
            
            }) { (operation, error) -> Void in
                
                self.searchResults = []
                println(error)
        }
    }
    
    func searchWithTerm(term: String, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        var parameters = ["term": term, "location": "San Francisco"]
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }
    
    class func supportedCategories() -> [String] {
        
        var categories = ["Amateur Sports Teams", "Amusement Parks", "Aquariums", "Archery", "Beaches", "Bike Rentals", "Boating", "Bowling", "Climbing", "Disc Golf", "Diving", "Fishing", "Fitness & Instruction", "Go Karts", "Golf", "Gun/Rifle Ranges", "Hiking", "Horse Racing", "Horseback Riding", "Lakes", "Leisure Centers", "Mini Golf", "Mountain Biking", "Paintball", "Parks", "Playgrounds", "Rafting/Kayaking", "Recreation Centers", "Rock Climbing", "Skating Rinks", "Skydiving", "Soccer", "Sports Clubs", "Summer Camps", "Surfing", "Swimming Pools", "Tennis", "Zoos", "Arcades", "Art Galleries", "Botanical Gardens", "Casinos", "Cinema", "Festivals", "Jazz & Blues", "Museums", "Music Venues", "Opera & Ballet", "Performing Arts", "Professional Sports Teams", "Psychics & Astrologers", "Social Clubs", "Stadiums & Arenas", "Wineries", "Auto Detailing", "Auto Glass Services", "Auto Parts & Supplies", "Auto Repair", "Body Shops", "Car Dealers", "Car Stereo Installation", "Car Wash", "Gas & Service Stations", "Motorcycle Dealers", "Motorcycle Repair", "Oil Change Stations", "Parking", "RV Dealers", "Smog Check Stations", "Tires", "Towing", "Truck Rental", "Windshield Installation & Repair", "Barbers", "Cosmetics & Beauty Supply", "Day Spas", "Eyelash Service", "Hair Extensions", "Hair Removal", "Hair Salons", "Makeup Artists", "Massage", "Medical Spas", "Nail Salons", "Piercing", "Rolfing", "Skin Care", "Tanning", "Tattoo", "Adult Education", "Colleges & Universities", "Educational Services", "Elementary Schools", "Middle Schools & High Schools", "Preschools", "Private Tutors", "Special Education", "Specialty Schools", "Test Preparation", "Tutoring Centers", "Boat Charters", "Cards & Stationery", "Caterers", "Clowns", "DJs", "Hotels", "Magicians", "Officiants", "Party & Event Planning", "Party Supplies", "Personal Chefs", "Photographers", "Venues & Event Spaces", "Videographers", "Wedding Planning", "Banks & Credit Unions", "Check Cashing/Pay-day Loans", "Financial Advising", "Insurance", "Investing", "Tax Services", "Bagels", "Bakeries", "Beer, Wine & Spirits", "Breweries", "Butcher", "Coffee & Tea", "Convenience Stores", "Desserts", "Do-It-Yourself Food", "Donuts", "Farmers Market", "Food Delivery Services", "Grocery", "Ice Cream & Frozen Yogurt", "Internet Cafes", "Juice Bars & Smoothies", "Specialty Food", "Street Vendors", "Tea Rooms", "Wineries", "Acupuncture", "Cannabis Clinics", "Chiropractors", "Counseling & Mental Health", "Dentists", "Doctors", "Home Health Care", "Hospice", "Hospitals", "Laser Eye Surgery/Lasik", "Massage Therapy", "Medical Centers", "Medical Spas", "Midwives", "Nutritionists", "Optometrists", "Physical Therapy", "Reflexology", "Rehabilitation Center", "Retirement Homes", "Speech Therapists", "Traditional Chinese Medicine", "Urgent Care", "Weight Loss Centers", "Building Supplies", "Carpet Installation", "Carpeting", "Contractors", "Electricians", "Flooring", "Garage Door Services", "Gardeners", "Handyman", "Heating & Air Conditioning/HVAC", "Home Cleaning", "Home Inspectors", "Home Organization", "Home Theatre Installation", "Interior Design", "Internet Service Providers", "Keys & Locksmiths", "Landscape Architects", "Landscaping", "Lighting Fixtures & Equipment", "Masonry/Concrete", "Movers", "Painters", "Plumbing", "Pool Cleaners", "Real Estate", "Roofing", "Security Systems", "Shades & Blinds", "Solar Installation", "Television Service Providers", "Tree Services", "Window Washing", "Windows Installation", "Airports", "Bed & Breakfast", "Campgrounds", "Car Rental", "Guest Houses", "Hostels", "Hotels", "Motorcycle Rental", "RV Rental", "Ski Resorts", "Tours", "Transportation", "Travel Services", "Vacation Rental Agents", "Vacation Rentals", "Appliances & Repair", "Bail Bondsmen", "Bike Repair/Maintenance", "Carpet Cleaning", "Child Care & Day Care", "Community Service/Non-Profit", "Couriers & Delivery Services", "Dry Cleaning & Laundry", "Electronics Repair", "Funeral Services & Cemeteries", "Furniture Reupholstery", "IT Services & Computer Repair", "Junk Removal and Hauling", "Notaries", "Pest Control", "Printing Services", "Recording & Rehearsal Studios", "Recycling Center", "Screen Printing", "Screen Printing/T-Shirt Printing", "Self Storage", "Sewing & Alterations", "Shipping Centers", "Shoe Repair", "Snow Removal", "Watch Repair", "Print Media", "Radio Stations", "Television Stations", "Adult Entertainment", "Bars", "Comedy Clubs", "Dance Clubs", "Jazz & Blues", "Karaoke", "Music Venues", "Pool Halls", "Animal Shelters", "Horse Boarding", "Pet Services", "Pet Stores", "Veterinarians", "Accountants", "Advertising", "Architects", "Boat Repair", "Career Counseling", "Employment Agencies", "Graphic Design", "Internet Service Providers", "Lawyers", "Life Coach", "Marketing", "Office Cleaning", "Private Investigation", "Public Relations", "Video/Film Production", "Web Design", "Departments of Motor Vehicles", "Landmarks & Historical Buildings", "Libraries", "Police Departments", "Post Offices", "Apartments", "Home Staging", "Mortgage Brokers", "Property Management", "Real Estate Agents", "Real Estate Services", "University Housing", "Buddhist Temples", "Churches", "Hindu Temples", "Mosques", "Synagogues", "Afghan", "African", "American (New)", "American (Traditional)", "Argentine", "Asian Fusion", "Barbeque", "Basque", "Belgian", "Brasseries", "Brazilian", "Breakfast & Brunch", "British", "Buffets", "Burgers", "Burmese", "Cafes", "Cajun/Creole", "Cambodian", "Caribbean", "Cheesesteaks", "Chicken Wings", "Chinese", "Creperies", "Cuban", "Delis", "Diners", "Ethiopian", "Fast Food", "Filipino", "Fish & Chips", "Fondue", "Food Stands", "French", "Gastropubs", "German", "Gluten-Free", "Greek", "Halal", "Hawaiian", "Himalayan/Nepalese", "Hot Dogs", "Hungarian", "Indian", "Indonesian", "Irish", "Italian", "Japanese", "Korean", "Kosher", "Latin American", "Live/Raw Food", "Malaysian", "Mediterranean", "Mexican", "Middle Eastern", "Modern European", "Mongolian", "Moroccan", "Pakistani", "Persian/Iranian", "Peruvian", "Pizza", "Polish", "Portuguese", "Russian", "Salad", "Sandwiches", "Scandinavian", "Seafood", "Singaporean", "Soul Food", "Soup", "Southern", "Spanish", "Steakhouses", "Sushi Bars", "Taiwanese", "Tapas Bars", "Tapas/Small Plates", "Tex-Mex", "Thai", "Turkish", "Ukrainian", "Vegan", "Vegetarian", "Vietnamese", "Adult", "Antiques", "Art Galleries", "Arts & Crafts", "Baby Gear & Furniture", "Books, Mags, Music and Video", "Bridal", "Computers", "Cosmetics & Beauty Supply", "Department Stores", "Discount Store", "Drugstores", "Electronics", "Eyewear & Opticians", "Fashion", "Fireworks", "Flowers & Gifts", "Guns & Ammo", "Hobby Shops", "Home & Garden", "Jewelry", "Knitting Supplies", "Luggage", "Mobile Phones", "Musical Instruments & Teachers", "Office Equipment", "Outlet Stores", "Pawn Shops", "Personal Shopping", "Photography Stores & Services", "Shopping Centers", "Sporting Goods", "Thrift Stores", "Tobacco Shops", "Toy Stores", "Watches", "Wholesale Stores"]
        
        return categories
    }
    
    class func categoryDict() -> [String: String] {
    
        return ["Hello": "world"]
    }
}