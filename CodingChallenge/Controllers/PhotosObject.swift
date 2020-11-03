//
//  PhotosObject.swift
//  CodingChallenge
//
//  Created by Jared on 11/2/20.
//

import Foundation
import SwiftUI
import Combine

class PhotosObject :  ObservableObject {
    // MARK: -Used to hold all of the searched photos
    @Published var results = [Result]()
    @Published var currentPage = 1
    @Published var searchText = ""

    // MARK: -Calls when scrolling down
    func loadNextPage() {
        self.currentPage += 1
        self.search()
    }
    
    // MARK: -Searches the API
    func search() {
        if currentPage == 1 {
            self.results.removeAll()
            UIApplication.shared.endEditing()
        }
        let url = URL(string: String("https://api.unsplash.com/search/photos?page=\(currentPage)&query=\(searchText)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        
        // MARK: -Breaks apart the data
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let data = data else { return }
            do {
                let res = try JSONDecoder().decode(Results.self, from: data)
                DispatchQueue.main.async {
                    self.results.append(contentsOf: res.results)
                }
            } catch let error {
                print(error)
            }
        })
        task.resume()
    }
}
