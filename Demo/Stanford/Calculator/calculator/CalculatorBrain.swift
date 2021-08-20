//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Shaw on 16/5/3.
//  Copyright © 2016年 XiaoLinyun. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    fileprivate enum Op: CustomStringConvertible {
        case operand(Double)
        case unaryOperation(String, (Double) -> Double)
        case binaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .operand(let operand):
                    return "\(operand)"
                case .binaryOperation(let symbol, _):
                    return symbol
                case .unaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    fileprivate var knownOps = [String:Op]()
    
    init() {
//        knownOps["+"] = Op.BinaryOperation("+"){ $0 + $1 }
        knownOps["+"] = Op.binaryOperation("+",+)
        knownOps["−"] = Op.binaryOperation("−"){ $1 - $0 }
        knownOps["×"] = Op.binaryOperation("×",*)
        knownOps["÷"] = Op.binaryOperation("÷"){ $1 / $0 }
        knownOps["√"] = Op.unaryOperation("√",sqrt)
        
    }
    
    fileprivate var opStack = [Op]()
    
    // [Op] is an array,array in Swift is a struct,and struct(such as Int,Double etc are structs in Swift)is passed by value,you can't immutate it unless you're passing an instance of a class.
    // Structs are passed by value,instances are passed by reference
    
    // since we've copied ops to remainingOps,is it right that we'll only mutate remainingOps instead of the array we pass into it
    fileprivate func evaluate(_ ops: [Op]) -> (result: Double? ,remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops  // if here's not an instance of certain class,"=" means copy,var means mutable copy
            let op = remainingOps.removeLast()
            switch op {
            case .operand(let operand):
                return (operand, remainingOps)
                
            case .binaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1,operand2),op2Evaluation.remainingOps)
                    }
                }
                
            case .unaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand),operandEvaluation.remainingOps)
                }
                
            }
        }
        // 9 8 * 6 - 8 + √
        //
        return (nil,ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(_ operand: Double) ->Double? {
        opStack.append(Op.operand(operand))
        return evaluate()
    }
    
    func performOperation(_ symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
}
