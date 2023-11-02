//
//  ContentView.swift
//  PostIT
//
//  Created by Austin  Tangban on 14/10/2023.
//

import SwiftUI

struct MainView: View {
    @StateObject var loginViewModel = LoginViewModel()
    var body: some View {
        if loginViewModel.isCurrentlyLoggedOut {
            LoginView(loginViewModel: loginViewModel)
        } else {
            TabView {
                PostsView()
                    .tabItem {
                        Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                        Text("Posts")
                    }
                ProfileView(loginViewModel: loginViewModel)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Profile")
                    }
            }
        }
    }
}

#Preview {
    MainView()
}
