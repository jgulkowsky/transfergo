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
    
    private var onStatusUpdated: ((Bool) -> Void)!
    private var timer: Timer? = nil
    
    func start(onStatusUpdated: @escaping (Bool) -> Void) {
        if timer != nil { return }
        hasStarted = true
        
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
        hasFinished = true
    }
}
