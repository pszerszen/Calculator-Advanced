//
//  CalculatorLogic.swift
//  Calculator-Advanced
//
//  Created by Piotr Szerszeń on 20/10/2021.
//

import Foundation

struct CalculatorLogic {

    private let operations: Dictionary<String, (Double) -> Double> = [
        "+/-":  { $0 * -1 },
        "AC": { $0 * 0 },
        "%": { $0 * 0.01 }
    ]

    private let numOperations: Dictionary<String, (Double, Double) -> Double> = [
        "+": { $0 + $1 },
        "-": { $0 - $1 },
        "×": { $0 * $1 },
        "÷": { $0 / $1 }
    ]

    private var number: Double?
    private var intermediateCalculation: (n1: Double, calcMethod: String)?

    var isFinished: Bool {
        return intermediateCalculation == nil
    }

    mutating func setNumber(_ number: Double) {
        self.number = number
    }

    mutating func calculate(symbol: String) -> Double? {
        if let n = number {
            switch symbol {
                case let operation where operations.keys.contains(operation):
                    return operations[operation]!(n)
                case "=":
                    return performTwoNumCalculation(n2: n)
                default:
                    intermediateCalculation = (n1: n, calcMethod: symbol)
            }
        }
        return nil
    }

    private mutating func performTwoNumCalculation(n2: Double) -> Double? {
        if let n1 = intermediateCalculation?.n1,
           let operation = intermediateCalculation?.calcMethod {

            if let numOperation = numOperations[operation] {
                number = numOperation(n1, n2)
                return number
            } else {
                fatalError("The operation passed in (\(operation)) does not match any of the cases.")
            }
        }
        return nil
    }
}

