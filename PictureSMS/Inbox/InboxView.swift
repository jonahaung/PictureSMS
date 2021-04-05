//
//  HistoryView.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 5/4/21.
//

import SwiftUI

struct InboxView: View {
    
    @StateObject private var manager = InboxManager()
    @State private var viewingImage: UIImage?
    @State private var showDeleteAlert = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            Divider()
            Section(header: sectionHeader) {
                Grid(manager.displayMessages) { item in
                    InboxCell(item: item, isEditing: manager.isEditing).onTapGesture {
                        if manager.isEditing {
                            item.isSelected.toggle()
                            SoundManager.vibrate(vibration: .rigid)
                        } else {
                            self.viewingImage = item.message.image
                        }
                    }
                }
            }
            .animation(.spring())
            .gridStyle(StaggeredGridStyle(.vertical, tracks: .count(manager.isEditing ? 3 : 2)))
            Divider()
        }
        .navigationTitle(manager.currentMode == 0 ? "Received" : "Sent")
        .navigationBarItems(trailing: selectButton)
        .sheet(item: $viewingImage) { image in
            ImageViewerView(image: image)
        }
        .alert(isPresented: $showDeleteAlert, content: {
            deleteAlert
        })
    }
    
    private func delete(at offsets: IndexSet) {
        let item = manager.displayMessages[offsets.first ?? 0].message
        Message.delete(message: item)
        manager.displayMessages.remove(atOffsets: offsets)
    }
    private var sectionHeader: some View {
        return Picker(selection: $manager.currentMode, label: Image(systemName: "rectangle.3.offgrid")) {
            Text("Received Items").tag(0)
            Text("Sent Items").tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
    
    private var selectButton: some View {
        return HStack {
            if manager.isEditing {
                Button {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                }
                .accentColor(.red)
            }
            Button {
                manager.isEditing.toggle()
            } label: {
                Text(manager.isEditing ? "Done" : "Select")
            }
        }
        
    }
    
    private var deleteAlert: Alert {
        return Alert(title: Text("Confirm to delete the selected items?"), primaryButton: Alert.Button.default(Text("Confirm"), action: {
            let selected = manager.displayMessages.filter{$0.isSelected}
            guard !selected.isEmpty else { return }
            for item in selected {
                Message.delete(message: item.message)
                if let index = manager.displayMessages.firstIndex(of: item) {
                    manager.displayMessages.remove(at: index)
                }
            }
            manager.isEditing = false
        }), secondaryButton: .cancel())
    }
}
