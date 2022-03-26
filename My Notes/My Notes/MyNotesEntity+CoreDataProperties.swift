//
//  MyNotesEntity+CoreDataProperties.swift
//  My Notes
//
//  Created by Rishik Dev on 24/03/22.
//
//

import Foundation
import CoreData


extension MyNotesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyNotesEntity> {
        return NSFetchRequest<MyNotesEntity>(entityName: "MyNotesEntity")
    }

    @NSManaged public var folderID: UUID?
    @NSManaged public var id: UUID?
    @NSManaged public var noteText: String?
    @NSManaged public var saveDateTime: Date?
    @NSManaged public var tag: String?
    @NSManaged public var folder: FolderEntity?

}

extension MyNotesEntity : Identifiable {

}
