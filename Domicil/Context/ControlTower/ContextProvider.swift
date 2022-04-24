//
//  ContextProvider.swift
//  Domicil
//
//  Created by Никита Гусев on 09.04.2022.
//

import Foundation

final class ContextProvider {
    private var context: CommonContext?
    
    func set(context: CommonContext) {
        self.context = context
    }
    
    func provideContext() -> CommonContext {
        guard let context = context else {
            fatalError("Context must be set before its using")
        }
        return context
    }
}
