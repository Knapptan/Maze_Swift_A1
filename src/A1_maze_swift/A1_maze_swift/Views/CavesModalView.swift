//
//  CavesModalView.swift
//  A1_maze_swift
//
//  Created by Knapptan on 31.03.2024.
//

import SwiftUI

struct CavesModalView: View {
    @Binding var isPresented: Bool
    @Binding var inputValueCols: String
    @Binding var inputValueRows: String
    @Binding var inputBirthСycle: String
    @Binding var inputDeathСycle: String

    var body: some View {
        VStack {
            Text("The size of the cave can be from 1 to 50")
                .padding(.top)
            Text("Maximum size of the cave is 50 x 50")
            
            TextField("Enter number of columns", text: $inputValueCols)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: inputValueCols) { oldState, newState in
                    if let value = Int(newState), !(1...50).contains(value) {
                        // Если введенное значение не входит в диапазон от 1 до 50, сбрасываем ввод
                        inputValueCols = ""
                    }
                }
            
            TextField("Enter number of rows", text: $inputValueRows)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: inputValueRows) { oldState, newState in
                    if let value = Int(newState), !(1...50).contains(value) {
                        // Если введенное значение не входит в диапазон от 1 до 50, сбрасываем ввод
                        inputValueRows = ""
                    }
                }
            
            Text("The live cycle can have values from 0 to 7")
            TextField("Enter number of \"birth\" cycles", text: $inputBirthСycle)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: inputBirthСycle) { oldState, newState in
                    if let value = Int(newState), !(0...7).contains(value) {
                        // Если введенное значение не входит в диапазон от 0 до 7, сбрасываем ввод
                        inputBirthСycle = ""
                    }
                }
            TextField("Enter number of \"death\" cycles", text: $inputDeathСycle)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: inputDeathСycle) { oldState, newState in
                    if let value = Int(newState), !(0...7).contains(value) {
                        // Если введенное значение не входит в диапазон от 0 до 7, сбрасываем ввод
                        inputDeathСycle = ""
                    }
                }
            
            Button("Generate") {
                self.isPresented = false
            }
            .padding()
        }
        .frame(width: 300, height: 240)
        .cornerRadius(10)
    }
}

struct CavesModalView_Previews: PreviewProvider {
    static var previews: some View {
        CavesModalView(isPresented: .constant(true), inputValueCols: .constant(""), inputValueRows: .constant(""), inputBirthСycle: .constant(""), inputDeathСycle: .constant(""))
    }
}
