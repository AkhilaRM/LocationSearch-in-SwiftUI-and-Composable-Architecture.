//
//  LocationSearchView.swift
//  LocationSearch
//
//  Created by Akhila on 12/03/2021.
//

import SwiftUI
import ComposableArchitecture
import CoreLocation

struct LocationSearchView: View {
    let store: Store<LocationSearch.State, LocationSearch.Action>
    let textFieldPadding: CGFloat = 12.0
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    Image("magnifyingGlass")
                    TextField("Search Location", text: viewStore.binding(get: { $0.searchTerm }, send: LocationSearch.Action.didtapSearchTextField))
                        .foregroundColor(.black)
                }
                .padding(textFieldPadding)
                .background(RoundedRectangleView())
                VStack {
                    ScrollView{
                        ForEach(viewStore.locations, id: \.self){ address in
                            VStack(alignment: .leading) {
                                Text(address.description)
                                    .foregroundColor(.black)
                                Text(address.description)
                                    .foregroundColor(.black)
                                Divider()
                            }
                            .padding(.all, 10.0)
                            .background(Color.white)
                            .onTapGesture {
                                viewStore.send(.didSelectAddress(address.description, address.placeId))
                            }
                        }
                    }
                }
                .background(Color.white)
            }
        }
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView( store: Store(initialState: LocationSearch.State(), reducer: LocationSearch.reducer, environment: LocationSearch.Environment( webService: .live))
        )
    }
}

enum LocationSearch{
    struct State: Equatable{
        var searchTerm : String = ""
        var locations : [_locations] = []
        //var selectedLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(la)
        var selectedAddress = ""
        var locationSelected = false
        var googleApikey = "AIzaSyB4fiyAw8BEs35uf2U48jEicFrRtqgD5aQ"
    }
    enum Action: Equatable {
        case doNothing
        case didtapSearchTextField(String)
        case gotSearchLocationResponse(Result<LocationResponse, ApiError>)
        case didSelectAddress(String, String)
        case gotLatLngResponse(Result<LocationLatLngResponse, ApiError>)
    }
    struct Environment {
        let webService: WebService
    }
    
    static let reducer = Reducer<LocationSearch.State, LocationSearch.Action, LocationSearch.Environment>.combine(
        Reducer { (state, action, environment) in
            switch action {
            case .doNothing:
                return .none
            ////Mark:- google places autocomplete search
            case let .didtapSearchTextField(queryterm):
                state.searchTerm = queryterm
                return environment
                    .webService
                    .locationSearch(queryterm.replacingOccurrences(of: " ", with: ""), state.googleApikey)
                    .receive(on: RunLoop.main)
                    .catchToEffect()
                    .map(Action.gotSearchLocationResponse)
                
            case let .gotSearchLocationResponse(.success(response)):
                state.locations = response.predictions
                return .none
                
            case let .gotSearchLocationResponse(.failure(error)):
                print(error)
                return .none
            //// Mark:- google places api to fetch lat and long for selected location.
            case let .didSelectAddress(address,placeId):
                state.locationSelected = true
                state.selectedAddress = address
                state.searchTerm = address
                state.locations.removeAll()
                return environment
                    .webService
                    .getLocationLatLng(placeId,state.googleApikey)
                    .receive(on: RunLoop.main)
                    .catchToEffect()
                    .map(Action.gotLatLngResponse)
                
                
            case let .gotLatLngResponse(.success(response)) :
                print(response)
//                if let location = response.results.first?.geometry.location {
//                    state.selectedLocation = CLLocationCoordinate2D(latitude: Double(location.lat), longitude: Double(location.lng))
//                }
                return .none
                
            case let .gotLatLngResponse(.failure(error)) :
                return .none
            }
        }
    )
}


struct RoundedRectangleView: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5.0)
            .strokeBorder(Color.black, lineWidth: 1.0)
    }
}
