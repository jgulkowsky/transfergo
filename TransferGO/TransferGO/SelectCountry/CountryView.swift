//
//  CountryView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import SwiftUI

struct CountryView: View {
    var country: Country
    var onTap: () -> Void
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 45, height: 45)
                
                Image(country.flagImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
            
            Spacer().frame(width: 20)
            
            VStack(alignment: .leading) {
                Text(country.name)
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                
                Spacer().frame(height: 5)
                
                Text(country.currency + " - " + country.code)
                    .font(.system(size: 14))
                    .fontWeight(.regular)
                    .foregroundColor(Color(.systemGray))
            }
            
            Spacer()
        }
        .onTapGesture {
            onTap()
        }
    }
}

struct CountryView_Previews: PreviewProvider {
    static var previews: some View {
        CountryView(
            country: PredefinedCountry.poland,
            onTap: {
                print("onTap")
            }
        )
    }
}
