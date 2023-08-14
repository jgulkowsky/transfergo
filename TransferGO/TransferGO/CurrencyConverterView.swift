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
        VStack {
            Button(action: {
                viewModel.sendFromTapped()
            }, label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Sending from")
                        Text(viewModel.fromCountry)
                    }
                    Spacer()
                    Text("\(viewModel.fromAmount)")
                    
                }
            })
            .padding()
            .background(Color.pink)
            
            Spacer().frame(height: 20)
            
            Button(action: {
                viewModel.sendToTapped()
            }, label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Receiver gets")
                        Text(viewModel.toCountry)
                    }
                    Spacer()
                    Text("---")
                }
            })
            .padding()
            .background(Color.gray)
            
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConverterView(
            viewModel: CurrencyConverterViewModel(
                info: CurrencyConverterInfo(
                    fromCountry: "Poland", toCountry: "Ukraine", fromAmount: 300
                ),
                coordinator: CoordinatorObject()
            )
        )
    }
}
