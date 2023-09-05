//
//  MockScheduler.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 23/08/2023.
//

import Foundation

class MockScheduler: Scheduling {
    var hasStarted: Bool = false
    var hasStopped: Bool = false
    var numberOfTimesEventWasFired: Int = 0
    
    var interval: Double
    
    private var onEvent: (() -> Void)!
    private var timer: Timer? = nil
    
    init(interval: Double) {
        self.interval = interval
    }
    
    func start(onEvent: @escaping () -> Void) {
        hasStarted = true
        self.onEvent = onEvent
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.numberOfTimesEventWasFired += 1
            self?.onEvent()
        }
        timer?.fire()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        hasStopped = true
    }
}
