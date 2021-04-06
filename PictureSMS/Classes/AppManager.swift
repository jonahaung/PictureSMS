//
//  AppManager.swift
//  PhotoSMS
//
//  Created by Aung Ko Min on 6/4/21.
//

import UIKit

class AppManager: ObservableObject {
    
    @Published var recentImage: UIImage?
    
    func update() {
        if let text = UIPasteboard.general.string {
            recentImage = UIPasteboard.general.string?.image
            if Message.existing(text: text) == nil && recentImage != nil {
                Message.create(text: text, contacts: "Received", isSender: false)
            }
            SoundManager.vibrate(vibration: .rigid)
        }
        
        
    }
}
