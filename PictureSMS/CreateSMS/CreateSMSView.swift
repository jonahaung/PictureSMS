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
    
    @State private var imageString: String?
    @State var image: UIImage?
    @State private var sheetType: SheetType?
    @State private var contacts = [Contact]()
    @State private var message = "Please Select An Image"
    
   
    var body: some View {
        VStack {
           
            List {
                Section(header: HelpText, footer: EmptyView()) {

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
                        }.buttonStyle(PlainButtonStyle())
                        
                        ForEach(contacts, id: \.self) { contact in
                            HStack {
                                Text(contact.name)
                                    
                                Spacer()
                                Text(contact.number)
                                    .foregroundColor(.secondary)
                                    .font(.callout)
                            }.padding(.horizontal)

                        }
                        .onDelete(perform: delete)
                        AddContactsButton
                    } else {
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
            SMSButton
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
                    self.imageString = convertImageToBase64(image: image)
                    self.message = "Please add the recipients"
                }
            case .documentPicker:
                DocPickerView { image in
                    self.image = image
                    self.imageString = convertImageToBase64(image: image)
                    self.message = "Please add the recipients"
                }
            case .camera:
                CameraView { image in
                    self.image = image
                    self.imageString = convertImageToBase64(image: image)
                    self.message = "Please add the recipients"
                }.edgesIgnoringSafeArea(.all)
        
            case .contactPicker:
                ContactPickerView { contact in
                    if !contacts.contains(contact) {
                        contacts.append(contact)
                    }
                }
            case .messageCompose:
                if let text = self.imageString {
                    if MFMessageComposeViewController.canSendText() {
                        MessageComposeView(text: text, contacts: contacts) { result in
                            
                            switch result {
                            case .sent:
                                message = "Message sent"
                               
                            case .cancelled:
                                message = "Message cancelled"
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
    }
    
    private func clear() {
        image = nil
        imageString = nil
        contacts.removeAll()
    }
    
    private func delete(at offsets: IndexSet) {
        contacts.remove(atOffsets: offsets)
    }
    
    private var AddContactsButton: some View {
        return Button {
            sheetType = .contactPicker
        } label: {
            Label("Add Recipients", systemImage: "plus.circle.fill")
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
    
    private var HelpText: some View {
        return Text(message).font(.callout)
            .padding()
            .foregroundColor(.secondary)
    }
    
    private var ClearButton: some View {
        return Button {
            clear()
        } label: {
            Text("New SMS")
        }.disabled(image == nil || contacts.isEmpty)
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
        return Alert(title: Text(message), primaryButton: .default(Text("Create Another Picture SMS"), action: {
            clear()
        }), secondaryButton: .default(Text("Done")))
    }
}

extension CreateSMSView {
    private func convertImageToBase64(image: UIImage) -> String?                                       {
        return image.jpegData(compressionQuality: 0.5)?.base64EncodedString(options: .lineLength64Characters)
    }
}
