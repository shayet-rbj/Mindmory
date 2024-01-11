//
//  MainTabView.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 12/3/23.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .padding(.bottom, 10)
                .tabItem {
                    Label("My Journal", systemImage: "note")
                }
            
            CommunityView()
                .padding(.bottom, 10)
                .tabItem {
                    Label("Community", systemImage: "rectangle.3.group.bubble")
                }
            
            SchedulerView()
                .padding(.bottom, 10)
                .tabItem {
                    Label("Scheduler", systemImage: "calendar")
                }
            
            ProfileView()
                .padding(.bottom, 10)
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}
