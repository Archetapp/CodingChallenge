//
//  ButtonWithAnimation.swift
//  CodingChallenge
//
//  Created by Jared on 11/3/20.
//

import Foundation
import SwiftUI

protocol ButtonProtocol {
    func sendAction()
}

// MARK: - Used for the Search Button
struct ButtonWithAnimation : View {
    var text : String
    var delegate : ButtonProtocol
    @State var buttonPressed : Bool = false
    var body: some View {
        ZStack {
            Color.white
            Text("Search").foregroundColor(.black).padding(.horizontal, 20)
        }.modifier(TouchDownUpEventModifier(changeState: { (buttonState) in
            if buttonState == .pressed {
                buttonPressed = true
            } else {
                buttonPressed = false
                self.delegate.sendAction()
            }
        })).frame(width: 100, height: 40, alignment: .center).animation(nil).cornerRadius(20).scaleEffect(buttonPressed ? 0.9 : 1.0).shadow(radius: buttonPressed ? 2 : 5).animation(.spring(response: 0.4, dampingFraction: 0.8))
    }
}
