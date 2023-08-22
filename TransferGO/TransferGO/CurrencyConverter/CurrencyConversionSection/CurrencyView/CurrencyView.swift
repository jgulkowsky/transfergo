//
//  CurrencyView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 17/08/2023.
//

import SwiftUI

struct CurrencyView<Content: View>: View {
    var title: String
    var country: Country
    var selected: Bool
    var enabled: Bool
    var borderVisible: Bool
    
    let amountView: Content
    
    var onTap: () -> Void
    
    var body: some View {
        ZStack {
            CurrencyViewBackground(
                selected: selected,
                borderVisible: borderVisible
            )
            HStack {
                TitleAndFlagView(
                    title: title,
                    country: country
                )
                Spacer()
                amountView
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

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView(
            title: "Some title:",
            country: PredefinedCountry.poland,
            selected: true,
            enabled: true,
            borderVisible: true,
            amountView:
                Text(1200.0.limitDecimalPlaces(to: 2)) // or "---"
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
                    .padding(.leading, 30),
            onTap: { print("onTap") }
        )
    }
}
