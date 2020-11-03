//
//  Photo.swift
//  CodingChallenge
//
//  Created by Jared on 11/2/20.
//

import Foundation
import SwiftUI

// MARK: -JSON Handling from the Unsplash API

struct Results : Codable, Hashable {
    var results : [Result]
    var total : Int
}

struct Result : Identifiable, Codable, Hashable {
    // MARK: -Conform to Hashable
    static func == (lhs: Result, rhs: Result) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    // MARK: -Variable required
    let id : String
    let description : String?
    let urls : URLs
    let width : Double
    let height : Double
    let user : User
    
    // MARK: - Used for presentation
    var isSelected : Bool
    var index : Double
    
    // MARK: - Break apart the variables from the JSON
    enum CodingKeys : String, CodingKey {
        case id
        case urls
        case description
        case width
        case height
        case user
    }
    
    // MARK: - Blank initializer
    init() {
        self.id = ""
        self.urls = URLs(regular: "", small: "", thumb: "")
        self.description = ""
        self.width = 1000
        self.height = 1000
        self.isSelected = false
        self.index = -1
        self.user = User()
    }
    
    // MARK: - Decode the JSON
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
        self.urls = try values.decode(URLs.self, forKey: .urls)
        self.description = try values.decodeIfPresent(String.self, forKey:.description) ?? ""
        self.width = try values.decodeIfPresent(Double.self, forKey: .width) ?? 1000
        self.height = try values.decodeIfPresent(Double.self, forKey: .height) ?? 1000
        self.isSelected = false
        self.index = -1
        self.user = try values.decodeIfPresent(User.self, forKey: .user) ?? User()
    }
}

struct URLs : Codable, Hashable {
    let regular : String
    let small : String
    let thumb : String
}
