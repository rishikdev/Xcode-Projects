//
//  PersonView.swift
//  PizzaApp
//
//  Created by Rishik Dev on 25/05/23.
//

import SwiftUI

struct PersonView: View {
    @StateObject private var personVM = PersonViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if(personVM.isFetchSuccessful) {
                    VStack {
                        Text(personVM.person?.name ?? "No Name")
                            .font(.title)
                            .fontWeight(.bold)
                            .fontDesign(.rounded)
                            .padding()
                        
                        HStack {
                            Text("Height: \(personVM.person?.height ?? "No Height")")
                            Spacer()
                            Text("Mass: \(personVM.person?.mass ?? "No Mass")")
                        }
                        .modifier(CustomViewModifier())
                        
                        VStack(alignment: .leading, spacing: 25) {
                            Text("Hair Colour: \(personVM.person?.hairColour ?? "No Hair Colour")")
                            Text("Skin Colour: \(personVM.person?.skinColour ?? "No Skin Colour")")
                            Text("Eye Colour: \(personVM.person?.eyeColour ?? "No Eye Colour")")
                        }
                        .frame(maxWidth: .infinity)
                        .modifier(CustomViewModifier())
                        
                        HStack {
                            Text("Birth Year: \(personVM.person?.birthYear ?? "No Birth Year")")
                            Spacer()
                            Text("Gender: \(personVM.person?.gender ?? "No Gender")")
                        }
                        .modifier(CustomViewModifier())
                        
                        if let films = personVM.person?.films {
                            DisclosureGroup("Films") {
                                ForEach(films, id: \.self) { film in
                                    Text(film)
                                }
                            }
                            .modifier(CustomViewModifier())
                        }
                        
                        if let species = personVM.person?.species {
                            DisclosureGroup("Species") {
                                ForEach(species, id: \.self) { specie in
                                    Text(specie)
                                }
                            }
                            .modifier(CustomViewModifier())
                        }
                        
                        if let vehicles = personVM.person?.vehicles {
                            DisclosureGroup("Vehicles") {
                                ForEach(vehicles, id: \.self) { vehicle in
                                    Text(vehicle)
                                }
                            }
                            .modifier(CustomViewModifier())
                        }
                        
                        if let starships = personVM.person?.starships {
                            DisclosureGroup("Starships") {
                                ForEach(starships, id: \.self) { starship in
                                    Text(starship)
                                }
                            }
                            .modifier(CustomViewModifier())
                        }
                        
                        HStack {
                            Text("Created: \(personVM.person?.created ?? "No Created Date")")
                            Spacer()
                            Text("Edited: \(personVM.person?.edited ?? "No Edited Date")")
                        }
                        .modifier(CustomViewModifier())
                        
                        Text("URL: \(personVM.person?.url ?? "No URL")")
                        .modifier(CustomViewModifier())
                    }
                    .padding()
                    .onAppear {
                        personVM.getPerson()
                    }
                } else {
                    Text("Something went wrong")
                        .font(.largeTitle)
                }
            }
            .navigationTitle("Person")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CustomViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(uiColor: .systemGray6))
            .cornerRadius(10)
    }
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        PersonView()
    }
}
