//
//  RequestButton.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 17/08/2023.
//

import SwiftUI

// todo: RequestButton and SendButton should have common codebase as we don't want to change sth in both places

struct RequestButton: View {
    var enabled: Bool
    var onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack {
                Image(systemName: "arrow.down.right")
                Text("Request")
            }
            .frame(width: 130)
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(.black)
            .padding()
            .background(Color(.systemGray5))
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

struct RequestButton_Previews: PreviewProvider {
    static var previews: some View {
        RequestButton(enabled: false) {
            print("onTap")
        }
    }
}
