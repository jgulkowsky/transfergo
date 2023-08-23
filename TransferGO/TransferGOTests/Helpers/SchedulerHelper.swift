//
//  SchedulerHelper.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 23/08/2023.
//

import Foundation

// todo: seems to do the same as normal scheduler and MockScheduler but it's to help in tests not to mock in them - so later if we need any changes to this one all the others won't be touched

class SchedulerHelper: Scheduling {
    var interval: Double
    
    private var onEvent: (() -> Void)!
    private var timer: Timer? = nil
    
    init(interval: Double) {
        self.interval = interval
    }
    
    func start(onEvent: @escaping () -> Void) {
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
