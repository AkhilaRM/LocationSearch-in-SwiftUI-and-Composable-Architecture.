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
                            HStack{
                                Image("locationPin")
                            VStack(alignment: .leading) {
                                Text(address.description)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Text(address.description)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Divider()
                            }
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
            .padding()
        }
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView( store: Store(initialState: LocationSearch.State(), reducer: LocationSearch.reducer, environment: LocationSearch.Environment( webService: .live))
        )
    }
}

struct RoundedRectangleView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 5.0)
            .strokeBorder(Color.gray, lineWidth: 1.0)
    }
}
