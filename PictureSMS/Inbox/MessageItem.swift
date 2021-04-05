//
//  MessageItem.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 5/4/21.
//

import Foundation
class MessageItem: ObservableObject, Identifiable, Equatable {
    
    var id: Message { return message }
    let message: Message

    @Published var isSelected = false
   
    init(message: Message) {
        self.message = message
    }
    

    static func == (lhs: MessageItem, rhs: MessageItem) -> Bool {
        return lhs.id == rhs.id
    }
}
