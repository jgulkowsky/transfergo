//
//  Scheduling.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation

protocol Scheduling {
    func start(withInterval interval: Double, onEvent: @escaping () -> Void)
    func stop()
}
