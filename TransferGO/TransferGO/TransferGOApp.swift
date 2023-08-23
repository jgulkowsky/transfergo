//
//  TransferGOApp.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 14/08/2023.
//

import SwiftUI

struct TransferGOApp: App {
    @StateObject var coordinatorObject = CoordinatorObject()
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView(object: coordinatorObject)
                .preferredColorScheme(.light) // todo: it would be better to adapt to darkmode but maybe later
        }
    }
}
