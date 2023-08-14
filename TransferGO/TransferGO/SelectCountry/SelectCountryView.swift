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
        VStack {
            Capsule()
                .fill(Color.gray)
                .frame(width: 30, height: 3)
                .padding(10)
            
            Text(viewModel.title)
                .font(.system(size: 22))
                .fontWeight(.bold)
            
            Spacer().frame(height: 22)
            
            SearchBar(text: $viewModel.searchText)
            
            List {
                Section(header: Text("All Countries")) {
                    ForEach(viewModel.countries, id: \.self) { country in
                        CountryView(
                            country: country,
                            onTap: {
                                dismiss()
                                viewModel.onCountryTapped(country)
                            }
                        )
                    }
                }
                .listSectionSeparator(.hidden)
                .foregroundColor(.black)
                .fontWeight(.bold)
            }
            .listStyle(.plain)
            .padding(.top, -10)
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
