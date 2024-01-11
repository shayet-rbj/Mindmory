//
//  User.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 12/2/23.
//  reference: https://www.youtube.com/watch?v=QJHmhLGv-_0

import Foundation

// Represents a user in the application.
struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    
    var initials: String{
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}
