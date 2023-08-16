//
//  CurrencyConverterView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import SwiftUI

// todo: we have problem as when we taps on the bottom currency view the switch button and current rate view are not aligned with the border between currencyViews (as this border is movable): for now I'm fixing this with moving the switch button and current rate view up and down but this is not fine - we should either remove possibility to select bottom view or separate them more so everything looks fine

// todo: add overlays to CurrencyViewsSeparator and SwitchButton and CurrentRateView too (maybe there's better apporach that's more generic so we don't have to change these views just set them disabled(true) or sth similar)

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
                        isSelected: true,
                        isEnabled: viewModel.connectionError == nil,
                        onTap: {
                            viewModel.sendFromTapped()
                        },
                        onAmountTap: {
                            viewModel.amountTapped()
                        }
                    )
                    .zIndex(2)
                    
                    CurrencyViewsSeparator()
                        .zIndex(1) // it makes bottom CurrencyView top rounded corners invisible
                    
                    CurrencyView(
                        title: "Receiver gets",
                        country: viewModel.toCountry,
                        amount: viewModel.toAmount,
                        isSelected: false,
                        isEnabled: viewModel.connectionError == nil,
                        onTap: {
                            viewModel.sendToTapped()
                        }
                    )
                    .zIndex(0)
                    .offset(y: 95)
                    
                    HStack {
                        Spacer().frame(width: 60)
                        SwitchButton {
                            viewModel.switchTapped()
                        }
                        Spacer()
                    }
                    .zIndex(3)
                    .offset(y: 53)
                    
                    CurrentRateView(currentRate: $viewModel.currentRate)
                        .zIndex(2)
                        .offset(y: 53)
                }
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
//                        viewModel.menuTapped()
                    } label: {
                        HStack {
                            Image(systemName: "line.3.horizontal")
                            Text("Menu")
                        }
                    }
                    .tint(.black)
                    .fontWeight(.bold)
                    .disabled(true)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
//                        viewModel.bellTapped()
                    } label: {
                        Image(systemName: "bell") // or bell.badge when we have notification
                    }
                    .tint(.black)
                    .fontWeight(.bold)
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
