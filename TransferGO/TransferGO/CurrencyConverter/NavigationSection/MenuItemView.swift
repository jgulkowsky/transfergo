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
        Button {
            onTap()
        } label: {
            HStack {
                Image(systemName: "line.3.horizontal")
                Text("Menu")
            }
        }
        .tint(.black)
        .fontWeight(.bold)
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemView {
            print("onTap")
        }
    }
}
