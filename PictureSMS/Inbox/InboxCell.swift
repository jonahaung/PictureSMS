//
//  HistoryCell.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 5/4/21.
//

import SwiftUI

struct InboxCell: View {
    
    @ObservedObject var item: MessageItem
    let isEditing: Bool
    
    var body: some View {
        VStack {
            if let image = item.message.image {
                ZStack(alignment: .bottom) { 
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                        .padding(5)
                        .shadow(radius: 5)
                    if isEditing {
                        if item.isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentColor)
                                .padding(1)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                    }
                }
                
                
                if let contacts = item.message.contacts {
                    Text(contacts)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                if let date = item.message.date {
                    Text("\(date, formatter: relativeDateFormat)")
                        .italic()
                        .padding(.bottom)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                }
            }
            
        }.frame(minHeight: 150)
    }
}
