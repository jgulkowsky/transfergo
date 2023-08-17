//
//  CurrencyViewBackground.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 16/08/2023.
//

import SwiftUI

struct CurrencyViewBackground: View {
    var selected: Bool
    var borderVisible: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .strokeBorder(.red, lineWidth: borderVisible ? 2 : 0)
            .background(selected ? .white : Color(.systemGray5))
            .cornerRadius(15)
            .shadow(radius: selected ? 10 : 0)
    }
}

struct CurrencyViewBackground_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyViewBackground(
            selected: true,
            borderVisible: true
        )
    }
}
