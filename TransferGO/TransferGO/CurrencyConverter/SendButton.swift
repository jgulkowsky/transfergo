//
//  SendButton.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 17/08/2023.
//

import SwiftUI

struct SendButton: View {
    var enabled: Bool
    var onTap: () -> Void
    
    var body: some View {
        SolidButton(
            imageAssetName: "arrow.up.right",
            text: "Send",
            foregroundColor: .white,
            backgroundColor: .blue,
            enabled: enabled,
            onTap: { onTap() }
        )
    }
}

struct SendButton_Previews: PreviewProvider {
    static var previews: some View {
        SendButton(enabled: false) {
            print("onTap")
        }
    }
}
