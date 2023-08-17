//
//  CurrencyViewBackground.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 16/08/2023.
//

import SwiftUI

struct CurrencyViewBackground: View {
    var isSelected: Bool
    var isLimitExceeded: Bool = false
    
    private var color: Color { isSelected ? .white : Color(.systemGray5) }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .strokeBorder(.red, lineWidth: isLimitExceeded ? 2 : 0)
            .background(color)
            .cornerRadius(15)
            .shadow(radius: isSelected ? 10 : 0)
    }
}

struct CurrencyViewBackground_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyViewBackground(
            isSelected: true,
            isLimitExceeded: true
        )
    }
}
