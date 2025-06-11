//
//  FetchMessageUseCase.swift
//  template
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//
import Foundation


protocol MessageFetching {
    func fetchWelcomeMessage() -> String
}

struct FetchMessageUseCase: MessageFetching {
    func fetchWelcomeMessage() -> String {
        return "Welcome to SwiftUI Navigation!"
    }
}

