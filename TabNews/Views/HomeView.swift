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
                        // Show FoundationModels availability banner if not available
                        if !homeViewModel.isFoundationModelsAvailable && !homeViewModel.contents.isEmpty {
                            foundationModelsBanner()
                        }
                        
                        ForEach(Array(homeViewModel.contents.enumerated()), id: \.element.id) { index, content in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(alignment: .top, spacing: 8) {
                                    // Vertical stack for number and icon button
                                    VStack(alignment: .center, spacing: 4) {
                                        Text("\(index + 1).")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                            .frame(width: 25, alignment: .trailing)
                                        
                                        // Summary icon button (only if FoundationModels is available)
                                        if homeViewModel.isFoundationModelsAvailable {
                                            summaryIconButton(for: content)
                                        }
                                    }
                                    
                                    // Main content area
                                    VStack(alignment: .leading, spacing: 6) {
                                        // Title and subtitle (clickable for navigation)
                                        NavigationLink(destination: PostDetailView(username: content.ownerUsername, slug: content.slug)) {
                                            VStack(alignment: .leading, spacing: 6) {
                                                Text(content.title)
                                                    .font(.headline)
                                                    .foregroundColor(.primary)
                                                
                                                Text(rowSubtitle(for: content))
                                                    .font(.footnote)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        .buttonStyle(.plain)
                                        
                                        // Summary display area (loading, summary, or error)
                                        if homeViewModel.isFoundationModelsAvailable {
                                            summaryDisplay(for: content)
                                        }
                                    }
                                }
                                .padding(.vertical, 8)
                            }
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
    
    func foundationModelsBanner() -> some View {
        HStack(spacing: 12) {
            Image(systemName: "brain.head")
                .foregroundColor(.orange)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Resumo inteligente indisponível")
                    .font(.caption)
                    .fontWeight(.semibold)
                Text("Seu dispositivo não suporta Apple Intelligence. Os botões de resumo foram removidos.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.orange.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal)
        .padding(.vertical, 4)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
    
    @ViewBuilder
    func summaryIconButton(for content: ContentResponse) -> some View {
        let isSummarizing = homeViewModel.isSummarizing(content.id)
        let hasSummary = homeViewModel.getSummary(for: content.id) != nil
        let hasError = homeViewModel.getSummaryError(for: content.id) != nil
        
        // Only show button if not summarizing, no summary, and no error
        if !isSummarizing && !hasSummary && !hasError {
            Button {
                Task {
                    await homeViewModel.summarizeContent(content)
                }
            } label: {
                Image(systemName: "sparkles")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 18, height: 18)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.pink, Color.purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
            }
            .buttonStyle(.plain)
        }
    }
    
    @ViewBuilder
    func summaryDisplay(for content: ContentResponse) -> some View {
        let summary = homeViewModel.getSummary(for: content.id)
        let isSummarizing = homeViewModel.isSummarizing(content.id)
        let error = homeViewModel.getSummaryError(for: content.id)
        
        // Show this section if any of these conditions are true
        if isSummarizing || summary != nil || error != nil {
            if isSummarizing {
                // Activity indicator while generating
                HStack(spacing: 8) {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(.purple)
                    Text("Gerando resumo...")
                        .font(.caption)
                        .foregroundColor(.purple)
                    Spacer()
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.purple.opacity(0.08))
                )
                .padding(.top, 4)
            } else if let summary = summary {
                // Show the summary content (clickable to remove)
                Button {
                    // Remove the summary
                    homeViewModel.clearSummary(for: content.id)
                } label: {
                    Text(summary.summary)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [Color.pink.opacity(0.12), Color.purple.opacity(0.12)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .overlay(
                    HStack {
                        Spacer()
                        Image(systemName: "xmark")
                            .font(.caption2)
                            .foregroundColor(.purple)
                            .padding(4)
                    }
                    .padding(4)
                )
                .padding(.top, 4)
            } else if let error = error {
                // Show error (clickable to retry)
                Button {
                    // Retry summarization
                    Task {
                        homeViewModel.clearSummary(for: content.id)
                        await homeViewModel.summarizeContent(content)
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.purple)
                            .font(.caption)
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Image(systemName: "arrow.counterclockwise")
                            .font(.caption2)
                            .foregroundColor(.purple)
                    }
                }
                .buttonStyle(.plain)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.purple.opacity(0.08))
                )
                .padding(.top, 4)
            }
        }
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
