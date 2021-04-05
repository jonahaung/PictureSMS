//
//  ToSMSView.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 3/4/21.
//

import SwiftUI
import MessageUI

struct CreateSMSView: View {
    
    private enum SheetType: Identifiable {
        var id: SheetType { return self }
        case imagePicker, documentPicker, camera, contactPicker, messageCompose
    }
    private class SheetManager: ObservableObject {
        @Published var showImagePickerSheet = false
        @Published var showSMSResult = false
    }
    @StateObject private var sheetManager = SheetManager()
    
    @State var image: UIImage?
    @State private var sheetType: SheetType?
    @State private var contacts = [Contact]()
    @State private var message: String? = "Please add an image"
    
   
    var body: some View {
        VStack {
            List {
                Section {
                    if let image = self.image {
                        
                        ZStack(alignment: .bottom) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .padding(.vertical)
                            HStack {
                                Spacer()
                                Button {
                                    sheetType = .imagePicker
                                } label: {
                                    Image(systemName: "plus")
                                        .padding()
                                        .background(Color(.systemBackground))
                                        .clipShape(Circle())
                                        .padding()
                                        .shadow(radius: 5)
                                }

                            }.padding()
                        }.buttonStyle(BorderlessButtonStyle())
                        
                        ForEach(contacts, id: \.self) { contact in
                            contactCell(contact)
                        }
                        .onDelete(perform: delete)
                        
                        AddContactsButton
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Instructions").underline()
                            Text("1. Choose the image that you want to send")
                            Text("2. Add the message recipients (You can add multiple recipients)")
                            Text("3. Create SMS")
                            Text("4. Send")
                        }
                        .foregroundColor(Color(.tertiaryLabel))
                        .padding()
                        Button {
                            sheetManager.showImagePickerSheet = true
                        } label: {
                            Label("Add Image", systemImage: "plus.circle.fill")
                        }
                        .actionSheet(isPresented: $sheetManager.showImagePickerSheet) {
                            imagePickerActionSheet
                        }
                        
                        
                    }
                    
                }
                
            }
            .listStyle(InsetGroupedListStyle())
            if let message = self.message {
                Text(message)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .italic()
                    .padding(5)
                    .multilineTextAlignment(.center)
            }
            if image != nil && !contacts.isEmpty {
                SMSButton
            }
        }
        .alert(isPresented: $sheetManager.showSMSResult, content: {
            resultAlert
        })
        .navigationBarItems(trailing: ClearButton)
        .navigationTitle("Send Message")
        .fullScreenCover(item: $sheetType) { type in
            switch type {
            case .imagePicker:
                ImagePicker { image in
                    self.image = image
                    self.message = "Add the recipients.\nYou can add multiple phone numbers."
                }
            case .documentPicker:
                DocPickerView { image in
                    self.image = image
                    self.message = "Add the recipients.\nYou can add multiple phone numbers."
                }
            case .camera:
                CameraView { image in
                    self.image = image
                    self.message = "Add the recipients.\nYou can add multiple phone numbers."
                }.edgesIgnoringSafeArea(.all)
        
            case .contactPicker:
                ContactPickerView { contact in
                    if !contacts.contains(contact) {
                        contacts.append(contact)
                        self.message = nil
                    }
                }
            case .messageCompose:
                if MFMessageComposeViewController.canSendText(), let text = image?.imageString {
                    MessageComposeView(text: text, contacts: contacts) { result in
                        
                        switch result {
                        case .sent:
                            message = "Message sent\nPress 'Reset' button to create another message"
                            SoundManager.vibrate(vibration: .soft)
                        case .cancelled:
                            message = "Message was not sent"
                        case .failed:
                            message = "Failed to send the message"
                        @unknown default:
                            print("unknown message sending result")
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
    private func contactCell(_ contact: Contact) -> some View {
        return HStack {
            Text(contact.name)
            Spacer()
            Text(contact.number)
                .foregroundColor(.secondary)
                .font(.callout)
        }
        .padding(.horizontal)
    }
    private func clear() {
        image = nil
        contacts.removeAll()
        message = "Please add an image"
    }
    
    private func delete(at offsets: IndexSet) {
        contacts.remove(atOffsets: offsets)
    }
    
    private var AddContactsButton: some View {
        return Button {
            sheetType = .contactPicker
        } label: {
            Label("Add Message Recipients", systemImage: "plus.circle.fill")
        }
    }
    
    private var SMSButton: some View {
        return Button {
            sheetType = .messageCompose
        } label: {
            Text("Create SMS")
                .font(.headline)
                .frame(width: 200, height: 40)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(10)
        }.disabled(image == nil || contacts.isEmpty)
    }
    
    private var ClearButton: some View {
        return HStack {
            Button {
                clear()
            } label: {
                Text("Reset")
            }.disabled(image == nil)
            EditButton().disabled(contacts.isEmpty)
        }
    }
    
    private var imagePickerActionSheet: ActionSheet {
        return ActionSheet(title: Text("Select Image Source"), message: nil, buttons: [
            .default(Text("Photo Library")) {
                sheetType = .imagePicker
            },
            .default(Text("File Documents")) {
                sheetType = .documentPicker
            },
            .default(Text("Take Picture")) {
                sheetType = .camera
            },
            .cancel()
        ])
    }
    
    private var resultAlert: Alert {
        return Alert(title: Text(message ?? ""), primaryButton: .default(Text("Create Another Picture SMS"), action: {
            clear()
        }), secondaryButton: .default(Text("Done")))
    }
}
