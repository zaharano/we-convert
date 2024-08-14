//
//  ContentView.swift
//  WeConvert
//
//  Created by Zachary Rais-Norman on 8/13/24.
//

import SwiftUI

struct ContentView: View {
    @FocusState private var amountIsFocused: Bool
    @State private var converting = "Temp"
    
    @State private var fromUnit = "Celsius"
    @State private var toUnit = "Fahrenheit"
    
    @State private var fromAmount = 0.0
    private var baseAmount: Double {
        if (converting == "Temp") {
            return convertToCelsius(from: fromUnit, amount: fromAmount)
        } else if (converting == "Length") {
            return convertToMeters(from: fromUnit, amount: fromAmount)
        } else if (converting == "Time") {
            return convertToSeconds(from: fromUnit, amount: fromAmount)
        } else if (converting == "Volume") {
            return convertToMl(from: fromUnit, amount: fromAmount)
        } else {
            return 0.0
        }
    }
    
    private var toAmount: Double {
        if (fromUnit == toUnit) {
            return fromAmount
        } else if (converting == "Temp") {
            return convertFromCelsius(to: toUnit, amount: baseAmount)
        } else if (converting == "Length") {
            return convertFromMeters(to: toUnit, amount: baseAmount)
        } else if (converting == "Time") {
            return convertFromSeconds(to: toUnit, amount: baseAmount)
        } else if (converting == "Volume") {
            return convertFromMl(to: toUnit, amount: baseAmount)
        } else {
            return 0.0
        }
        
    }
    
    func convertToCelsius(from unit: String, amount: Double) -> Double {
        if (unit == "Fahrenheit") {
            return (amount - 32.0) * (5.0/9.0)
        } else if (unit == "Kelvin") {
            return amount - 273.15
        } else {
            return amount
        }
    }
    
    func convertFromCelsius(to unit: String, amount: Double) -> Double {
        if (unit == "Fahrenheit") {
            return (amount * (9.0/5.0)) + 32.0
        } else if (unit == "Kelvin") {
            return amount + 273.15
        } else {
            return amount
        }
    }
    
    func convertToMeters(from unit: String, amount: Double) -> Double {
        if (unit == "km") {
            return amount * 1000.0
        } else if (unit == "feet") {
            return amount / 3.281
        } else if (unit == "yards") {
            return amount / 1.094
        } else if (unit == "miles") {
            return amount * 1609
        } else {
            return amount
        }
    }
    
    func convertFromMeters(to unit: String, amount: Double) -> Double {
        if (unit == "km") {
            return amount / 1000.0
        } else if (unit == "feet") {
            return amount * 3.281
        } else if (unit == "yards") {
            return amount * 1.094
        } else if (unit == "miles") {
            return amount / 1609
        } else {
            return amount
        }
    }
    
    func convertToSeconds(from unit: String, amount: Double) -> Double {
        if (unit == "minutes") {
            return amount * 60
        } else if (unit == "hours") {
            return amount * 60 * 60
        } else if (unit == "days") {
            return amount * 60 * 60 * 24
        } else {
            return amount
        }
    }
    
    func convertFromSeconds(to unit: String, amount: Double) -> Double {
        if (unit == "minutes") {
            return amount / 60
        } else if (unit == "hours") {
            return amount / 60 / 60
        } else if (unit == "days") {
            return amount / 60 / 60 / 24
        } else {
            return amount
        }
    }
    
    func convertToMl(from unit: String, amount: Double) -> Double {
        if (unit == "liters") {
            return amount * 1000
        } else if (unit == "cups") {
            return amount * 240
        } else if (unit == "pints") {
            return amount * 473.176
        } else if (unit == "gallons") {
            return amount * 3785.41
        } else {
            return amount
        }
    }
    
    func convertFromMl(to unit: String, amount: Double) -> Double {
        if (unit == "liters") {
            return amount / 1000
        } else if (unit == "cups") {
            return amount / 240
        } else if (unit == "pints") {
            return amount / 473.176
        } else if (unit == "gallons") {
            return amount / 3785.41
        } else {
            return amount
        }
    }
    
    let conversions = ["Temp", "Length", "Time", "Volume"]
    let units = [
        "Temp": ["Celsius", "Fahrenheit", "Kelvin"],
        "Length": ["meters", "km", "feet", "yards", "miles"],
        "Time": ["seconds", "minutes", "hours", "days"],
        "Volume": ["mL", "liters", "cups", "pints", "gallons"]
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Converting") {
                    Picker("Converting", selection: $converting) {
                        ForEach(conversions, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section("From unit") {
                    Picker("From", selection: $fromUnit) {
                        ForEach(units[converting, default: ["Celsius", "Fahrenheit", "Kelvin"]], id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: converting) {
                        fromUnit = units[converting, default: ["Celsius", "Fahrenheit", "Kelvin"]][0]
                    }
                }
                Section("To unit") {
                    Picker("To", selection: $toUnit) {
                        ForEach(units[converting, default: ["Celsius", "Fahrenheit", "Kelvin"]], id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: converting) {
                        toUnit = units[converting, default: ["Celsius", "Fahrenheit", "Kelvin"]][1]
                    }
                }
                Section {
                    TextField("Amount to convert", value: $fromAmount, format: .number)
                        .keyboardType(.numberPad)
                        .focused($amountIsFocused)
                }
                Section("Conversion") {
                    Text("\(fromAmount.formatted()) \(fromUnit) is \(toAmount.formatted()) \(toUnit)")
                }
            }
            .navigationTitle("WeConvert")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
