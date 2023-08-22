//
//  MockScheduler.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 23/08/2023.
//

import Foundation

// todo: seems to do the same as normal scheduler but if we can have mock then why not - maybe it will be useful

class MockScheduler: Scheduling {
    private var onEvent: (() -> Void)!
    private var timer: Timer? = nil
    
    func start(withInterval interval: Double, onEvent: @escaping () -> Void) {
        self.onEvent = onEvent
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.onEvent()
        }
        timer?.fire()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
