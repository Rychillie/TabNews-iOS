//
//  HomeView.swift
//  TabNews
//
//  Created by Rychillie Umpierre de Oliveira on 02/12/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Spacer()
                    
                    // Ícone de sucesso
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                        
                        Text("Login realizado com sucesso!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Bem-vindo ao TabNews")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Botão de Logout
                    Button(action: {
                        showingLogoutAlert = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.square.fill")
                            Text("Sair")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("TabNews")
            .alert("Sair da conta", isPresented: $showingLogoutAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Sair", role: .destructive) {
                    viewModel.logout()
                }
            } message: {
                Text("Deseja realmente sair da sua conta?")
            }
        }
    }
}

#Preview {
    HomeView(viewModel: AuthViewModel())
}
