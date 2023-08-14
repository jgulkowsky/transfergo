//
//  CurrencyConverterView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import SwiftUI

struct CurrencyConverterInfo {
    var fromCountry: String?
    var toCountry: String?
    var fromAmount: Int?
}

class CurrencyConverterViewModel: ObservableObject {
    var coordinator: Coordinator
    @Published var fromCountry: String!
    @Published var toCountry: String!
    @Published var fromAmount: Int!
    
    init(info: CurrencyConverterInfo, coordinator: Coordinator) {
        if let fromCountry = info.fromCountry {
            self.fromCountry = fromCountry
        }
        
        if let toCountry = info.toCountry {
            self.toCountry = toCountry
        }
        
        if let fromAmount = info.fromAmount {
            self.fromAmount = fromAmount
        }
        
        self.coordinator = coordinator
    }
    
    func sendFromTapped() {
        // todo: move to front if needed
        coordinator.goToSelectCountry(SelectCountryInfo(type: .from))
    }
    
    func sendToTapped() {
        // todo: move to front if needed
        coordinator.goToSelectCountry(SelectCountryInfo(type: .to))
    }
    
    func switchTapped() {
        // todo: replace
    }
    
    func amountTapped() {
        // todo: open keyboard
    }
}

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
