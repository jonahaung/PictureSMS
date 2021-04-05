//
//  HistoryManager.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 5/4/21.
//

import Foundation

class InboxManager: ObservableObject {
    
    @Published var currentMode = 0 {
        willSet {
            if newValue == 0 {
                displayMessages = messages.filter{ !$0.isSender }.map{ MessageItem(message: $0)}
            } else {
                displayMessages = messages.filter{ $0.isSender }.map{ MessageItem(message: $0)}
            }
            SoundManager.vibrate(vibration: .soft)
        }
    }
    
    @Published var isEditing = false {
        willSet {
            if !newValue {
                displayMessages.forEach{$0.isSelected = false}
            }
            SoundManager.vibrate(vibration: .soft)
        }
    }
    
    private var messages = [Message]()
    @Published var displayMessages = [MessageItem]()
    
    init() {
        messages = Message.fetch()
        displayMessages = messages.filter{ !$0.isSender }.map{ MessageItem(message: $0)}
    }
}

let relativeDateFormat: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateStyle = .medium
    formatter.timeStyle = .medium
//       formatter.doesRelativeDateFormatting = true
       return formatter
}()
