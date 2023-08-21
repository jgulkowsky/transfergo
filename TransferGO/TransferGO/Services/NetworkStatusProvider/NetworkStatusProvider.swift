//
//  NetworkStatusProvider.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation
import Network

// todo: I can see that this NetworkStatusProvider works best when we just starts it and then stops it - so maybe we should just get status once with someGetStatus funcion (which would do exactly the same as now start func does + additionally it will call stop when status is obtained). And we will ask for the status everytime we go inactive to active state / we will just stop when going into inactive state / also each time we send request for the rate we should call it - so on user taps change amount and with some timer

// todo: I'm not sure if this works 100% correctly - as currently I can only check with simulator - will need to connect real device and check with this - hopefully all the problems that are here are just related to the fact we use simulator
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
