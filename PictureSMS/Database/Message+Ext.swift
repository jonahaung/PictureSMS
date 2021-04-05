//
//  Message+Ext.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 5/4/21.
//

import CoreData
import UIKit

extension Message {
    
    var image: UIImage? {
        return text?.image
    }
    
    static func create(text: String, contacts: String, isSender: Bool) {
        let context = PersistenceController.shared.container.viewContext
        let message = Message(context: context)
        message.text = text
        message.date = Date()
        message.contacts = contacts
        message.isSender = isSender
        do {
            try context.save()
        } catch { print(error) }
    }
    
    static func delete(message: Message) {
    
        let context = PersistenceController.shared.container.viewContext
        context.delete(message)
        do {
            try context.save()
        } catch { print(error) }
    }
    
    static func fetch() -> [Message]{
        let request: NSFetchRequest<Message> = Message.fetchRequest()
      
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let context = PersistenceController.shared.container.viewContext
        do {
            return try context.fetch(request)
        } catch {
            print(error)
            return []
        }
    }
    static func existing(text: String) -> Message? {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "text == %@", text)
        let context = PersistenceController.shared.container.viewContext
        do {
            return try context.fetch(request).first
        } catch {
            print(error)
            return nil
        }
    }
}
