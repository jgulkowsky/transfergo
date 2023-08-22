//
//  AppLauncher.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 22/08/2023.
//

import SwiftUI

@main
struct AppLauncher {
    static func main() throws {
        if NSClassFromString("XCTestCase") == nil {
            TransferGOApp.main()
        } else {
            TestApp.main()
        }
    }
}
