//
//  MessageRepository.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import Foundation

protocol MessageRepositoryProtocol {
    func fetchWelcomeMessage() -> String
    func fetchLocalizedMessage(key: String) -> String
}

final class MessageRepository: MessageRepositoryProtocol {
    func fetchWelcomeMessage() -> String {
        return "Message from Repository Layer!"
    }

    func fetchLocalizedMessage(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
