//
//  GroceryListViewModel.swift
//  My Kitchen
//
//  Created by Rishik Dev on 31/01/22.
//

import Foundation
import CoreData

class GroceryListViewModel: ObservableObject
{
//    @Published var listItems: [GroceryListModel] = []
    @Published var savedEntities: [GroceryListEntity] = []
    let groceryListContainer: NSPersistentContainer
        
    init()
    {
        groceryListContainer = NSPersistentContainer(name: "GroceryListContainer")
        groceryListContainer.loadPersistentStores
        {
            (description, error) in
            if let error = error
            {
                print("ERROR LOADING CORE DATA: \(error)")
            }
        }
        
        fetchGroceryLists()
    }
    
    func fetchGroceryLists()
    {
        let request = NSFetchRequest<GroceryListEntity>(entityName: "GroceryListEntity")   // fetching the entity from core data

        do
        {
            savedEntities = try groceryListContainer.viewContext.fetch(request)
        }

        catch let error
        {
            print("ERROR FETCHING: \(error)")
        }
    }
    
    func saveData()
    {
        do
        {
            try groceryListContainer.viewContext.save()
            fetchGroceryLists()
        }
        
        catch let error
        {
            print("ERROR SAVING: \(error)")
        }
    }
    
    func addItem(listTitle: String, listContent: String)
    {
        let newListItem = GroceryListEntity(context: groceryListContainer.viewContext)
        newListItem.listTitle = listTitle
        newListItem.listContent = listContent
        
        saveData()
    }
    
    func deleteItem(thisIndex: IndexSet)
    {
        guard let index = thisIndex.first else {return}
        let entity = savedEntities[index]
        groceryListContainer.viewContext.delete(entity)
        
        saveData()
    }
    
    func updateItem()
    {
        do
        {
            try groceryListContainer.viewContext.save()
            fetchGroceryLists()
        }
        
        catch let error
        {
            print("ERROR SAVING: \(error)")
        }
    }
}
