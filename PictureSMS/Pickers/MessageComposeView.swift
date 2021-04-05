//
//  MessageComposeView.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 3/4/21.
//

import SwiftUI
import MessageUI

struct MessageComposeView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    let text: String
    let contacts: [Contact]
    var onComplete: (MessageComposeResult) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MessageComposeView>) -> MFMessageComposeViewController {
        let x = MFMessageComposeViewController()
        x.recipients = contacts.map{$0.number}
        x.messageComposeDelegate = context.coordinator
        x.subject = "PhotoSMS Message"
        x.body = text
        return x
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: UIViewControllerRepresentableContext<MessageComposeView>) {
        
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate {
        
        let parent: MessageComposeView

        init(_ parent: MessageComposeView) {
            self.parent = parent
        }
        
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            parent.onComplete(result)
            switch result {
            case .sent:
                guard let numbers = controller.recipients?.joined(separator: ", ") else { return }
                Message.create(text: parent.text, contacts: numbers, isSender: true)
                parent.presentationMode.wrappedValue.dismiss()
            case .cancelled:
                parent.presentationMode.wrappedValue.dismiss()
            case .failed:
                parent.presentationMode.wrappedValue.dismiss()
            @unknown default:
                print("unknown message sending result")
            }
        }
    }
}
