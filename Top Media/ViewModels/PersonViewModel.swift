//
//  PersonViewModel.swift
//  Top Media
//
//  Created by Matthew Reddin on 20/03/2022.
//

import SwiftUI
import Combine

@MainActor
class PersonViewModel: ObservableObject {
    
    @Published var people: [Person] = []
    @Published var message = ""
    let mediaService: MediaService
    
    init(service: MediaService) {
        self.mediaService = service
    }
    
    func fetchPeople() async {
        message = ""
        do {
            people = try await mediaService.fetchTrendingPeople()
            if people.isEmpty {
                message = "No trending media personalities found"
            }
        }
        catch {
            message = "Error finding trending media personalities"
        }
    }
    
}
