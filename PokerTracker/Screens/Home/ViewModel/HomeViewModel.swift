//
//  HomeViewModel.swift
//  PlayerGame
//
//  Created by VietChat on 8/4/24.
//

import Foundation

final class HomeViewModel {
    
    var eventHandler: ((_ event: Event) -> Void)?
    
    func fetchProducts() {
        self.eventHandler?(.loading)

    }
    
    func addGame() {
        
    }
}

extension HomeViewModel {
    
    enum Event {
        case loading
        case stopLoading
        case dataLoader
        case error(Error?)
        case newGameAdded
    }
}
