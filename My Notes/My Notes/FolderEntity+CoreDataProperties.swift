//
//  FolderEntity+CoreDataProperties.swift
//  My Notes
//
//  Created by Rishik Dev on 24/03/22.
//
//

import Foundation
import CoreData


extension FolderEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FolderEntity> {
        return NSFetchRequest<FolderEntity>(entityName: "FolderEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var notesCount: Int64
    @NSManaged public var defaultFolder: Bool
    @NSManaged public var notes: NSSet?

}

// MARK: Generated accessors for notes
extension FolderEntity {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: MyNotesEntity)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: MyNotesEntity)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

extension FolderEntity : Identifiable {

}
