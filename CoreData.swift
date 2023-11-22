//
//  CoreData.swift
//  Note (Maria)
//
//  Created by Maria Piramide on 20/11/23.
//

import CoreData

class NoteEntity: NSManagedObject {
    @NSManaged var title: String
    @NSManaged var content: String
}
