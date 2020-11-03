//
//  Extensions.swift
//  CodingChallenge
//
//  Created by Jared on 11/3/20.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - Extension to get index and value of an array
extension Collection {
  func enumeratedArray() -> Array<(offset: Int, element: Self.Element)> {
    return Array(self.enumerated())
  }
}


// MARK: - extension for keyboard to dismiss
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
