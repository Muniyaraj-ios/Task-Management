//
//  LocationSearchViewModel.swift
//  Task Management
//
//  Created by MAC on 06/03/25.
//


import Foundation
import MapKit
import Combine

actor LocationSearchViewModel {
    
    @Published @MainActor private(set) var searchResults: [MKMapItem] = []
    
    func fetchLocations(for query: String) async throws -> Bool{
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            await MainActor.run {
                searchResults = []
            }
            throw LocationSearchError.emptyQuery
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .address
        
        let search = MKLocalSearch(request: request)
        let response = try await search.start()
        await MainActor.run {
            searchResults = response.mapItems
        }
        return true
    }
}


enum LocationSearchError: Error {
    case emptyQuery
    case searchFailed(Error)
}

