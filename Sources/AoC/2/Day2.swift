import Files

class Day2: Day {
    var challenges: [Challenge] = [Challenge1(), Challenge2()]
    
    required init() { }
}

private class Challenge1: Challenge {
    func run(input: String) {
        let lines = input.split(separator: "\n").map({ String($0) })
        var twos = 0
        var threes = 0
        for line in lines {
            let table = self.createTable(line: line)
            if table.values.contains(2) {
                twos += 1
            }
            if table.values.contains(3) {
                threes += 1
            }
        }
        print("Checksum: \(twos * threes)")
    }
    
    private func createTable(line: String) -> [Character: Int] {
        var countDictionary = [Character: Int]()
        for char in line {
            if let currentValue = countDictionary[char] {
                countDictionary[char] = currentValue + 1
            } else {
                countDictionary[char] = 1
            }
        }
        return countDictionary
    }
}

private class Challenge2: Challenge {
    func run(input: String) {
        var lines = input.split(separator: "\n").map({ String($0) })
        for currentLine in lines {
            for line in lines {
                let commonLetters = self.commonLetters(a: currentLine, b: line)
                if commonLetters.count == currentLine.count - 1 {
                    print("Common Letters: \(commonLetters)")
                    break
                }
            }
            lines.removeFirst()
        }
    }
    
    func commonLetters(a: String, b: String) -> String {
        return a.enumerated().reduce(into: "") { (result, tuple) in
            let (index, charA) = tuple
            if charA == b[b.index(b.startIndex, offsetBy: index)] {
                result.append(charA)
            }
        }
    }
}
