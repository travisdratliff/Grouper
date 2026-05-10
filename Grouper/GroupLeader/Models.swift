//
//  Models.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/4/26.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Organization {
    var title = ""
    var collectIds = false
    var subGroups = [String]()
    var firestoreId = ""
    var joinCode = ""
    var coachId = ""
    @Relationship(deleteRule: .cascade) var members = [Member]()
    init() { }
}

@Model
class Member {
    var firstName = ""
    var lastName = ""
    var phoneNumber = ""
    var email = ""
    var studentId = ""
    var fullName: String {
        lastName + firstName
    }
    var formattedFullName: String {
        "\(lastName), \(firstName)"
    }
    var isPicked = false
    @Relationship(deleteRule: .cascade) var guardians = [Guardian]()
    var subGroups = [String]()
    init() { }
}

@Model
class Guardian {
    var title = ""
    var firstName = ""
    var lastName = ""
    var phoneNumber = ""
    var email = ""
    init() { }
}

@Model
class Message {
    var title = ""
    var content = ""
    init() { }
}



