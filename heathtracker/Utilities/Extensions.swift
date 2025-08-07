//
//  Extensions.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
