//
//  Contact.swift
//  CustomScrollIndicator
//
//  Created by Matteo Buompastore on 29/04/25.
//

import SwiftUI

struct Contact: Identifiable {
    
    let id: String = UUID().uuidString
    let name: String
    let email: String
    
}

let dummyContacts: [Contact] = [
    Contact(name: "Alice Johnson", email: "alice.johnson@example.com"),
    Contact(name: "Bob Smith", email: "bob.smith@example.com"),
    Contact(name: "Charlie Davis", email: "charlie.davis@example.com"),
    Contact(name: "Dana Lee", email: "dana.lee@example.com"),
    Contact(name: "Evan Brown", email: "evan.brown@example.com"),
    Contact(name: "Fiona Garcia", email: "fiona.garcia@example.com"),
    Contact(name: "George Harris", email: "george.harris@example.com"),
    Contact(name: "Hannah Clark", email: "hannah.clark@example.com"),
    Contact(name: "Ian Walker", email: "ian.walker@example.com"),
    Contact(name: "Julia Adams", email: "julia.adams@example.com"),
    Contact(name: "Alice Johnson", email: "alice.johnson@example.com"),
    Contact(name: "Bob Smith", email: "bob.smith@example.com"),
    Contact(name: "Charlie Davis", email: "charlie.davis@example.com"),
    Contact(name: "Dana Lee", email: "dana.lee@example.com"),
    Contact(name: "Evan Brown", email: "evan.brown@example.com"),
    Contact(name: "Fiona Garcia", email: "fiona.garcia@example.com"),
    Contact(name: "George Harris", email: "george.harris@example.com"),
    Contact(name: "Hannah Clark", email: "hannah.clark@example.com"),
    Contact(name: "Ian Walker", email: "ian.walker@example.com"),
    Contact(name: "Julia Adams", email: "julia.adams@example.com"),
    Contact(name: "Kevin Scott", email: "kevin.scott@example.com"),
    Contact(name: "Laura Mitchell", email: "laura.mitchell@example.com"),
    Contact(name: "Michael Young", email: "michael.young@example.com"),
    Contact(name: "Natalie King", email: "natalie.king@example.com"),
    Contact(name: "Oliver Wright", email: "oliver.wright@example.com"),
    Contact(name: "Paula Baker", email: "paula.baker@example.com"),
    Contact(name: "Quentin Turner", email: "quentin.turner@example.com"),
    Contact(name: "Rachel Edwards", email: "rachel.edwards@example.com"),
    Contact(name: "Samuel Bennett", email: "samuel.bennett@example.com"),
    Contact(name: "Tina Foster", email: "tina.foster@example.com"),
    Contact(name: "Uma Simmons", email: "uma.simmons@example.com"),
    Contact(name: "Victor Hayes", email: "victor.hayes@example.com"),
    Contact(name: "Wendy Ross", email: "wendy.ross@example.com"),
    Contact(name: "Xander Kelly", email: "xander.kelly@example.com"),
    Contact(name: "Yvonne Price", email: "yvonne.price@example.com"),
    Contact(name: "Zachary Coleman", email: "zachary.coleman@example.com"),
    Contact(name: "Amber Reeves", email: "amber.reeves@example.com"),
    Contact(name: "Brandon Cox", email: "brandon.cox@example.com"),
    Contact(name: "Chloe Morgan", email: "chloe.morgan@example.com"),
    Contact(name: "Derek Perez", email: "derek.perez@example.com"),
    Contact(name: "Ella Richardson", email: "ella.richardson@example.com"),
    Contact(name: "Felix Sanders", email: "felix.sanders@example.com"),
    Contact(name: "Grace Patterson", email: "grace.patterson@example.com"),
    Contact(name: "Henry Powell", email: "henry.powell@example.com"),
    Contact(name: "Isla Reed", email: "isla.reed@example.com"),
    Contact(name: "Jack Rivera", email: "jack.rivera@example.com"),
    Contact(name: "Kylie Brooks", email: "kylie.brooks@example.com")
]
