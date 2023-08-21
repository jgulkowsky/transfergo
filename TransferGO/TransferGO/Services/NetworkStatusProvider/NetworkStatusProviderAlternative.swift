//
//  NetworkStatusProviderAlternative.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation
import Network

// todo: if we proceded with this approach we need to rename start into getStatus probably and stop into cancelGettingStatus - so NetworkStatusProviding would change

class NetworkStatusProviderAlternative: NetworkStatusProviding {
    private var onStatusUpdated: ((Bool) -> Void)!
    private var nwMonitor: NWPathMonitor?
    
    private let workerQueue = DispatchQueue.global()
    
    func start(onStatusUpdated: @escaping (Bool) -> Void) {
        print("@jgu: NetworkStatusProviderAlternative.start()")
        self.onStatusUpdated = onStatusUpdated
        nwMonitor = NWPathMonitor()
        nwMonitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let isConnected = path.status == .satisfied
                print("@jgu: NetworkStatusProviderAlternative.onStatusUpdated(\(isConnected))")
                self?.onStatusUpdated(isConnected)
                self?.stop()
            }
        }
        nwMonitor?.start(queue: workerQueue)
    }
    
    func stop() {
        print("@jgu: NetworkStatusProviderAlternative.stop()")
        nwMonitor?.cancel()
        nwMonitor = nil
    }
}

