//
//  CurrencyConverterView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import SwiftUI

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
                        isSelected: viewModel.selectedItem == .from,
                        onTap: {
                            viewModel.sendFromTapped()
                        },
                        onAmountTap: {
                            viewModel.amountTapped()
                        }
                    )
                    .zIndex(viewModel.fromZIndex)
                    
                    CurrencyView(
                        title: "Receiver gets",
                        country: viewModel.toCountry,
                        amount: viewModel.toAmount,
                        isSelected: viewModel.selectedItem == .to,
                        onTap: {
                            viewModel.sendToTapped()
                        }
                    )
                    .zIndex(viewModel.toZIndex)
                    .offset(y: 90)
                    
                    HStack {
                        Spacer().frame(width: 60)
                        SwitchButton {
                            viewModel.switchTapped()
                        }
                        Spacer()
                    }
                    .zIndex(2)
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
