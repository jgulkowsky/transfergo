//
//  NetworkStatusProviding.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 21/08/2023.
//

import Foundation

protocol NetworkStatusProviding {
    func start(onStatusUpdated: @escaping (Bool) -> Void)
    func stop()
}
