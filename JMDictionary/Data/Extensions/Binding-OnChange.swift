//
//  Binding-OnChange.swift
//  UltimatePortfolio
//
//  Created by Kovs on 18.02.2023.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        // onChange func has a handler which is a function that takes nothing and returns nothing
        Binding(
            get: { self.wrappedValue},
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
