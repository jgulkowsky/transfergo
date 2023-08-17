//
//  MenuItemView.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 17/08/2023.
//

import SwiftUI

struct MenuItemView: View {
    var onTap: () -> Void
    
    var body: some View {
        ToolbarItemView(
            imageAssetName: "line.3.horizontal",
            text: "Menu",
            onTap: onTap
        )
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemView {
            print("onTap")
        }
    }
}
