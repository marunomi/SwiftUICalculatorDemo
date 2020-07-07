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
        ZStack{
            Color.snow.edgesIgnoringSafeArea(.all)
            VStack(spacing: 10) {
                Spacer()
                Text(calculatorVM.display)
                    .font(.largeTitle)
                    .padding()
                    .frame(width: 64*4+40, height: 64, alignment: .trailing)
                    .background(Color.powderBlue.opacity(0.5))
                    .cornerRadius(45, antialiased: true)
                    
                Spacer()
                UnarySmbols(brain: $brain)
                HStack(alignment:.top,spacing: 10){
                    Digits(brain: $brain)
                    BinarySmbols(brain: $brain)
                }
                Spacer()
            }
        }
        
    }
}

struct BinarySmbols: View {
    @EnvironmentObject var calculatorVM: CalculatorViewModel
    @Binding var brain:CaluclatorBrain
    let symbols = ["+","-","÷","×"]
    
    var body: some View{
        VStack(spacing:10) {
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
                    .background(Color.englishViolet)
                    .foregroundColor(Color.snow)
                    .clipShape(Circle())
            }
        }
    }
}

struct UnarySmbols: View {
    @EnvironmentObject var calculatorVM: CalculatorViewModel
    @Binding var brain:CaluclatorBrain
    let symbols = ["π","√","±"]
    
    var body: some View{
        HStack(spacing:10) {
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
                    .background(Color.englishViolet)
                    .foregroundColor(Color.snow)
                    .clipShape(Circle())
            }
            Button("AC", action: {
                self.calculatorVM.userIsInTheMiddleOfTyping = false
                self.brain.setOperand(self.calculatorVM.displayValue)
                self.brain.performOperation("AC")
                if self.brain.result != nil {
                    self.calculatorVM.displayValue = 0
                }
            })
                .frame(width: 64, height: 64)
                .background(Color.kobi)
                .foregroundColor(Color.englishViolet)
                .clipShape(Circle())
        }
        
    }
}

struct Digits: View {
    @EnvironmentObject var calculatorVM: CalculatorViewModel
    @Binding var brain:CaluclatorBrain
    let digits = [[7,8,9],[4,5,6],[1,2,3],[0]]
    
    var body: some View {
        ZStack(alignment: .top){
            VStack(alignment:.leading,spacing: 10) {
                ForEach(digits, id:\.self){ rowDigits in
                    HStack(spacing: 10) {
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
                                .background(Color.powderBlue)
                                .foregroundColor(Color.englishViolet)
                                .clipShape(Circle())
                            
                        }
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
            .background(Color.powderBlue)
            .foregroundColor(Color.englishViolet)
            .clipShape(Circle())
            .offset(x: 0, y: 222)
            
            Button("=", action: {
                self.calculatorVM.userIsInTheMiddleOfTyping = false
                self.brain.setOperand(self.calculatorVM.displayValue)
                self.brain.performOperation("=")
                if let result = self.brain.result {
                    self.calculatorVM.displayValue = result
                }
            })
            .frame(width: 64, height: 64)
                .background(Color.powderBlue)
            .foregroundColor(Color.englishViolet)
            .clipShape(Circle())
            .offset(x: 72, y: 222)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(CalculatorViewModel())
    }
}
