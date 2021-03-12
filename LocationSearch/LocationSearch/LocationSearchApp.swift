//
//  LocationSearchApp.swift
//  LocationSearch
//
//  Created by Akhila on 12/03/2021.
//

import SwiftUI
import ComposableArchitecture

@main
struct LocationSearchApp: App {
    var body: some Scene {
        WindowGroup {
            LocationSearchView( store: Store(initialState: LocationSearch.State(), reducer: LocationSearch.reducer, environment: LocationSearch.Environment( webService: .live))
            )
        }
    }
}
