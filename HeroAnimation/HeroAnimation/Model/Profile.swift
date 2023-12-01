//
//  Profile.swift
//  HeroAnimation
//
//  Created by Matteo Buompastore on 01/12/23.
//

import Foundation

struct Profile: Identifiable {
    
    var id = UUID()
    var userName: String
    var profilePicture: String
    var lastMsg: String
    
}

var profiles: [Profile] = [
    
    .init(userName: "Linus", profilePicture: "pic1", lastMsg: "Let's hero animate the segue... to our sponsor!"),
    .init(userName: "Leon S. Kennedy", profilePicture: "pic2", lastMsg: "Let's go kick some ass!"),
    .init(userName: "Javier Milei", profilePicture: "pic3", lastMsg: "Hoy comienza el fin de la decadencia de Argentina..."),
    .init(userName: "Matteo", profilePicture: "pic4", lastMsg: "Developing some cool stuff 👨🏼‍💻"),
    
]
