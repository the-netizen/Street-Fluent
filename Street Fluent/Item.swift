//
//  Item.swift
//  Street Fluent
//
//  Created by Naima Khan on 10/02/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
