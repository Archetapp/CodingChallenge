//
//  InfoView.swift
//  CodingChallenge
//
//  Created by Jared on 11/3/20.
//

import Foundation
import SwiftUI

// MARK: - Shown under the full size image.
struct InfoView : View {
    var postData : Result
    var body: some View {
        VStack {
            UserBanner(user: postData.user)
            if postData.description != "" {
                TextView(title: "Description", data: postData.description ?? "")
            }
        }.padding(20)
    }
}

// MARK: - Shows the user image & username
struct UserBanner : View {
    var user : User
    var body : some View {
        ZStack {
            Color.white
            HStack {
                if user.profile_image.large != "" {
                    RemoteImage(url: URL(string: user.profile_image.large)!, placeholder: {Color.gray.opacity(0.5)}, image:{Image(uiImage: $0).resizable()})
                        .frame(width: 60, height: 60, alignment: .center)
                        .cornerRadius(30)
                        .padding(.horizontal)
                }
                Text(user.username).fontWeight(.light)
                Spacer()
            }.padding()
        }.cornerRadius(20).shadow(radius: 5).frame(height: 100, alignment: .center)
    }
}


// MARK: - Used to have a description of a text.
struct TextView : View {
    var title : String
    var data : String
    var body: some View {
        VStack {
            HStack {
                Text(title).font(.system(size: 20, weight: .bold, design: .rounded))
                Spacer()
            }.padding()
            HStack {
                Text(data).fontWeight(.light)
                Spacer()
            }.padding(.horizontal)
        }
    }
}
