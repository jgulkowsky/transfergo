//
//  CurrencyViewsSeparator.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 16/08/2023.
//

import SwiftUI

struct CurrencyViewsSeparator: View {
    var isEnabled: Bool
    
    var body: some View {
        Rectangle()
            .fill(Color(.systemGray5).opacity(isEnabled ? 1 : 0.5))
            .frame(height: 30)
            .padding()
            .offset(y: 50)
    }
}

struct CurrencyViewsSeparator_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyViewsSeparator(
            isEnabled: true
        )
    }
}
