//
//  Contact.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 5/4/21.
//

import Foundation
public struct Contact: Identifiable, Hashable {
    
    public var id: String { return number }
    public var name: String
    public var number: String
    public init(name: String, number: String) {
        self.name = name
        self.number = number
    }
}
