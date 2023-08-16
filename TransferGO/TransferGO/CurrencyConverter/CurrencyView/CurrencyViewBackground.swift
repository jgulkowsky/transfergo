//
//  CurrencyViewBackground.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 16/08/2023.
//

import SwiftUI

struct CurrencyViewBackground: View {
    var isSelected: Bool
    
    var body: some View {
        Rectangle()
            .fill(isSelected ? .white : Color(.systemGray5))
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
