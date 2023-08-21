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
                    .zIndex(1) // it makes bottom NoneditableCurrencyView top rounded corners invisible
                    
                    NoneditableCurrencyView(
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
                        currentRate: viewModel.currentRateText,
                        isEnabled: viewModel.shouldEnableFields
                    )
                    .zIndex(2)
                    .offset(y: 53)
                }
                
                if let error = viewModel.connectionError {
                    ErrorText(error: error)
                        .offset(y: 100)
                } else if let error = viewModel.limitExceededError {
                    ErrorText(error: error)
                        .offset(y: 100)
                } else if let error = viewModel.getCurrentRateError {
                    ErrorText(error: error)
                        .offset(y: 100)
                } // todo: sth wrong with throwing from RateProvider as we get error immediatelly sometimes without waiting for Task.sleep()
                // todo: bug when we select TextField before we get rate for initial 300.00 we immediatelly get error
                // todo: but when we select TextField when we actually have rate for initial 300.00 we immedaitelly get error too
                
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
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.backgroundTapped()
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
                coordinator: CoordinatorObject(),
                rateProvider: RateProvider(
                    urlProvider: URLProvider(),
                    requestHandler: RequestHandler(),
                    responseHandler: ResponseHandler(
                        decoder: DataDecoder()
                    )
                )
            )
        )
    }
}
