//
//  CoordinatorView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import SwiftUI

protocol Coordinator {
    func goToSelectCountry(_ info: SelectCountryInfo)
    func goToCurrencyConverter(_ info: CurrencyConverterInfo)
}

class CoordinatorObject: ObservableObject, Coordinator {
    @Published var currencyConverterViewModel: CurrencyConverterViewModel!
    @Published var selectCountryViewModel: SelectCountryViewModel?
    
    init() {
        self.currencyConverterViewModel = CurrencyConverterViewModel(
            info: CurrencyConverterInfo(
                fromCountry: "Poland", toCountry: "Ukraine", fromAmount: 300
            ),
            coordinator: self)
    }
    
    func goToSelectCountry(_ info: SelectCountryInfo) {
        self.selectCountryViewModel = SelectCountryViewModel(
            info: info, coordinator: self
        )
    }
    
    func goToCurrencyConverter(_ info: CurrencyConverterInfo) {
        if let fromCountry = info.fromCountry {
            self.currencyConverterViewModel.fromCountry = fromCountry
        } else if let toCountry = info.toCountry {
            self.currencyConverterViewModel.toCountry = toCountry
        }
    }
}

struct CoordinatorView: View {
    @ObservedObject var object: CoordinatorObject
    
    var body: some View {
        CurrencyConverterView(viewModel: object.currencyConverterViewModel)
            .sheet(item: $object.selectCountryViewModel) {
                SelectCountryView(viewModel: $0)
            }
    }
}

struct CoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorView(object: CoordinatorObject())
    }
}
