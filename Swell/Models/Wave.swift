//
//  Wave.swift
//  Swell
//
//  Created by Dhison Padma on 11/30/25.
//

import Foundation
import SwiftData

@Model
final class Wave {
  @Attribute(.unique) var id: UUID
  var content: String
  var createdAt: Date

  init(id: UUID = UUID(), content: String, createdAt: Date = Date()) {
    self.id = id
    self.content = content
    self.createdAt = createdAt
  }
}
