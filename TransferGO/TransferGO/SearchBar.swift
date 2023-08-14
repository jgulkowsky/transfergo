//
//  SearchBar.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import SwiftUI

// todo: we still miss this little Search text on top - on the border

struct SearchBar: View {
   @Binding var text: String

   var body: some View {
       TextField("", text: $text)
           .autocorrectionDisabled()
           .padding(12)
           .padding(.leading, 5)
           .padding(.trailing, 30)
           .overlay {
               RoundedRectangle(cornerRadius: 8)
                   .stroke(.gray, lineWidth: 1)
               HStack {
                   Spacer()
                   Image(systemName: "magnifyingglass")
                       .foregroundColor(.gray)
                       .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                       .padding(.trailing, 10)
               }
               
           }
           .padding(.horizontal, 15)
   }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}
