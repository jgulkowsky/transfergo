//
//  CurrentRateView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 16/08/2023.
//

import SwiftUI

struct CurrentRateView: View {
    @Binding var currentRate: String
    
    var body: some View {
        Text(currentRate)
            .font(.system(size: 10, weight: .bold))
            .padding(.vertical, 3)
            .padding(.horizontal, 10)
            .background(.black)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

struct CurrentRateView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentRateView(
            currentRate: .constant("1 PLN ~ 7.23384 UAH")
        )
    }
}
