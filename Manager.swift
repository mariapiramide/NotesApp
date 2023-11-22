//
//  Manager.swift
//  Note (Maria)
//
//  Created by Maria Piramide on 20/11/23.
//

import Foundation

class NoteManager: ObservableObject {
    @Published var notes: [NoteEntity] = []
    private let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Notes") // Il nome dell'entità nel tuo modello di dati Core Data
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("Error setting up Core Data: \(error.localizedDescription)")
            }
        }
        fetchNotes()
    }
    
    private func fetchNotes() {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        do {
            notes = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error fetching notes: \(error.localizedDescription)")
        }
    }
    
    func addNote(title: String, content: String) {
        let newNote = NoteEntity(context: persistentContainer.viewContext)
        newNote.title = title
        newNote.content = content
        
        do {
            try persistentContainer.viewContext.save()
            fetchNotes()
        } catch {
            print("Error saving note: \(error.localizedDescription)")
        }
    }
    
    func deleteNote(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let note = notes[index]
            persistentContainer.viewContext.delete(note)
        }
        
        do {
            try persistentContainer.viewContext.save()
            fetchNotes()
        } catch {
            print("Error deleting note: \(error.localizedDescription)")
        }
    }
}
