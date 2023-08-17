//
//  SendButton.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 17/08/2023.
//

import SwiftUI

// todo: RequestButton and SendButton should have common codebase as we don't want to change sth in both places

struct SendButton: View {
    var enabled: Bool
    var onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack {
                Image(systemName: "arrow.up.right")
                Text("Send")
            }
            .frame(width: 130)
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
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

struct SendButton_Previews: PreviewProvider {
    static var previews: some View {
        SendButton(enabled: false) {
            print("onTap")
        }
    }
}
