//
//  Scheduling.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation

protocol Scheduling {
    var interval: Double { get set }
    
    func start(onEvent: @escaping () -> Void)
    func stop()
}
