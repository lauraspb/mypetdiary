//
//  Welcome.swift
//  mypetdiary
//
//  Created by Laura Páez on 12/17/24.
//

import SwiftUI

struct Welcome: View {
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @AppStorage("userName") var userName: String = ""
    @State private var inputImage: UIImage?
    @State private var showImagePicker = false
    @State private var scale = 0.5
    @State private var isEditing = false


    
    var body: some View {
        VStack {
            Text("Welcome to your Pet Diary!")
                .font(.custom("DynaPuff", size: 50))
                .scaleEffect(scale)
                .foregroundColor(Color(.mymutedpurple))
                .multilineTextAlignment(.center)
                .padding()
            Slider(
                value: $scale,
                in: 10...50,
                onEditingChanged: {editing in isEditing = editing}
                )
            Text("\(scale)")
                .foregroundColor(isEditing ? .purple : .blue)
                
            Text("Keep track of your pets photos and add notes to your memories!")
                .font(.custom("DynaPuff", size: 20))
                .multilineTextAlignment(.center)
                .padding()
            
            if let inputImage = inputImage {
                Image(uiImage: inputImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 7)
                    .padding()
            }
            
            TextField("Enter your name", text: $userName)
                .padding()
            
            Button("Upload/Change Profile Picture") { // Changed button label
                showImagePicker = true
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $inputImage)
            }
            
            Button("Save") {
                // Save inputImage to UserDefaults
                if let inputImage = inputImage, let imageData = inputImage.jpegData(compressionQuality: 0.8) {
                    UserDefaults.standard.set(imageData, forKey: "profilePicture")
                }
                
                isFirstLaunch = false
            }
            .font(.title2)
        }
        .onAppear {
            if let imageData = UserDefaults.standard.data(forKey: "profilePicture"),
               let savedImage = UIImage(data: imageData) {
                inputImage = savedImage
            }
        }
    }
}

#Preview {
    Welcome()
}
