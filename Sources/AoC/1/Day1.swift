
class Day1: Day {
    var challenges: [Challenge] = [Challenge1(), Challenge2()]
    required init() { }
}

private class Challenge1: Challenge {
    func run(input: String) {
        //Split string into Ints
        let frequencyChanges = input.split(separator: "\n").map({ Int($0)! })
        print("Ending Frequency: \(self.runChanges(changes: frequencyChanges))")
    }
    
    func runChanges(changes: [Int]) -> Int {
        //add all the numbers together
        return changes.reduce(0, { result, number in
            return result + number
        })
    }
}

private class Challenge2: Challenge {
    
    func run(input: String) {
        //Split string into Ints
        let frequencyChanges = input.split(separator: "\n").map({ Int($0)! })
        print("First Repeated Frequency: \(self.runChanges(changes: frequencyChanges))")
    }
    
    func runChanges(changes: [Int]) -> Int {
        var frequency = 0
        var foundFrequencies = [0]
        var repeatedFrequency: Int!
        var numberOfPasses = 0
        
        while repeatedFrequency == nil {
            numberOfPasses += 1
            print("Number of Passes: \(numberOfPasses)")
            for number in changes {
                frequency += number
                if foundFrequencies.contains(frequency) {
                    repeatedFrequency = frequency
                    break
                }
                foundFrequencies.append(frequency)
            }
        }
        return repeatedFrequency
    }
}
