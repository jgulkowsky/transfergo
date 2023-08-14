//
//  SelectCountryView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import SwiftUI

struct SelectCountryView: View {
    @ObservedObject var viewModel: SelectCountryViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack {
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 30, height: 3)
                    .padding(10)
                
                Text(viewModel.title)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                
                SearchBar(text: $viewModel.searchText)
                
                ForEach(viewModel.countries, id: \.self) { country in
                    Button(country.name) {
                        dismiss()
                        viewModel.onCountryTapped(country)
                    }
                    .font(.title)
                    .padding()
                    .background(.black)
                }
            }
        }
    }
}

struct SelectCountrySheetView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCountryView(
            viewModel: SelectCountryViewModel(
                info: SelectCountryInfo(type: .from),
                coordinator: CoordinatorObject()
            )
        )
    }
}
