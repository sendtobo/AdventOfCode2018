import Foundation

class Day5: Day {
    var challenges: [Challenge] = [Challenge1(), Challenge2()]
    required init() { }
}

struct Unit {
    var polarity: Polarity
    var value: String
    
    init(string: String) {
        self.polarity = string == string.lowercased() ? .lower : .upper
        self.value = string.lowercased()
    }
    
    func sameButNotPolarity(with unit: Unit) -> Bool {
        return self.value == unit.value && self.polarity != unit.polarity
    }
}

enum Polarity {
    case upper
    case lower
}

private class Challenge1: Challenge {
    func run(input: String) {
        var input = input
        input.removeLast() //pesky new line coming through
        print(self.fullySmash(input))
    }
    
    func fullySmash(_ input: String) -> Int {
        var startUnits = input.map({ Unit(string: "\($0)") })
        var endUnits = self.smash(startUnits)
        
        while startUnits.count != endUnits.count {
            startUnits = endUnits
            endUnits = self.smash(startUnits)
        }
        
        return endUnits.count
    }
    
    func smash(_ units: [Unit]) -> [Unit] {
        var endUnits = [Unit]()
        var skipUnit = false
        for (index, unit) in units.enumerated() {
            if skipUnit {
                skipUnit = false
            } else {
                let nextIndex = index + 1
                if nextIndex < units.count {
                    let nextUnit = units[nextIndex]
                    if unit.sameButNotPolarity(with: nextUnit) {
                        skipUnit = true
                    } else {
                        endUnits.append(unit)
                    }
                } else {
                    endUnits.append(unit)
                }
            }
        }
        return endUnits
    }
}

private class Challenge2: Challenge1 {
    override func run(input: String) {
        var input = input
        input.removeLast()
        var smallestCount: Int?
        for char in "abcdefghijklmnopqrstuvwxyz" {
            print("\(char)")
            var tempInput = input.replacingOccurrences(of: "\(char)", with: "")
            tempInput = tempInput.replacingOccurrences(of: "\(char)".uppercased(), with: "")
            let smashedCount = self.fullySmash(tempInput)
            if smallestCount == nil || smashedCount < smallestCount! {
                smallestCount = smashedCount
            }
        }
        print(smallestCount ?? -1)
    }
}
