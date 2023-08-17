//
//  EditableCurrencyView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 16/08/2023.
//

import SwiftUI

// todo: this view is related to CurrencyView - when we change this one we probably should change another one too - we should deal with this somehow differently so we make changes to common things only in one place

// todo: would be nice to be able to close the keypad with some button or just background click - there's no such button on the decimal keypad as we have on normal one

struct EditableCurrencyView: View {
    var title: String
    var country: Country
    @Binding var amount: String
    @Binding var shouldFocusTextField: Bool
    var selected: Bool
    var enabled: Bool
    var limitExceeded: Bool
    
    var onTap: () -> Void
    var onAmountTap: () -> Void
    
    @FocusState private var textFieldFocused: Bool
    @State private var storedLastAmount: String = ""
    
    var body: some View {
        ZStack {
            CurrencyViewBackground(
                selected: selected,
                borderVisible: limitExceeded
            )
            HStack {
                TitleAndFlagView(
                    title: title,
                    country: country
                )
                Spacer().frame(width: 30)
                TextField(storedLastAmount, text: $amount)
                    .focused($textFieldFocused)
                    .onChange(of: textFieldFocused) {
                        shouldFocusTextField = $0
                    }
                    .onChange(of: shouldFocusTextField) {
                        self.textFieldFocused = $0
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { _ in
                        storedLastAmount = amount
                        amount = ""
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidEndEditingNotification)) { _ in
                        if amount == "" {
                            amount = storedLastAmount
                        } else if let number = Double(amount) {
                            amount = String(format: "%.2f", number)
                        } else {
                            amount = storedLastAmount
                        }
                    }
                    .keyboardType(.decimalPad)
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
        .overlay {
            if !enabled {
                CurrencyViewOverlay(
                    selected: selected
                )
            }
        }
    }
}

struct EditableCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        EditableCurrencyView(
            title: "Sending from:",
            country: PredefinedCountry.poland,
            amount: .constant("100.00"), // or empty,
            shouldFocusTextField: .constant(true), // or false
            selected: true, // or false
            enabled: true, // or false
            limitExceeded: true,
            onTap: { print("onTap") },
            onAmountTap: { print("onAmountTap") }
        )
    }
}
