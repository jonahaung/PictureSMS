//
//  ImageViewerView.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 5/4/21.
//

import SwiftUI

struct ImageViewerView: View {
    class SheetCoordinator: ObservableObject {
        @Published var showActivityView = false
    }
    @StateObject private var sheetCoordinator = SheetCoordinator()
    let image: UIImage
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .pinchToZoom()
            VStack {
                Spacer()
                HStack {
                    Button {
                        sheetCoordinator.showActivityView = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .padding()
                            .background(Color(.separator))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .sheet(isPresented: $sheetCoordinator.showActivityView) {
                        let items = [image]
                        ActivityView(activityItems: items as [Any])
                    }
                    Spacer()
                    
                }
                .accentColor(.white)
                
            }.padding()
        }
    }
}
