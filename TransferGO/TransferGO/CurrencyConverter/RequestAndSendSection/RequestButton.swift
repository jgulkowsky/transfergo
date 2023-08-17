//
//  RequestButton.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 17/08/2023.
//

import SwiftUI

struct RequestButton: View {
    var enabled: Bool
    var onTap: () -> Void
    
    var body: some View {
        SolidButton(
            imageAssetName: "arrow.down.right",
            text: "Request",
            foregroundColor: .black,
            backgroundColor: Color(.systemGray5),
            enabled: enabled,
            onTap: { onTap() }
        )
    }
}

struct RequestButton_Previews: PreviewProvider {
    static var previews: some View {
        RequestButton(enabled: false) {
            print("onTap")
        }
    }
}
