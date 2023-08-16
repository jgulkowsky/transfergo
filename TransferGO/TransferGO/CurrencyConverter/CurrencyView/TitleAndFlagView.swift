//
//  TitleAndFlagView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 16/08/2023.
//

import SwiftUI

struct TitleAndFlagView: View {
    var title: String
    var country: Country
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(Color(.systemGray))
                .font(.system(size: 16))
            HStack {
                Image(country.flagImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                Text(country.code)
                    .fontWeight(.bold)
                Image(systemName: "chevron.down")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10, height: 10)
                    .foregroundColor(Color(.systemGray))
            }
        }
    }
}

struct TitleAndFlagView_Previews: PreviewProvider {
    static var previews: some View {
        TitleAndFlagView(
            title: "Some title",
            country: PredefinedCountry.poland
        )
    }
}
