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
    
    func start(onStatusUpdated: @escaping (Bool) -> Void) {
        if timer != nil { return }
        
        self.onStatusUpdated = onStatusUpdated
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            let isConnected = Bool.random()
            self?.onStatusUpdated(isConnected)
        }
        timer?.fire()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
