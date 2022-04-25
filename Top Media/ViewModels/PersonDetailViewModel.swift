//
//  PersonDetailViewModel.swift
//  Top Media
//
//  Created by Matthew Reddin on 20/03/2022.
//

import SwiftUI

class PersonDetailViewModel: ObservableObject {
    
    @Published var credits: [MediaDetail] = []
    @Published var details: PersonInformation? = nil
    let id: Int
    let mediaService: MediaService
    
    init(personID: Int, service: MediaService) {
        self.id = personID
        self.mediaService = service
        Task {
            await fetchDetailsAndCredits()
        }
    }
    
    func fetchDetailsAndCredits() async {
        details = try? await mediaService.fetchPersonDetails(id: id)
        credits = (try? await mediaService.fetchPersonCredits(id: id)) ?? []
    }
}
