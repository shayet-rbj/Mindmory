//
//  SignUp.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 11/27/23.
//  

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// Allows users to sign up with email, full name, password, and confirm password
struct SignUpView: View {
    // State variables for user input.
    @State private var email: String = ""
    @State private var fullname: String = ""
    @State private var password: String = ""
    @State private var confirmedPassword: String = ""
    
    // State variables for error handling and alert display
    @State private var errorMessage: String = ""
    @State private var showingAlert = false
    
    // Environment value for dismissing the view
    @Environment(\.dismiss) var dismiss
    
    // Environment object for user authentication
    @EnvironmentObject var userViewModel: AuthViewModel

    var body: some View {
        VStack{
            // image
            Image("SignUp")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 300, maxHeight: 400)
            
            // title
            Text("Sign Up")
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
                
                InputView(text: $fullname,
                          title: "Full Name",
                          placeholder: "Enter your name")
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
                InputView(text: $confirmedPassword,
                          title: "Confirmed Password",
                          placeholder: "Enter your confirmed password",
                          isSecureField: true)
            }
            
            // sign up button
            Button{
                Task{
                    do{
                        try await userViewModel.createUser(withEmail: email, password: password, fullname: fullname)
                    } catch {
                        // This will capture any error thrown during sign up and display it
                        self.errorMessage = error.localizedDescription
                        self.showingAlert = true
                    }
                }
                
            }label: {
                HStack{
                    Text("SIGN UP")
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
            
            // sign in section
            Button {
                dismiss()
            }label: {
                HStack (spacing: 3){
                    Text("Already have an account?")
                    Text("Sign In")
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

// Extension to validate the form inputs
extension SignUpView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && !fullname.isEmpty
        && confirmedPassword == password
    }
}


#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
}
