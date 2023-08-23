//
//  SchedulerHelper.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 23/08/2023.
//

import Foundation

// todo: seems to do the same as normal scheduler and MockScheduler but it's to help in tests not to mock in them - so later if we need any changes to this one all the others won't be touched

class SchedulerHelper: Scheduling {
    private var onEvent: (() -> Void)!
    private var timer: Timer? = nil
    
    func start(withInterval interval: Double, onEvent: @escaping () -> Void) {
        print("@jgu: scheduler started")
        var eventNumber = 0
        self.onEvent = onEvent
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            eventNumber += 1
            print("@jgu: onEvent(\(eventNumber))")
            self?.onEvent()
        }
        timer?.fire()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        print("@jgu: scheduler stopped")
    }
}
