//
//  InputView.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 12/2/23.
//

import SwiftUI

// // A reusable input view component for sign in and sign up.
struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        HStack (spacing: 12){
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size:14))
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size:14))
            }
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "sample", placeholder: "sample")
}
