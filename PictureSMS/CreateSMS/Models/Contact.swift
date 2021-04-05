//
//  Contact.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 5/4/21.
//

import Foundation
struct Contact: Hashable, Identifiable {
    var id: String { return number }
    var name: String
    var number: String
}
