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
        self.onStatusUpdated = onStatusUpdated
        nwMonitor = NWPathMonitor()
        nwMonitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let isConnected = path.status == .satisfied
                self?.onStatusUpdated(isConnected)
            }
        }
        nwMonitor?.start(queue: workerQueue)
    }
    
    func stop() {
        nwMonitor?.cancel()
        nwMonitor = nil
    }
}
