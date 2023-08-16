//
//  CurrencyView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import SwiftUI

struct CurrencyView: View {
    var title: String
    var country: Country
    @Binding var amount: String
    var isSelected: Bool
    var isAmountEditable: Bool
    
    var onTap: () -> Void
    var onAmountTap: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(isSelected ? .white : Color(.systemGray5))
                .cornerRadius(15)
                .shadow(radius: isSelected ? 10 : 0)
            HStack {
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
                // todo: a lot of similarities maybe we should move these into common place?
                if isAmountEditable {
                    Spacer().frame(width: 30)
                    TextField("", text: $amount)
                        .multilineTextAlignment(.trailing)
                        .font(.system(size: 35))
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)
                        .onTapGesture {
                            onAmountTap?()
                        }
                } else {
                    Spacer()
                    Text((amount.isEmpty) ? "---" : amount)
                        .multilineTextAlignment(.trailing)
                        .font(.system(size: 35))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)
                        .padding(.leading, 30)
                }
            }
            .padding()
        }
        .frame(height: 105)
        .padding()
        .onTapGesture {
            onTap()
        }
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView(
            title: "Sending from:",
            country: PredefinedCountry.poland,
            amount: .constant("100.00"), // or empty
            isSelected: true, // or false
            isAmountEditable: true, // or false
            onTap: { print("onTap") },
            onAmountTap: { print("onAmountTap") } // or nil
        )
    }
}
