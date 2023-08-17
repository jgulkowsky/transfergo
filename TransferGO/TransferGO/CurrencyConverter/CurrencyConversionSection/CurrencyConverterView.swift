//
//  CurrencyConverterView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import SwiftUI

// todo: we have problem as when we taps on the bottom currency view the switch button and current rate view are not aligned with the border between currencyViews (as this border is movable): for now I'm fixing this with moving the switch button and current rate view up and down but this is not fine - we should either remove possibility to select bottom view or separate them more so everything looks fine

struct CurrencyConverterView: View {
    @ObservedObject var viewModel: CurrencyConverterViewModel

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    EditableCurrencyView(
                        title: "Sending from",
                        country: viewModel.fromCountry,
                        amount: $viewModel.fromAmount,
                        shouldFocusTextField: $viewModel.fromAmountFocused,
                        selected: true,
                        enabled: viewModel.shouldEnableFields,
                        limitExceeded: viewModel.limitExceeded,
                        onTap: {
                            viewModel.sendFromTapped()
                        },
                        onAmountTap: {
                            viewModel.amountTapped()
                        }
                    )
                    .zIndex(2)
                    
                    CurrencyViewsSeparator(
                        isEnabled: viewModel.shouldEnableFields
                    )
                    .zIndex(1) // it makes bottom CurrencyView top rounded corners invisible
                    
                    CurrencyView(
                        title: "Receiver gets",
                        country: viewModel.toCountry,
                        amount: viewModel.toAmount,
                        selected: false,
                        enabled: viewModel.shouldEnableFields,
                        onTap: {
                            viewModel.sendToTapped()
                        }
                    )
                    .zIndex(0)
                    .offset(y: 95)
                    
                    HStack {
                        Spacer().frame(width: 60)
                        SwitchButton(
                            isEnabled: viewModel.shouldEnableFields
                        ) {
                            viewModel.switchTapped()
                        }
                        Spacer()
                    }
                    .zIndex(3)
                    .offset(y: 53)
                    
                    CurrentRateView(
                        currentRate: $viewModel.currentRate,
                        isEnabled: viewModel.shouldEnableFields
                    )
                    .zIndex(2)
                    .offset(y: 53)
                }
                
                if viewModel.connectionError != nil {
                    ErrorText(
                        error: $viewModel.connectionError
                    )
                    .offset(y: 100)
                }
                
                if viewModel.limitExceededError != nil {
                    ErrorText(
                        error: $viewModel.limitExceededError
                    )
                    .offset(y: 100)
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    RequestButton(enabled: false) {
                        viewModel.requestTapped()
                    }
                    Spacer().frame(width: 15)
                    SendButton(enabled: false) {
                        viewModel.sendTapped()
                    }
                    Spacer()
                }
                
                Spacer().frame(height: 10)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    MenuItemView {
                        viewModel.menuTapped()
                    }
                    .disabled(true)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    BellItemView {
                        viewModel.bellTapped()
                    }
                    .disabled(true)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConverterView(
            viewModel: CurrencyConverterViewModel(
                info: CurrencyConverterInfo(
                    fromCountry: PredefinedCountry.poland,
                    toCountry: PredefinedCountry.ukraine,
                    fromAmount: 300.0
                ),
                coordinator: CoordinatorObject()
            )
        )
    }
}
