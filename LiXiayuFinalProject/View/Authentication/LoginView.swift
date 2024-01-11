//
//  LoginView.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 12/2/23.
//  

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    // State variables to hold user input for email and password
    @State private var email: String = ""
    @State private var password: String = ""
    
    // State variables for error message handling and displaying an alert
    @State private var errorMessage: String = ""
    @State private var showingAlert = false
    
    // Environment object for accessing the authentication view model
    @EnvironmentObject var userViewModel: AuthViewModel
    var body: some View {
        NavigationStack{
            VStack{
                // image
                Image("Login")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minHeight: 300, maxHeight: 400)
                
                // title
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)

                
               // form field
                VStack(spacing: 24){
                    InputView(text: $email,
                              title: "Email",
                              placeholder: "name@example.com")
                    .autocapitalization(.none)
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your password",
                              isSecureField: true)
                }
                
                // sign in button
                Button{
                    Task{
                        do {
                            try await userViewModel.signIn(withEmail: email, password: password)
                        } catch {
                            self.errorMessage = "Wrong email or password"
                            self.showingAlert = true // Trigger the alert
                        }
                    }
                }label: {
                    HStack (spacing: 3){
                        Text("SIGN IN")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                // sign up button
                NavigationLink{
                    SignUpView()
                        .navigationBarBackButtonHidden(true)
                }label: {
                    HStack{
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                    
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .padding()
        }
    }
}

// Extension to validate the form inputs
extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
