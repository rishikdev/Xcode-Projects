//
//  GroceryListModel.swift
//  My Kitchen
//
//  Created by Rishik Dev on 31/01/22.
//

import Foundation

struct GroceryListModel: Identifiable
{
    let id: String
    var listTitle: String
    var listContent: String
    
    init(id: String = UUID().uuidString, listTitle: String, listContent: String)
    {
        self.id = id
        self.listTitle = listTitle
        self.listContent = listContent
    }
    
    func updateCompletion() -> GroceryListModel
    {
        return GroceryListModel(id: id, listTitle: listTitle, listContent: listContent)
    }
}
