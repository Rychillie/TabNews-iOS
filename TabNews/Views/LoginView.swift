//
//  LoginView.swift
//  TabNews
//
//  Created by Rychillie Umpierre de Oliveira on 02/12/25.
//

import SwiftUI
import DesignSystem

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
                    VStack(spacing: .space.x12) {
                        VStack(spacing: .space.x6) {
                            Image(systemName: "newspaper.fill")
                                .font(.system(size: .fontSize.xl9))
                                .foregroundColor(.blue)
                            
                            Text("TabNews")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Entre com sua conta")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, .space.x20)
                        .padding(.bottom, .space.x10)

                        VStack(spacing: .space.x8) {
                            VStack(alignment: .leading, spacing: .space.x4) {
                                Text("Email")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                                
                                TextField("tim@apple.com", text: $authViewModel.email)
                                    .textFieldStyle(.plain)
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(.radius.x5)
                                    .textContentType(.emailAddress)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .focused($focusedField, equals: .email)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        focusedField = .password
                                    }
                            }

                            VStack(alignment: .leading, spacing: .space.x4) {
                                Text("Senha")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                                
                                SecureField("Digite sua senha", text: $authViewModel.password)
                                    .textFieldStyle(.plain)
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(.radius.x5)
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
                                .background(Color.red.opacity(.opacity.level1))
                                .cornerRadius(.radius.x5)
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
                                .background(authViewModel.isLoading ? Color.blue.opacity(.opacity.level6) : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(.radius.x5)
                            }
                            .disabled(authViewModel.isLoading)
                        }
                        .padding(.horizontal, .space.x12)
                        
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
