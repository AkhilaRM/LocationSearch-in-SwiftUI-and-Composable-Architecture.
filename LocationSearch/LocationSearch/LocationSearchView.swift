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
                        .font(.textSemibold)
                        .foregroundColor(.brandDarkTextColor)
                }
                .padding(textFieldPadding)
                .background(RoundedRectangleView())
                VStack {
                    ScrollView{
                        ForEach(viewStore.locations, id: \.self){ address in
                            VStack(alignment: .leading) {
                                Text(address.description)
                                    .font(.textSemibold)
                                    .foregroundColor(.brandDarkTextColor)
                                Text(address.description)
                                    .font(.textRegularSmall)
                                    .foregroundColor(.brandLightTextColor)
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
        LocationSearchView( store: Store(initialState: LocationSearch.State(), reducer: LocationSearch.reducer, environment: LocationSearch.Environment(alertController: .sclAlertView(), webService: .mockSuccess))
        )
    }
}

enum LocationSearch{
    struct State: Equatable{
        var searchTerm : String = ""
        var locations : [_locations] = []
        var selectedLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(0.0), longitude: Double(0.0))
        var selectedAddress = ""
        var locationSelected = false
        var googleApikey = ""
    }
    enum Action: Equatable {
        case doNothing
        case didtapSearchTextField(String)
        case gotSearchLocationResponse(Result<LocationResponse, WebError>)
        case didSelectAddress(String, String)
        case gotLatLngResponse(Result<LocationLatLngResponse, WebError>)
    }
    struct Environment {
        let alertController: AlertController<Action>
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
                //state.locations.append(contentsOf: response.predictions)
                return .none
                
            case let .gotSearchLocationResponse(.failure(error)):
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
                if let location = response.results.first?.geometry.location {
                    state.selectedLocation = CLLocationCoordinate2D(latitude: Double(location.lat), longitude: Double(location.lng))
                }
                return .none
                
            case let .gotLatLngResponse(.failure(error)) :
                return .none
            }
        }
    )
}
