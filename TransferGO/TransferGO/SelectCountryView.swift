//
//  SelectCountryView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import SwiftUI

struct SelectCountryView: View {
    @ObservedObject var viewModel: SelectCountryViewModel
    @Environment(\.dismiss) var dismiss // todo: can we do this outside of this struct? (like in Coordinator)

    var body: some View {
        VStack {
            Text((viewModel.type == .from) ? "Sending from" : "Sending to")
            List {
                Button("Germany") {
                    dismiss()
                    viewModel.onCountryTapped("Germany")
                }
                Button("Great Britain") {
                    dismiss()
                    viewModel.onCountryTapped("Great Britain")
                }
                Button("Ukraine") {
                    dismiss()
                    viewModel.onCountryTapped("Ukraine")
                }
            }
            .font(.title)
            .padding()
            .background(.black)
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
