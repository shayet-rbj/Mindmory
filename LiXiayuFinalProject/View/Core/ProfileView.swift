//
//  ProfileView.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 12/3/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userViewModel : AuthViewModel
    
    var body: some View {
        // Check if there is a current user, and if so, display their profile information
        if let users = userViewModel.currentUser{
            List{
                // User's initials and basic info are displayed in this section
                Section{
                    HStack{
                        Text(users.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        VStack (alignment: .leading, spacing: 4){
                            Text(users.fullname)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            Text(users.email)
                                .font(.footnote)
                                .accentColor(.gray)
                        }
                    }
                }
                
                // Section for account-related actions
                Section("Account"){
                    // Button to sign out the current user
                    Button{
                        userViewModel.signOut()
                        
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill",
                                        title: "Sign Out",
                                        tintColor: .red)
                    }
                    
                    // / Button to delete the user's account
                    Button{
                        Task{
                            await userViewModel.deleteAccount()
                        }
                    } label: {
                        SettingsRowView(imageName: "xmark.circle.fill",
                                        title: "Delete Account",
                                        tintColor: .red)
                    }
                }
            }
        }
        else{
            Text("")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
