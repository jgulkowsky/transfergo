//
//  MockNetworkStatusProvider.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation

// todo: move into test target and folder
class MockNetworkStatusProvider: NetworkStatusProviding {
    private var onStatusUpdated: ((Bool) -> Void)!
    private var timer: Timer? = nil
    
    func getStatus(onStatusUpdated: @escaping (Bool) -> Void) {
        if timer != nil { return }
        
        print("@jgu: MockNetworkStatusProvider.start()")
        self.onStatusUpdated = onStatusUpdated
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            let isConnected = Bool.random()
            print("@jgu: isConnected: \(isConnected)")
            self?.onStatusUpdated(isConnected)
        }
        timer?.fire()
    }
    
    func stop() {
        print("@jgu: MockNetworkStatusProvider.stop()")
        timer?.invalidate()
        timer = nil
    }
}
