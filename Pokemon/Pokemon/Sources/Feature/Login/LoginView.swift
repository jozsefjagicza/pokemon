//
//  LoginView.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 12..
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            Text("Bejelentkezés")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(.horizontal)
            
            if let errorMessage = viewModel.errorEmailMessage {
                HStack {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                    Spacer()
                }
            }
            
            SecureField("Jelszó", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.top, 20)
            
            if let errorMessage = viewModel.errorPasswordMessage {
                HStack {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                    Spacer()
                }
            }
            if viewModel.isLoading {
                ProgressView()
            }
            Button("Bejelentkezés") {
                viewModel.login()
                hideKeyboard()
            }
            .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top, 20)
            .disabled(viewModel.isLoading)
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $viewModel.errorAlert) {
            Alert(title: Text("Hiba"), message: Text(viewModel.errorAlertMessage ?? "Ismeretlen hiba történt"), dismissButton: .default(Text("OK")))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


