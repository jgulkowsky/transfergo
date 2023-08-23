//
//  CoordinatorObject.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import Foundation

class CoordinatorObject: ObservableObject, Coordinator {
    @Published var currencyConverterViewModel: CurrencyConverterViewModel!
    @Published var selectCountryViewModel: SelectCountryViewModel?
    
    private let countriesProvider = CountriesProvider()
    
    private let rateProvider: RateProviding = RateProvider(
        urlProvider: URLProvider(),
        requestHandler: RequestHandler(),
        responseHandler: ResponseHandler(
            decoder: DataDecoder()
        )
    )
    
    init() {
        self.currencyConverterViewModel = CurrencyConverterViewModel(
            info: CurrencyConverterInfo(
                fromCountry: PredefinedCountry.poland,
                toCountry: PredefinedCountry.ukraine,
                fromAmount: 300.0
            ),
            coordinator: self,
            rateProvider: rateProvider,
            scheduler: Scheduler(interval: 10.0),
            networkStatusProvider: NetworkStatusProvider())
    }
    
    func goToSelectCountry(_ info: SelectCountryInfo) {
        self.selectCountryViewModel = SelectCountryViewModel(
            info: info, coordinator: self, countriesProvider: countriesProvider
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
