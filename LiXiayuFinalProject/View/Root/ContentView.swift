//
//  ContentView.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 11/27/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userViewModel: AuthViewModel
    var body: some View {
        Group{
            if userViewModel.isUserAuthenticated {
                // If the user is authenticated (logged in)
                MainTabView()
            } else{
                // If the user is not authenticated (not logged in)
                LoginView()
            }
        }
        
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
