//
//  ModalView.swift
//  A1_maze_swift
//
//  Created by Anton Krivonozhenkov on 13.03.2024.
//

import SwiftUI

struct ModalView: View {
    @Binding var isPresented: Bool
    @Binding var mazeWidth: String
    @Binding var mazeHeight: String
    
    var body: some View {
        VStack {
            Text("Rows")
            TextField("Enter number of rows", text: $mazeWidth)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: mazeWidth) { oldState, newState in
                    if let value = Int(newState), !(1...50).contains(value) { mazeWidth = "" }
                }
                .padding(.horizontal)
            
            Text("Columns")
                .padding(.top)
            TextField("Enter number of columns", text: $mazeHeight)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: mazeHeight) { oldState, newState in
                    if let value = Int(newState), !(1...50).contains(value) { mazeHeight = "" }
                }
                .padding(.horizontal)
            
            Button("Generate") { self.isPresented = false }
                .padding(.top)
        }
        .frame(width: 350, height: 200)
        .cornerRadius(10)
    }
}

#Preview {
    ModalView(isPresented: .constant(true),
              mazeWidth: .constant("500"),
              mazeHeight: .constant("500"))
}
