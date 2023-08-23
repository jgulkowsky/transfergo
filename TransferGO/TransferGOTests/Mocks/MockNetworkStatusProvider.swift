//
//  MockNetworkStatusProvider.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation

class MockNetworkStatusProvider: NetworkStatusProviding {
    var hasStarted: Bool = false
    var hasFinished: Bool = false
    var hasUpdatedStatusAtLeastOnce: Bool = false
    var valueToReturn: Bool? = nil
    
    private var onStatusUpdated: ((Bool) -> Void)!
    private var timer: Timer? = nil
    
    func start(onStatusUpdated: @escaping (Bool) -> Void) {
        if timer != nil { return }
        hasStarted = true
        hasUpdatedStatusAtLeastOnce = false
        
        self.onStatusUpdated = onStatusUpdated
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            let isConnected = self?.valueToReturn ?? Bool.random()
            self?.hasUpdatedStatusAtLeastOnce = true
            self?.onStatusUpdated(isConnected)
        }
        timer?.fire()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        hasFinished = true
    }
}
