//
//  CoordinatorView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import SwiftUI

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
