//
//  SettingsRowView.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 12/3/23.
//

import SwiftUI

// A reusable view component for displaying a row in profile
struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    var body: some View {
        HStack(spacing: 12){
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
            
            Text(title)
                .font(.subheadline)
        }
    }
}

#Preview {
    SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
}
