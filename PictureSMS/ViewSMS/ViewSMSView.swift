//
//  ToImageView.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 3/4/21.
//

import SwiftUI

struct ViewSMSView: View {
    class SheetCoordinator: ObservableObject {
        @Published var showActivityView = false
    }
    @StateObject private var sheetCoordinator = SheetCoordinator()
    @State private var text: String?
    @State private var viewingImage: UIImage?
    @EnvironmentObject var appManager: AppManager
    var body: some View {
        VStack {
            if let image = appManager.recentImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        viewingImage = image
                    }
                    .shadow(radius: 5)
            } else {
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    Text("Instructions").underline()
                    Text("1. Go to phone's Message application")
                    Text("2. Reveal the contex menu of the message by long-pressing the message bubble")
                    Text("3. Click 'Copy' and copy the entire message body")
                    Text("4. Come back to PhotoSMS app")
                    Text("5. Go to 'View Message'")
                }
                .foregroundColor(Color(.tertiaryLabel))
                .padding()
                
            }
            
            Spacer()
            bottomBar()
        }
        .navigationTitle("View Message")
        .onAppear{
            if let text = UIPasteboard.general.string {
                
                if let _ = Message.existing(text: text) {
                    
                } else if appManager.recentImage != nil {
                    Message.create(text: text, contacts: "Received", isSender: false)
                }
            }
        }
        .sheet(item: $viewingImage) { image in
            ImageViewerView(image: image)
        }
    }
    
    private func bottomBar() -> some View {
        return HStack {
            Button {
                UIPasteboard.general.string = String()
                appManager.recentImage = nil
            } label: {
                Text("Clear")
            }.disabled(appManager.recentImage == nil)

            Spacer()
            if let image = appManager.recentImage {
                NavigationLink(destination: CreateSMSView(image: image)) {
                    Text("Forward")
                }
            }
            
            
        }.padding()
    }
}
