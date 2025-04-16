//
//  PersonViewModel.swift
//  PizzaApp
//
//  Created by Rishik Dev on 25/05/23.
//

import Foundation

class PersonViewModel: ObservableObject {
    @Published var person: Person?
    @Published var isFetchSuccessful: Bool = true
    
    func getPerson() {
        NetworkManager.shared.getPerson(urlString: Constants.URLs.personAPI.rawValue) { [weak self] result in
            switch(result) {
            case .success(var person):
                person.created = self?.convertDate(date: person.created)
                person.edited = self?.convertDate(date: person.edited)
                self?.person = person
                self?.isFetchSuccessful = true
                
            case .failure(let error):
                print("ERROR FETCHING: \(error)")
                self?.isFetchSuccessful = false
            }
        }
    }
    
    func convertDate(date: String?) -> String? {
        var outputDate: String?
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        let receivedDate = dateFormatter.date(from: date ?? "No Date")
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        if let receivedDate = receivedDate {
            outputDate = dateFormatter.string(from: receivedDate)
        }
        
        return outputDate
    }
}

enum Constants {
    enum URLs: String {
        case personAPI = "https://swapi.py4e.com/api/people/1/"
    }
}
