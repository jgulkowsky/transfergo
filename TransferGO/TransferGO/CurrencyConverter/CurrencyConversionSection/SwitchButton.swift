//
//  SwitchButton.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 16/08/2023.
//

import SwiftUI

struct SwitchButton: View {
    var isEnabled: Bool
    var onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .foregroundStyle(.white)
                .padding(5)
                .background(.blue)
                .clipShape(Circle())
        }
        .disabled(!isEnabled)
        .overlay {
            if !isEnabled {
                Circle()
                    .fill(.white.opacity(0.5))
            }
        }
    }
}

struct SwitchButton_Previews: PreviewProvider {
    static var previews: some View {
        SwitchButton(
            isEnabled: false, // false
            onTap: { print("onTap") }
        )
    }
}
