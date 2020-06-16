//
//  ContentView.swift
//  Calc
//
//  Created by 新井まりな on 2020/06/16.
//  Copyright © 2020 Marina Arai. All rights reserved.
//

import SwiftUI

class CalculatorViewModel: ObservableObject{
    @Published var display = "0"
    @Published var userIsInTheMiddleOfTyping = false
    
    var displayValue: Double {
        get {
            return Double(display)!
        }
        set {
            display = String(newValue)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var calculatorVM: CalculatorViewModel
    @State var brain = CaluclatorBrain()
    
    var body: some View {
        VStack(spacing: 8) {
            Text(calculatorVM.display)
                .font(.largeTitle)
                .padding(.all)
                .frame(maxWidth: .infinity,alignment: .trailing)
                .border(Color.blue)
                .padding(.leading)
                .padding(.trailing)
            
            VStack(spacing: 8) {
                BinarySmbols(brain: $brain)
                HStack(spacing: 8){
                    UnarySmbols(brain: $brain)
                    Digits()
                }
            }
            
            
        }
    }
}

struct BinarySmbols: View {
    @EnvironmentObject var calculatorVM: CalculatorViewModel
    @Binding var brain:CaluclatorBrain
    let symbols = ["+","-","÷","×"]
    
    var body: some View{
        HStack(spacing:8) {
            ForEach(symbols, id:\.self){ mathematicalSymbol in
                Button(mathematicalSymbol, action: {
                    self.calculatorVM.userIsInTheMiddleOfTyping = false
                    self.brain.setOperand(self.calculatorVM.displayValue)
                    self.brain.performOperation(mathematicalSymbol)
                    if let result = self.brain.result {
                        self.calculatorVM.displayValue = result
                    }
                })
                    .frame(width: 64, height: 64)
                    .border(Color.blue)
            }
        }
    }
}

struct UnarySmbols: View {
    @EnvironmentObject var calculatorVM: CalculatorViewModel
    @Binding var brain:CaluclatorBrain
    let symbols = ["π","√","±","="]
    
    var body: some View{
        VStack(spacing:8) {
            ForEach(symbols, id:\.self){ mathematicalSymbol in
                Button(mathematicalSymbol, action: {
                    self.calculatorVM.userIsInTheMiddleOfTyping = false
                    self.brain.setOperand(self.calculatorVM.displayValue)
                    self.brain.performOperation(mathematicalSymbol)
                    if let result = self.brain.result {
                        self.calculatorVM.displayValue = result
                    }
                })
                    .frame(width: 64, height: 64)
                    .border(Color.blue)
            }
        }
    }
}

struct Digits: View {
    @EnvironmentObject var calculatorVM: CalculatorViewModel
    let digits = [[7,8,9],[4,5,6],[1,2,3],[0]]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(digits, id:\.self){ rowDigits in
                HStack(spacing: 8) {
                    ForEach(rowDigits,id: \.self){ digit in
                        Button("\(digit)",action: {
                            if self.calculatorVM.userIsInTheMiddleOfTyping {
                                self.calculatorVM.display = self.calculatorVM.display + "\(digit)"
                            }else{
                                self.calculatorVM.display = "\(digit)"
                                self.calculatorVM.userIsInTheMiddleOfTyping = true
                            }
                        })
                            .frame(width: 64, height: 64)
                            .border(Color.blue)
                    }
                }
            }
            Button(".", action: {
                if self.calculatorVM.userIsInTheMiddleOfTyping {
                    self.calculatorVM.display = self.calculatorVM.display + "."
                }else{
                    self.calculatorVM.display = "0."
                    self.calculatorVM.userIsInTheMiddleOfTyping = true
                }
            })
            .frame(width: 64, height: 64)
            .border(Color.blue)

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(CalculatorViewModel())
    }
}
