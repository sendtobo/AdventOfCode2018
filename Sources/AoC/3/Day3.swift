class Day3: Day {
    var challenges: [Challenge] = [Challenge1(), Challenge2()]
    required init() { }
}

private struct Point {
    var x: Int
    var y: Int
}

private struct Rectangle {
    var id: String
    var leftEdge: Int
    var topEdge: Int
    var width: Int
    var height: Int
}

private class Challenge1: Challenge {
    fileprivate let arrSize = 1000
    func run(input: String) {
        let rects = input.split(separator: "\n").map({ self.createRect(from: String($0)) })
        var canvas = [[Int]]()
        for _ in 1...self.arrSize {
            let arr = [Int](repeating: 0, count: self.arrSize)
            canvas.append(arr)
        }
        rects.forEach({ self.plot(rect: $0, in: &canvas) })
        var overlappingSquares = 0
        for line in canvas {
            for number in line where number == 2 {
                overlappingSquares += 1
            }
        }
        print("Overlapping Squares: \(overlappingSquares)")
    }
    
    func plot(rect: Rectangle, in canvas: inout [[Int]]) {
        for y in rect.topEdge..<(rect.topEdge + rect.height) {
            for x in rect.leftEdge..<(rect.leftEdge + rect.width) {
                let point = Point(x: x, y: y)
                self.plot(point: point, in: &canvas)
            }
        }
    }
    
    func plot(point: Point, in canvas: inout [[Int]]) {
        if canvas[point.y][point.x] >= 1 {
            canvas[point.y][point.x] = 2
        } else {
            canvas[point.y][point.x] = 1
        }
    }
    
    func createRect(from string: String) -> Rectangle {
        //force unwrapping because I know the input
        let spacedTokens = string.split(separator: " ").map({ String($0) })
        var id = spacedTokens[0]
        id.removeFirst()
        var edges = spacedTokens[2]
        edges.removeLast()
        let edgesSplit = edges.split(separator: ",")
        let leftEdge = Int(edgesSplit[0])!
        let topEdge = Int(edgesSplit[1])!
        let dimentionsSplit = spacedTokens[3].split(separator: "x")
        let width = Int(dimentionsSplit[0])!
        let height = Int(dimentionsSplit[1])!
        let rect = Rectangle(id: id, leftEdge: leftEdge, topEdge: topEdge, width: width, height: height)
        return rect
    }
}

private class Challenge2: Challenge1 {
    override func run(input: String) {
        let rects = input.split(separator: "\n").map({ self.createRect(from: String($0)) })
        var canvas = [[Int]]()
        for _ in 1...self.arrSize {
            let arr = [Int].init(repeating: 0, count: self.arrSize)
            canvas.append(arr)
        }
        rects.forEach({ self.plot(rect: $0, in: &canvas) })
        var overlapping = false
        for rect in rects {
            for y in rect.topEdge...(rect.topEdge + rect.height - 1) {
                for x in rect.leftEdge...(rect.leftEdge + rect.width - 1) where canvas[y][x] == 2 {
                    overlapping = true
                }
            }
            if !overlapping {
                print("Not Overlapping Rect \(rect.id)")
            }
            overlapping = false
        }
    }
}
