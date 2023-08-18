//
//  ErrorText.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 16/08/2023.
//

import SwiftUI

struct ErrorText: View {
    var error: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.circle")
            Text(error)
                .font(.system(size: 16))
        }
        .foregroundStyle(.red)
    }
}

struct ErrorButton_Previews: PreviewProvider {
    static var previews: some View {
        ErrorText(error: "Some error")
    }
}
