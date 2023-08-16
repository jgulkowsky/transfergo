//
//  CurrencyView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import SwiftUI

// todo: this view is related to EditableCurrencyView - when we change this one we probably should change another one too - we should deal with this somehow differently so we make changes to common things only in one place

struct CurrencyView: View {
    var title: String
    var country: Country
    var amount: Double?
    var isSelected: Bool
    
    var onTap: () -> Void
    
    var body: some View {
        ZStack {
            CurrencyViewBackground(
                isSelected: isSelected
            )
            HStack {
                TitleAndFlagView(
                    title: title,
                    country: country
                )
                Spacer()
                Text((amount != nil) ? String(format: "%.2f", amount!) : "---")
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
                    .padding(.leading, 30)
            }
            .padding()
        }
        .frame(height: 105)
        .padding()
        .onTapGesture {
            onTap()
        }
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView(
            title: "Sending from:",
            country: PredefinedCountry.poland,
            amount: 100.0, // or nil
            isSelected: true, // or false
            onTap: { print("onTap") }
        )
    }
}
