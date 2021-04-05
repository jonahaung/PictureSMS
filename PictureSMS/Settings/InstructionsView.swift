//
//  InstructionsView.swift
//  PhotoSMS
//
//  Created by Aung Ko Min on 6/4/21.
//

import SwiftUI
import AVKit

struct InstructionsView: View {
    var body: some View {
        VideoPlayer(player: AVPlayer(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/photosms-1bc29.appspot.com/o/Instructions.MP4?alt=media&token=48906c0f-6b8b-418d-be95-72b3aa5e90e1")!))
            .edgesIgnoringSafeArea(.all)
    }
}
