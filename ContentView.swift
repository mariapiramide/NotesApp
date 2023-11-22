//
//  ContentView.swift
//  Note (Maria)
//
//  Created by Maria Piramide on 20/11/23.
//

import SwiftUI

import SwiftUI

struct Note: Identifiable {
    let id = UUID()
    var title: String
    var content: String
}

class NoteManager: ObservableObject {
    @Published var notes: [Note] = []
    
    func addNote(title: String, content: String) {
        let newNote = Note(title: title, content: content)
        notes.append(newNote)
    }
    
    func deleteNote(at indexSet: IndexSet) {
        notes.remove(atOffsets: indexSet)
    }
}

struct ContentView: View {
    @StateObject var noteManager = NoteManager()
    @State private var isPresentingNoteEditor = false
    @State private var newNoteTitle = ""
    @State private var newNoteContent = ""
    
    
    
    var body: some View {
        NavigationView {
            List { ForEach(noteManager.notes) { note in
                               NavigationLink(destination: NoteDetail(note: note)) {
                                   Text(note.title)
                               }
                           }
                           .onDelete(perform: deleteNotes) // Funzione per eliminare le note
                       }
                       .navigationTitle("Notes")
                       .navigationBarItems(trailing:
                           Button(action: {
                               isPresentingNoteEditor = true
                           }) {
                               Image(systemName: "plus")
                                   .foregroundColor(.yellow)
                           }
                       )
                   }
                   .sheet(isPresented: $isPresentingNoteEditor) {
                       NoteEditor(noteManager: noteManager, isPresented: $isPresentingNoteEditor)
                   }
               }

               // Funzione per eliminare le note
               private func deleteNotes(at offsets: IndexSet) {
                   noteManager.deleteNote(at: offsets)
               }}

struct NoteDetail: View {
    var note: Note
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(note.title)
                    .font(.title)
                Text(note.content)
                    .multilineTextAlignment(.leading) // Allineamento a sinistra
            }
            .padding()
        }
    }
}



struct NoteEditor: View {
    @ObservedObject var noteManager: NoteManager
    @Binding var isPresented: Bool
    @State private var newNoteTitle = ""
    @State private var newNoteContent = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Note")) {
                    TextField("Title", text: $newNoteTitle)
                    TextEditor(text: $newNoteContent)
                }
                
                Section {
                    Button("Save") {
                        noteManager.addNote(title: newNoteTitle, content: newNoteContent)
                        isPresented = false
                    }
                    .disabled(newNoteTitle.isEmpty || newNoteContent.isEmpty)
                }
            }
            .navigationTitle("New Note")
            .navigationBarItems(trailing:
                Button("Cancel") {
                    isPresented = false
                }
            )
        }
    }
}


import SwiftUI

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
