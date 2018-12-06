class Day6: Day {
    var challenges: [Challenge] = [Challenge1(), Challenge2()]
    required init() { }
}

struct Coordinate {
    var x: Int
    var y: Int
}

private class Challenge1: Challenge {
    var boardDimension = 400
    
    func run(input: String) {
        let lines = input.split(separator: "\n").map({ String($0) })
        let coordinates = lines.map({ line -> Coordinate in
            var split = line.split(separator: ",")
            return Coordinate(x: Int(split[0])!, y: Int(split[1].dropFirst())!)
        })
        
        var board = [[String]](repeating: [String](repeating: ".", count: self.boardDimension), count: self.boardDimension)
        
        for (rowIndex, row) in board.enumerated() {
            for (colIndex, _) in row.enumerated() {
                let indexCoordinate = Coordinate(x: rowIndex, y: colIndex)
                var minDistance = Int.max
                var indexToSave = -1
                var twoSameDistance = false
                for (index, coordinate) in coordinates.enumerated() {
                    let currentDistance = self.distance(from: indexCoordinate, to: coordinate)
                    if currentDistance == minDistance {
                        twoSameDistance = true
                    } else if currentDistance < minDistance {
                        minDistance = currentDistance
                        indexToSave = index
                        twoSameDistance = false
                    }
                }
                if !twoSameDistance {
                    board[rowIndex][colIndex] = "\(indexToSave)"
                }
            }
        }
        
        var flattenedBoard = board.flatMap{( $0 )}.filter({ $0 != "." })
        
        var indexToCount = [String: Int]()
        for item in flattenedBoard {
            indexToCount[item, default: 0] += 1
        }
        
        for index in 0..<self.boardDimension {
            let topIndex = board[0][index]
            indexToCount.removeValue(forKey: topIndex)
            
            let bottomIndex = board[self.boardDimension - 1][index]
            indexToCount.removeValue(forKey: bottomIndex)
            
            let leftIndex = board[index][0]
            indexToCount.removeValue(forKey: leftIndex)
            
            let rightIndex = board[index][self.boardDimension - 1]
            indexToCount.removeValue(forKey: rightIndex)
        }
        
        var maxCount = 0
        var maxIndex = ""
        for index in indexToCount.keys where (indexToCount[index] ?? 0) > maxCount {
            maxCount = (indexToCount[index] ?? 0)
            maxIndex = index
        }
        
        print("Max Area: \(maxCount)")
        print("Max Index: \(maxIndex)")
    }
    
    func distance(from: Coordinate, to: Coordinate) -> Int {
        return abs(from.x - to.x) + abs(from.y - to.y)
    }
}

private class Challenge2: Challenge1 {
    var maxDistance = 10000
    override func run(input: String) {
        let lines = input.split(separator: "\n").map({ String($0) })
        let coordinates = lines.map({ line -> Coordinate in
            var split = line.split(separator: ",")
            let x = split[0]
            var y = split[1]
            y.removeFirst()
            return Coordinate(x: Int(x)!, y: Int(y)!)
        })
        
        var board = [[String]](repeating: [String](repeating: ".", count: 400), count: 400)
        
        for (rowIndex, row) in board.enumerated() {
            for (colIndex, _) in row.enumerated() {
                let indexCoordinate = Coordinate(x: rowIndex, y: colIndex)
                let totalDistance = coordinates.reduce(0, { $0 + self.distance(from: indexCoordinate, to: $1)})
                if totalDistance < self.maxDistance {
                    board[rowIndex][colIndex] = "1"
                }
            }
        }
        
        let count = board.flatMap({ $0 }).filter({ $0 == "1" }).count
        
        print("Area of points < 10000: \(count)")
    }
}
