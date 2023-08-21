//
//  Double+to2DecPlaces.swift
//  TransferGO
//
//  Created by Jan Gulkowski on 17/08/2023.
//

import Foundation

extension Double {
    func limitDecimalPlaces(to limit: Int) -> String {
        return String(format: "%.\(limit)f", self)
    }
}
