//
//  CurrencyViewBackground.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 16/08/2023.
//

import SwiftUI

struct CurrencyViewBackground: View {
    var isSelected: Bool
    private var color: Color { isSelected ? .white : Color(.systemGray5) }
    
    var body: some View {
        Rectangle()
            .strokeBorder(color, lineWidth: 0)
            .background(color)
            .cornerRadius(15)
            .shadow(radius: isSelected ? 10 : 0)
    }
}

struct CurrencyViewBackground_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyViewBackground(
            isSelected: true
        )
    }
}
