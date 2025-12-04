//
//  HomeView.swift
//  TabNews
//
//  Created by Rychillie Umpierre de Oliveira on 02/12/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var showingLogoutAlert = false
    @State private var showingLoginSheet = false
    
    var body: some View {
        NavigationView {
            Group {
                if homeViewModel.isLoading && homeViewModel.contents.isEmpty && !homeViewModel.isRefreshing {
                    loadingView()
                } else if let error = homeViewModel.errorMessage {
                    errorView(with: error)
                } else {
                    List {
                        ForEach(Array(homeViewModel.contents.enumerated()), id: \.element.id) { index, content in
                            contentRow(index: index + 1, content: content)
                                .listRowSeparator(.hidden)
                                .onAppear {
                                    Task { await homeViewModel.loadNextPageIfNeeded(currentItem: content) }
                                }
                        }
                        
                        if homeViewModel.isLoadingNextPage {
                            loadingNextPageView()
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await homeViewModel.loadContents(reset: true)
                    }
                }
            }
            .navigationTitle("TabNews")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if authViewModel.isAuthenticated {
                        Button(role: .destructive) {
                            showingLogoutAlert = true
                        } label: {
                            Image(systemName: "arrow.right.square")
                        }
                    } else {
                        Button {
                            showingLoginSheet = true
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "person.circle")
                                Text("Entrar")
                            }
                        }
                    }
                }
            }
            .alert("Sair da conta", isPresented: $showingLogoutAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Sair", role: .destructive) {
                    authViewModel.logout()
                }
            } message: {
                Text("Deseja realmente sair da sua conta?")
            }
            .sheet(isPresented: $showingLoginSheet) {
                LoginView(authViewModel: authViewModel, isPresented: $showingLoginSheet)
            }
            .task {
                await homeViewModel.loadContents(reset: true)
            }
        }
    }
}

private extension HomeView {
    func loadingNextPageView() -> some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
        .listRowSeparator(.hidden)
    }
    
    func loadingView() -> some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("Carregando conteúdos...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    func errorView(with errorMessage: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
                .font(.largeTitle)
            Text(errorMessage)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            
            Button("Tentar novamente") {
                Task { await homeViewModel.loadContents() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    func contentRow(index: Int, content: ContentResponse) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(index).")
                .font(.headline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(content.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(rowSubtitle(for: content))
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
    
    func rowSubtitle(for content: ContentResponse) -> String {
        let tabcoinsText = "\(content.tabcoins) tabcoin" + (content.tabcoins == 1 ? "" : "s")
        let commentsText = "\(content.childrenDeepCount) comentário" + (content.childrenDeepCount == 1 ? "" : "s")
        let relativeTime = homeViewModel.relativePublishedAt(for: content)
        
        if relativeTime.isEmpty {
            return "\(tabcoinsText) • \(commentsText) • \(content.ownerUsername)"
        }
        
        return "\(tabcoinsText) • \(commentsText) • \(content.ownerUsername) • \(relativeTime)"
    }
}

#Preview {
    HomeView(authViewModel: AuthViewModel())
}
