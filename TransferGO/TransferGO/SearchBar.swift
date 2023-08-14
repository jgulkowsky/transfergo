//
//  SearchBar.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import SwiftUI

struct SearchBar: View {
   @Binding var text: String

   var body: some View {
       TextField("", text: $text)
           .padding(7)
           .padding(.leading, 5)
           .padding(.trailing, 30)
           .background(Color(.systemGray6))
           .cornerRadius(8)
           .padding(.horizontal, 10)
           .overlay {
               HStack {
                   Spacer()
                   Image(systemName: "magnifyingglass")
                       .foregroundColor(.gray)
                       .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                       .padding(.trailing, 20)
               }
           }
   }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}
