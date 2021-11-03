//
//  ViewController.swift
//  Calculator-Advanced
//
//  Created by Piotr Szerszeń on 20/10/2021.
//

import UIKit

class ViewController: UIViewController {

    private let TRESHOLD = 9
    private let DEFAULT_LABEL = "0"

    @IBOutlet weak var displayLabel: UILabel!
    var calculator = CalculatorLogic()

    private var currentLabel: String {
        return displayLabel.text ?? DEFAULT_LABEL
    }

    private var finishedTyping: Bool = true

    private var displayValue: Double {
        get {
            guard let num = Double(currentLabel) else { fatalError("Can't convert \(currentLabel) to number") }
            return num
        }
        set {
            displayLabel.text = normalizeNumber(newValue)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func calcButtonPressed(_ sender: UIButton) {

        finishedTyping = true
        calculator.setNumber(displayValue)

        if let calcMethod = sender.currentTitle {
            if let result = calculator.calculate(symbol: calcMethod) {
                displayValue = result
            }
        }
    }

    @IBAction func numButtonPressed(_ sender: UIButton) {
        if let numValue = sender.currentTitle {
            if finishedTyping {
                displayLabel.text = numValue
                finishedTyping = false
            } else {
                if !canAdd(numValue) { return }
                displayLabel.text! += numValue
            }
        }
    }

    private func canAdd(_ numValue: String) -> Bool {
        let reachedTreshold = Array(currentLabel)
            .filter { Int(String($0)) != nil }
            .count == TRESHOLD
        let attemptingToAddSecondDot = numValue == "." && !isInt(displayValue)
        return !(reachedTreshold || attemptingToAddSecondDot)
    }

    private func normalizeNumber(_ num: Double) -> String {
        let raw = isInt(num) ? String(Int(num)) : String(num)
        let withinThreshold = Array(raw)
            .filter{ Int(String($0)) != nil }
            .count <= TRESHOLD
        if withinThreshold {
            return raw
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.positiveFormat = "0.###E+0"
        formatter.exponentSymbol = "e"
        return formatter.string(for: num) ?? "NaN"
    }

    private func isInt(_ num: Double) -> Bool {
        return num == floor(num)
    }
}
