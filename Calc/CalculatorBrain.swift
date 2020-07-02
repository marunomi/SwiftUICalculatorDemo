//
//  CalculatorBrain.swift
//  Calc
//
//  Created by 新井まりな on 2020/06/16.
//  Copyright © 2020 Marina Arai. All rights reserved.
//

import Foundation

func changeSign(operand: Double) -> Double {
    -operand
}

struct CaluclatorBrain {
    private var accumlator: Double? //results of the calculations
    
    private enum Operation{
        case constant(Double)
        case unaryOperation( (Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
        case clear
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "±": Operation.unaryOperation(changeSign),
        "+": Operation.binaryOperation({$0 + $1}),
        "-": Operation.binaryOperation({$0 - $1}),
        "÷": Operation.binaryOperation({$0 / $1}),
        "×": Operation.binaryOperation({$0 * $1}),
        "=": Operation.equals,
        "AC": Operation.clear,
        
    ]
    
    mutating func performOperation(_ symbol: String){
        if let operation = operations[symbol]{
            switch operation {
            case .constant(let value):
                accumlator = value
            case .unaryOperation(let function):
                if let accumlator = accumlator {
                    self.accumlator = function(accumlator)
                }
                break
            case .binaryOperation(let function):
                if accumlator != nil{
                    pbo = PendingBinaryOperation(function: function, firstOperand: accumlator!)
                    accumlator = nil
                }
                break
            case .equals:
                performingPendingBinaryOperation()
            case .clear:
                self.accumlator = 0
            }
        }
        
    }
    
    private mutating func performingPendingBinaryOperation(){
        if pbo != nil && accumlator != nil{
            accumlator = pbo?.perform(with: accumlator!)
            pbo = nil
        }
    }
    
    private var pbo: PendingBinaryOperation?
    
    private struct PendingBinaryOperation{
        let function:(Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double{
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumlator = operand
    }
    
    var result: Double?{
        get {
            return accumlator
        }
    }
    
}
