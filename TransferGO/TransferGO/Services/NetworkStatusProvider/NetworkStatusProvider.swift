//
//  NetworkStatusProvider.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation
import Network

// todo: I'm not sure if this works 100% correctly - as currently I can only check with simulator - will need to connect real device and check with this - hopefully all the problems that are here are just related to the fact we use simulator
class NetworkStatusProvider: NetworkStatusProviding {
    private var onStatusUpdated: ((Bool) -> Void)!
    private var nwMonitor: NWPathMonitor?
    
    private let workerQueue = DispatchQueue.global()
    
    func getStatus(onStatusUpdated: @escaping (Bool) -> Void) {
        print("@jgu: NetworkStatusProvider.start()")
        self.onStatusUpdated = onStatusUpdated
        nwMonitor = NWPathMonitor()
        nwMonitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let isConnected = path.status == .satisfied
                print("@jgu: NetworkStatusProvider.onStatusUpdated(\(isConnected))")
                self?.onStatusUpdated(isConnected)
                self?.stop()
            }
        }
        nwMonitor?.start(queue: workerQueue)
    }
}

private extension NetworkStatusProvider {
    func stop() {
        print("@jgu: NetworkStatusProviderAlternative.stop()")
        nwMonitor?.cancel()
        nwMonitor = nil
    }
}

