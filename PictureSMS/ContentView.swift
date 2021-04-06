//
//  ContentView.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 2/4/21.
//

import SwiftUI

struct ContentView: View {
    
    class SheetCoordinator: ObservableObject {
        @Published var showActivityView = false
    }
    @StateObject private var sheetCoordinator = SheetCoordinator()
    @State private var text: String?
    @State private var viewingImage: UIImage?
    @EnvironmentObject var appManager: AppManager
    
    var body: some View {
        VStack{
            Spacer()
            imageViewerView
            Spacer()
            bottomBar
        }.padding()
        .navigationTitle(appManager.recentImage == nil ? "Photo SMS" : "Recent Image")
        .navigationBarItems(trailing: settingsButton)
        .sheet(item: $viewingImage) { image in
            ImageViewerView(image: image)
        }
    }
    
    private var bottomBar: some View {
        return HStack {
            NavigationLink(destination: InboxView()) {
                Text("Gallery")
                    .underline()
            }.padding()
            Spacer()
            NavigationLink(destination: CreateSMSView()) {
                Image(systemName: "plus")
                    .font(.title)
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
        }
    }
    
    private var imageViewerView: some View {
        return VStack {
            if let image = appManager.recentImage {
                ZStack(alignment: .bottomTrailing) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .onTapGesture {
                            viewingImage = image
                        }
                    imageViewerBar
                }
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Instructions").font(.title)
                    Text("To decode a message").underline()
                    Label("Go to phone's Message application", systemImage: "1.circle.fill")
                    Label("Reveal the context menu of the message by long-pressing the message bubble", systemImage: "2.circle.fill")
                    Label("Click 'Copy' and copy the entire message body", systemImage: "3.circle.fill")
                    Label("Proceed back to the PhotoSMS app", systemImage: "4.circle.fill")
                    Text("To create a new message").underline().padding(.top)
                    Label("Click the + button at the lower-right", systemImage: "circle.fill")
                }
                .foregroundColor(Color(.tertiaryLabel))
                .padding()
                
            }
        }
    }
    private var imageViewerBar: some View {
        return Group {
            
            if let image = appManager.recentImage {
                NavigationLink(destination: CreateSMSView(image: image)) {
                    Image(systemName: "arrowshape.turn.up.right.fill")
                        .padding()
                        .background(Color(.separator))
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding()
                }
            }
        }.accentColor(.white)
    }
    
    private var settingsButton: some View {
        return NavigationLink(destination: SettingsView()) {
            Image(systemName: "scribble").padding()
        }
    }
}
