//
//  ContactsPickerView.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 3/4/21.
//

import SwiftUI
import ContactsUI

struct ContactPickerView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    
    var onPickContact: (Contact) -> Void
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let navController = UINavigationController()
        let controller = CNContactPickerViewController()
        controller.delegate = context.coordinator
        navController.present(controller, animated: true, completion: nil)
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        print("Updating the contacts controller!")
    }
    
    // MARK: ViewController Representable delegate methods
    func makeCoordinator() -> ContactsCoordinator {
        return ContactsCoordinator(self)
    }
    
    class ContactsCoordinator : NSObject, UINavigationControllerDelegate, CNContactPickerDelegate {
        let parent: ContactPickerView
        public init(_ parent: ContactPickerView) {
            self.parent = parent
        }
        
        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            if let number = (contact.phoneNumbers[0].value ).value(forKey: "digits") as? String,
               let name = CNContactFormatter.string(from: contact, style: .fullName){
                let contact = Contact(name: name, number: number)
                parent.onPickContact(contact)
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
