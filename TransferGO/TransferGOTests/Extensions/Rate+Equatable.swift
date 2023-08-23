//
//  Rate+Equatable.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 22/08/2023.
//

import Foundation

extension Rate: Equatable {
    static func == (lhs: Rate, rhs: Rate) -> Bool {
        return lhs.from == rhs.from
            && lhs.to == rhs.to
            && lhs.rate == rhs.rate
            && Double.equal(lhs.fromAmount, rhs.fromAmount, precise: 10)
            && Double.equal(lhs.toAmount, rhs.toAmount, precise: 10)
    }
}
