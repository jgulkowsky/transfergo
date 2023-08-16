//
//  EditableCurrencyView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 16/08/2023.
//

import SwiftUI

// todo: this view is related to CurrencyView - when we change this one we probably should change another one too - we should deal with this somehow differently so we make changes to common things only in one place

// todo: make it possible to lose focus from the CurrencyConverterViewModel

// todo: select whole amount when focus is gained

struct EditableCurrencyView: View {
    var title: String
    var country: Country
    @Binding var amount: String
    var isSelected: Bool
    
    var onTap: () -> Void
    var onAmountTap: () -> Void
    
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
                Spacer().frame(width: 30)
                TextField("", text: $amount)
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
                    .onTapGesture {
                        onAmountTap()
                    }
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

struct EditableCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        EditableCurrencyView(
            title: "Sending from:",
            country: PredefinedCountry.poland,
            amount: .constant("100.00"), // or empty
            isSelected: true, // or false
            onTap: { print("onTap") },
            onAmountTap: { print("onAmountTap") }
        )
    }
}
