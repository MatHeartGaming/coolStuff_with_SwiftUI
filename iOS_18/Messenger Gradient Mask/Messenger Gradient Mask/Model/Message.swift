//
//  Message.swift
//  Messenger Gradient Mask
//
//  Created by Matteo Buompastore on 07/08/24.
//

import SwiftUI

struct Message: Identifiable {
    
    let id = UUID()
    var message: String
    var isReply: Bool = false
    
}

let messages: [Message] = [
    .init(message: text1),
    .init(message: text2, isReply: true),
    .init(message: text3),
    .init(message: text4),
    .init(message: text5, isReply: true),
    .init(message: text6),
    .init(message: text7, isReply: true),
    .init(message: text1),
    .init(message: text2, isReply: true),
    .init(message: text3),
    .init(message: text4),
    .init(message: text5, isReply: true),
    .init(message: text6),
    .init(message: text7),
]

let text1 = "Hey there! How are you doing today?"
let text2 = "I'm doing great! I've been working on some cool projects."
let text3 = "That sounds great! I'm looking forward to hearing more about them."
let text4 = "Thanks for sharing! I'll keep an eye out for more."
let text5 = "I'm glad I could help! Have a great day."
let text6 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam hendrerit lectus quis blandit rutrum. Nam condimentum a purus non euismod. Fusce pulvinar nisl sit amet velit imperdiet, et ornare quam eleifend."
let text7 = "Nulla nec metus posuere sapien vulputate feugiat. Duis id neque aliquam, rutrum augue a, elementum augue."
