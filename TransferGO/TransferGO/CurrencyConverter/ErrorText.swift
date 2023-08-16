//
//  ErrorText.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 16/08/2023.
//

import SwiftUI

struct ErrorText: View {
    @Binding var error: String?
    
    var body: some View {
        HStack {
            if error != nil {
                Image(systemName: "exclamationmark.circle")
                    .foregroundStyle(.red)
                Text(error!)
                    .foregroundColor(.red)
            }
        }
    }
}

struct ErrorButton_Previews: PreviewProvider {
    static var previews: some View {
        ErrorText(
            error: .constant("Some error!") // or .constant(nil)
        )
    }
}
