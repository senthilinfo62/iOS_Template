//
//  MessageRepository.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

final class MessageRepository: MessageFetching {
    func fetchWelcomeMessage() -> String {
        return "Message from Repository Layer!"
    }
}
