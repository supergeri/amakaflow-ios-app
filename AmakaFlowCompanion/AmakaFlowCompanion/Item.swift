//
//  Item.swift
//  AmakaFlowCompanion
//
//  Created by DAVID ANDREWS on 11/21/25.
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
