//
//  User.swift
//  CodingChallenge
//
//  Created by Jared on 11/3/20.
//

import Foundation

// MARK: - Used for the the data in the fullscreen view.
struct PostData : Codable, Hashable {
    var user : User
}

struct User : Identifiable, Codable, Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    // MARK: -Variable required
    let id : String
    let username : String
    let profile_image : ProfileImage
    
    // MARK: - Break apart the variables from the JSON
    enum CodingKeys : String, CodingKey {
        case id
        case profile_image
        case username
    }
    
    // MARK: - First initializer
    init() {
        self.id = ""
        self.profile_image = ProfileImage(large: "", medium: "", small: "")
        self.username = ""
    }
    
    // MARK: - Decode the data from JSON
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
        self.profile_image = try values.decode(ProfileImage.self, forKey: .profile_image)
        self.username = try values.decodeIfPresent(String.self, forKey: .username) ?? ""
    }
}

struct ProfileImage : Codable, Hashable {
    let large : String
    let medium : String
    let small : String
}

