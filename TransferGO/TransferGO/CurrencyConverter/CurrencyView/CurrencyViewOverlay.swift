//
//  CurrencyViewOverlay.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 16/08/2023.
//

import SwiftUI

struct CurrencyViewOverlay: View {
    var isEnabled: Bool
    var isSelected: Bool
    
    private var color: Color { isSelected ? .white : Color(.systemGray5) }
    
    var body: some View {
        if !isEnabled {
            Rectangle()
                .strokeBorder(color, lineWidth: 0)
                .background(color.opacity(0.5))
                .cornerRadius(15)
                .padding()
        }
    }
}

struct CurrencyViewOverlay_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyViewOverlay(
            isEnabled: true,
            isSelected: true
        )
    }
}
