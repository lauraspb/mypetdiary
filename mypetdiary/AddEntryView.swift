//
//  AddEntryView.swift
//  mypetdiary
//
//  Created by Laura Páez on 12/13/24.
//

import SwiftUI
import PhotosUI


struct AddEntryView: View {
    @Binding var selectedImage: UIImage?
    @Binding var entries: [CatEntry]
    @Environment(\.dismiss) var dismiss
    @State private var selectedDate = Date()
    @State private var notes: String = ""
    @State private var petNames: String = ""
    @State private var selectedItem: PhotosPickerItem? // Use PhotosPickerItem
    @State private var showImagePicker = false
    @State private var showActionSheet = false  // To show the action sheet
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary

    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                
                TextField("Notes", text: $notes)
                
                TextField("Pet Names (comma-separated)", text: $petNames)
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                }
                
                Button("Add Photo") {
                                    showActionSheet = true // Show action sheet for source selection
                                }
                                .actionSheet(isPresented: $showActionSheet) {
                                    ActionSheet(title: Text("Choose Photo Source"), message: nil, buttons: [
                                        .default(Text("Camera")) {
                                            imagePickerSourceType = .camera
                                            showImagePicker = true
                                        },
                                        .default(Text("Photo Library")) {
                                            imagePickerSourceType = .photoLibrary
                                            showImagePicker = true
                                        },
                                        .cancel()
                                    ])
                                }
                                .sheet(isPresented: $showImagePicker) {
                                    ImagePicker(selectedImage: $selectedImage, sourceType: imagePickerSourceType)
                                }

                Button("Save Entry") {
                                    let newEntry = CatEntry(
                                        date: selectedDate,
                                        photo: selectedImage != nil ? Image(uiImage: selectedImage!) : nil,
                                        notes: notes,
                                        pets: petNames.components(separatedBy: ",")
                                    )
                                    entries.append(newEntry)
                                    dismiss()
                                }
                    
                }
                    .navigationTitle("New Entry")
            }
        }
    }
