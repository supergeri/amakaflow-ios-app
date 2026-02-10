//
//  InstagramReelIngestionView.swift
//  AmakaFlow
//
//  Instagram Reel URL paste sheet for workout ingestion (AMA-564)
//

import SwiftUI

struct InstagramReelIngestionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var url: String = ""
    @State private var state: IngestionState = .idle

    let apiService: APIServiceProviding

    enum IngestionState: Equatable {
        case idle
        case loading
        case success(title: String)
        case error(message: String)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Instagram Reel URL", text: $url)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .textContentType(.URL)
                } header: {
                    Text("Paste an Instagram Reel URL")
                }

                Section {
                    Button(action: ingest) {
                        HStack {
                            if state == .loading {
                                ProgressView()
                                    .padding(.trailing, 8)
                            }
                            Text(buttonLabel)
                        }
                    }
                    .disabled(!canSubmit)
                }

                if case .error(let message) = state {
                    Section {
                        Text(message)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }

                if case .success(let title) = state {
                    Section {
                        Label(title, systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
            }
            .navigationTitle("Import from Instagram")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private var buttonLabel: String {
        switch state {
        case .loading: return "Importing..."
        default: return "Import Workout"
        }
    }

    private var canSubmit: Bool {
        !url.isEmpty && url.contains("instagram.com") && state == .idle
    }

    private func ingest() {
        state = .loading
        Task {
            do {
                let response = try await apiService.ingestInstagramReel(url: url)
                state = .success(title: response.title ?? "Workout imported")
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                dismiss()
            } catch {
                state = .error(message: error.localizedDescription)
            }
        }
    }
}
