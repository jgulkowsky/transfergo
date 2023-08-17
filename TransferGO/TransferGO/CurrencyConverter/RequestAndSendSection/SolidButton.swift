//
//  SolidButton.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 17/08/2023.
//

import SwiftUI

struct SolidButton: View {
    var imageAssetName: String
    var text: String
    var foregroundColor: Color
    var backgroundColor: Color
    var enabled: Bool
    var onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack {
                Image(systemName: imageAssetName)
                Text(text)
            }
            .frame(width: 130)
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(foregroundColor)
            .padding()
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .overlay {
            if !enabled {
                RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(.white, lineWidth: 0)
                    .background(.white.opacity(0.5))
                    .cornerRadius(15)
            }
        }
    }
}

struct SolidButton_Previews: PreviewProvider {
    static var previews: some View {
        SolidButton(
            imageAssetName: "paperplane",
            text: "My button",
            foregroundColor: .white,
            backgroundColor: .purple,
            enabled: true,
            onTap: { print("onTap") }
        )
    }
}
