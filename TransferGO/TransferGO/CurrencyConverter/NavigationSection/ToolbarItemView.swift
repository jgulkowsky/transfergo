//
//  ToolbarItemView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 17/08/2023.
//

import SwiftUI

struct ToolbarItemView: View {
    var imageAssetName: String?
    var text: String?
    var onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack {
                if let imageAssetName = imageAssetName {
                    Image(systemName: imageAssetName)
                }
                if let text = text {
                    Text(text)
                }
            }
        }
        .tint(.black)
        .font(.system(size: 17, weight: .bold))
    }
}

struct ToolbarItemView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarItemView(
            imageAssetName: "pencil",
            text: "some text"
        ) {
            print("onTap")
        }
    }
}
