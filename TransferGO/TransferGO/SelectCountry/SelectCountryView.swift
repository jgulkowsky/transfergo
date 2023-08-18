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
            
            if viewModel.showLoadingIndicator {
                Spacer().frame(height: 20)
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                }
                Spacer()
            }
            
            if viewModel.showError {
                Spacer().frame(height: 20)
                ErrorText(error: .constant("Cannot fetch countries")) // todo: we should rather get rid off binding in ErrorText - just normal String should be enough
                Spacer()
            }
            
            if viewModel.showList {
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
        .task { // todo: it would be nice to start this task as soon as we open the app - so when user gets to this screen he sees countries (that are held in cache) - and only when he is really fast he will see loading indicator for the task that was started before we opened this screen
            await viewModel.getAllCountries()
        }
    }
}

struct SelectCountrySheetView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCountryView(
            viewModel: SelectCountryViewModel(
                info: SelectCountryInfo(type: .from),
                coordinator: CoordinatorObject(),
                countriesProvider: CountriesProvider()
            )
        )
    }
}
