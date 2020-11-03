//
//  SearchTextField.swift
//  CodingChallenge
//
//  Created by Jared on 11/3/20.
//

import Foundation
import SwiftUI

// MARK: -Used to search for images
struct SearchTextField: View {
    @ObservedObject var photos : PhotosObject
    @Binding var text: String
    
    var placeholder: Text
    var editingChanged: (Bool)->() = { _ in }

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: {
                self.photos.currentPage = 1
                self.photos.search()
            }).accentColor(.white).foregroundColor(.white)
        }
    }
}
