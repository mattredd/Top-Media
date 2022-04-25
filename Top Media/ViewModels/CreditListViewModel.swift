//
//  CrewListViewModel.swift
//  Top Media
//
//  Created by Matthew Reddin on 22/03/2022.
//

import SwiftUI

@MainActor
class CreditListViewModel: ObservableObject {
    
    @Published var imagePaths: (cast: [String?], crew: [String?])?
    let creditList: MediaCredits?
    let mediaService: MediaService
    let coordinator: Coordinator
    
    init(creditList: MediaCredits?, service: MediaService, coordinator: Coordinator) {
        self.coordinator = coordinator
        self.creditList = creditList
        self.mediaService = service
        Task {
            await self.fetchImagePaths()
        }
    }
    
    func fetchImagePaths() async {
        guard let creditList = creditList else {
            return
        }
        var castMembers: [String?] = Array(repeating: nil, count: creditList.cast?.count ?? 0)
        if let cast = creditList.cast {
            for indx in cast.indices {
                if let profilePath = cast[indx].profilePath {
                    let path = try? await mediaService.fetchImagePath(filePath: profilePath, size: .small)
                    castMembers.insert(path, at: indx)
                }
            }
        }
        var crewMembers: [String?] = Array(repeating: nil, count: creditList.crew?.count ?? 0)
        if let crew = creditList.crew {
            for indx in crew.indices {
                if let profilePath = crew[indx].profilePath {
                    let path = try? await mediaService.fetchImagePath(filePath: profilePath, size: .small)
                    crewMembers.insert(path, at: indx)
                }
            }
        }
        imagePaths = (castMembers, crewMembers)
    }
}
