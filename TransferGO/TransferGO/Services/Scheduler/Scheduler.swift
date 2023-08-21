//
//  Scheduler.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation

class Scheduler: Scheduling {
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
