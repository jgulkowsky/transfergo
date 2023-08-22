//
//  NetworkStatusProvider.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation
import Network

class NetworkStatusProvider: NetworkStatusProviding {
    private var onStatusUpdated: ((Bool) -> Void)!
    private var nwMonitor: NWPathMonitor?
    
    private let workerQueue = DispatchQueue.global()
    
    func start(onStatusUpdated: @escaping (Bool) -> Void) {
        print("@jgu: NetworkStatusProvider.start()")
        self.onStatusUpdated = onStatusUpdated
        nwMonitor = NWPathMonitor()
        nwMonitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let isConnected = path.status == .satisfied
                print("@jgu: NetworkStatusProvider.onStatusUpdated(\(isConnected))")
                self?.onStatusUpdated(isConnected)
            }
        }
        nwMonitor?.start(queue: workerQueue)
    }
    
    func stop() {
        print("@jgu: NetworkStatusProvider.stop()")
        nwMonitor?.cancel()
        nwMonitor = nil
    }
}
