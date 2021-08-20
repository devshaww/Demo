//
//  ViewController.swift
//  calculator
//
//  Created by Shaw on 16/4/17.
//  Copyright © 2016年 XiaoLinyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfEnteringANumber = false
    @IBAction func digitPressed(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfEnteringANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfEnteringANumber = true
        }
        
    }
    
    @IBAction func clear() {
        
        
    }
    
    @IBAction func clear(_ sender: AnyObject) {
    }
    
    var brain = CalculatorBrain()
    var operandStack = [Double]()
    
    @IBAction func enter() {
        userIsInTheMiddleOfEnteringANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func operate(_ sender: UIButton) {
        if userIsInTheMiddleOfEnteringANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }

//        switch operation {
//        case "+":performOperation { $0 + $1 }  // no other arguments,you can get rid of the parentheses
//        // performOperation takes a function as its argument,you could take the last argument which is {$0+$1} here out from parentheses,and put other arguments,if it has,inside the parentheses
//        // if the whole is just an expression like return key word,then don't even need to write return
//        // And Swift won't force you to name your arguments,if not named,it will use name $0 $1 $2 e
//        case "−":
//
//        case "×":
//
//        case "÷":
//
//        case "√":
//
//        default:
//            break;
//        }
/*
 performOperation {$0 + $1}
}
 
 */
    }
    
    
    func performOperation(_ operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            // 5 9 * so 45 appears then tap a number 9 then +
            enter()
        }
    }
    
    // computed type
    var displayValue: Double {
        get {
            return NumberFormatter().number(from: display.text!)!.doubleValue
        }
        set {
            display.text! = "\(newValue)"
            userIsInTheMiddleOfEnteringANumber = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

