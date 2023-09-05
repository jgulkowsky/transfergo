//
//  SchedulerHelper.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 23/08/2023.
//

import Foundation

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
