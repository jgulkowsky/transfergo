//
//  Double+to2DecPlaces.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 17/08/2023.
//

import Foundation

extension Double {
    func to2DecPlaces() -> String {
        return String(format: "%.2f", self)
    }
}
