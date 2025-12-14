//
//  LoginView.swift
//  TabNews
//
//  Created by Rychillie Umpierre de Oliveira on 02/12/25.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @Binding var isPresented: Bool
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 12) {
                            Image(systemName: "newspaper.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.blue)
                            
                            Text("TabNews")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Entre com sua conta")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                        
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                                
                                TextField("\("tim@apple.com")", text: $authViewModel.email)
                                    .textFieldStyle(.plain)
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(10)
                                    .textContentType(.emailAddress)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .focused($focusedField, equals: .email)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        focusedField = .password
                                    }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Senha")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                                
                                SecureField("Digite sua senha", text: $authViewModel.password)
                                    .textFieldStyle(.plain)
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(10)
                                    .textContentType(.password)
                                    .focused($focusedField, equals: .password)
                                    .submitLabel(.go)
                                    .onSubmit {
                                        Task {
                                            await performLogin()
                                        }
                                    }
                            }
                            
                            if let errorMessage = authViewModel.errorMessage {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                    Text(errorMessage)
                                        .font(.caption)
                                }
                                .foregroundColor(.red)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(10)
                            }
                            
                            Button(action: {
                                focusedField = nil
                                Task {
                                    await performLogin()
                                }
                            }) {
                                HStack {
                                    if authViewModel.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Text("Entrar")
                                            .fontWeight(.semibold)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(authViewModel.isLoading ? Color.blue.opacity(0.6) : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .disabled(authViewModel.isLoading)
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.secondary)
                            .font(.headline.bold())
                    }
                }
            }
        }
    }
    
    private func performLogin() async {
        await authViewModel.login()
        //
        if authViewModel.isAuthenticated {
            isPresented = false
        }
    }
}

#Preview {
    LoginView(authViewModel: AuthViewModel(), isPresented: .constant(true))
}
