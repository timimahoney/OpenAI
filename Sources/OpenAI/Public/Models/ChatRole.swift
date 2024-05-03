//
//  ChatRoll.swift
//
//
//  Created by Tim Mahoney on 5/2/24.
//

import Foundation

public enum Role: String, Codable, Equatable, CaseIterable {
    case system
    case user
    case assistant
    case tool
}
