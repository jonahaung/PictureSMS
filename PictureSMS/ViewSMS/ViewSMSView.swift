//
//  ToImageView.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 3/4/21.
//

import SwiftUI

struct ViewSMSView: View {
    class SheetCoordinator: ObservableObject {
        @Published var showImageFilterMenu = false
        @Published var showActivityView = false
        @Published var showSaveFilteredImage = false
    }
    @StateObject private var sheetCoordinator = SheetCoordinator()
    @State private var image: UIImage?
    @State private var text: String?
    
    var body: some View {
        VStack {
            if let image = self.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .pinchToZoom()
            }
            
            Spacer()
            bottomBar()
        }
        .navigationTitle("View Message")
        .onAppear{
            if let text = UIPasteboard.general.string {
                image = convertBase64ToImage(imageString: text)
            }
        }
    }
    private func bottomBar() -> some View {
        return HStack {
            Button {
                sheetCoordinator.showActivityView = true
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
            .sheet(isPresented: $sheetCoordinator.showActivityView) {
                let items = [image]
                ActivityView(activityItems: items as [Any])
            }
            
            Spacer()
            NavigationLink(destination: CreateSMSView(image: image)) {
                Text("Forward")
            }
            
        }.padding()
    }
    private func convertBase64ToImage(imageString: String) -> UIImage? {
        if let imageData = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
            return UIImage(data: imageData)
        }
        return nil
    }
}
