//
//  EditableCurrencyView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 16/08/2023.
//

import SwiftUI

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
        CurrencyView(
            title: title,
            country: country,
            selected: selected,
            enabled: enabled,
            borderVisible: limitExceeded,
            amountView:
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
                    },
            onTap: onTap
        )
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
