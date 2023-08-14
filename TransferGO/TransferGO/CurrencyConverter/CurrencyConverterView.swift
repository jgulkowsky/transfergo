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
                    CurrencyView(
                        title: "Sending from",
                        country: viewModel.fromCountry,
                        amount: viewModel.fromAmount,
                        isSelected: true,
                        onTap: {
                            viewModel.sendFromTapped()
                        }
                    )
                    .zIndex(1)
                    
                    CurrencyView(
                        title: "Receiver gets",
                        country: viewModel.toCountry,
                        amount: viewModel.toAmount,
                        isSelected: false,
                        onTap: {
                            viewModel.sendToTapped()
                        }
                    )
                    .zIndex(0)
                    .offset(y: 90)
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
