//
//  BellItemView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 17/08/2023.
//

import SwiftUI

struct BellItemView: View {
    var onTap: () -> Void
    
    var body: some View {
        ToolbarItemView(
            imageAssetName: "bell", // or bell.badge when we have notification
            onTap: onTap
        )
    }
}

struct BellItemView_Previews: PreviewProvider {
    static var previews: some View {
        BellItemView {
            print("onTap")
        }
    }
}
