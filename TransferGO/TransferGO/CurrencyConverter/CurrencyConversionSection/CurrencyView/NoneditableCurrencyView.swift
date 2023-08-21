//
//  NoneditableCurrencyView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import SwiftUI

struct NoneditableCurrencyView: View {
    var title: String
    var country: Country
    var amount: Double?
    var selected: Bool
    var enabled: Bool
    
    var onTap: () -> Void
    
    var body: some View {
        CurrencyView(
            title: title,
            country: country,
            selected: selected,
            enabled: enabled,
            borderVisible: false,
            amountView:
                Text((amount != nil) ? amount!.limitDecimalPlaces(to: 2) : "-")
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .lineLimit(1)
                .minimumScaleFactor(0.01)
                .padding(.leading, 30),
            onTap: onTap
        )
    }
}

struct NoneditableCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        NoneditableCurrencyView(
            title: "Sending from:",
            country: PredefinedCountry.poland,
            amount: 100.0, // or nil
            selected: false, // or true
            enabled: true, // or false
            onTap: { print("onTap") }
        )
    }
}
