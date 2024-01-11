//
//  Note.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 11/27/23.
//

import Foundation
import FirebaseFirestore

// Represents a single note in the application.
struct Note: Identifiable, Codable  {
    @DocumentID var id: String?
//    @ServerTimestamp var created: Date?
    var created: Date? = Date()
    let urls: String
    var title: String
    let userId: String
    var content: String
    
}
