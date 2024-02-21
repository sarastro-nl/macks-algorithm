import Swift
import Foundation

let dim = 12
var m = Array(repeating: [0], count: dim)
m[0] = [21,16,13,26,17,20,2,22,13,6,2,21]
m[1] = [23,8,7,2,17,1,11,11,11,10,5,27]
m[2] = [14,6,14,10,9,0,3,2,16,25,13,2]
m[3] = [3,15,15,0,18,10,9,17,27,22,21,14]
m[4] = [10,8,14,2,9,17,22,15,0,11,27,24]
m[5] = [15,22,27,27,15,24,26,5,4,18,25,14]
m[6] = [22,4,8,6,16,17,25,18,1,21,18,16]
m[7] = [13,13,20,1,24,19,22,17,11,9,15,12]
m[8] = [19,6,12,2,17,8,27,18,22,23,3,24]
m[9] = [12,23,26,4,13,14,17,22,2,26,13,21]
m[10] = [25,6,11,22,12,0,12,2,21,9,16,2]
m[11] = [12,23,1,2,16,15,27,24,22,22,7,25]
var base = Array(repeating: 0, count: dim)
var u = Array(repeating: 0, count: dim)
var nrOfBases = Array(repeating: 0, count: dim)

func print_m(_ rows: [Int] = [], _ columns: [Int] = [], _ min: (Int, Int)? = nil) {
    var s: String
    for i in 0..<dim {
        for j in 0..<dim {
            s = String(format: "%3d ", m[i][j] + u[j])
            if base[i] == j {
                s = s.red
            } else if let min = min, min.0 == i, min.1 == j {
                s = s.green
            } else if columns.count > 0 && columns.contains(j) {
                s = s.blue
            } else if rows.count > 0 && rows.contains(i) {
                s = s.orange
            }
            print(s, terminator: "")
        }
        print()
    }
    print()
}

func macksalgoritm() {
    for i in 0..<dim {
        base[i] = m[i].firstIndex(of: m[i].min()!)!
        nrOfBases[base[i]] += 1
    }
    print_m()
    var row = -1
    while var column = nrOfBases.firstIndex(where: {$0 > 1}) {
        var rows: [Int] = []
        var columns: [Int] = []
        var alternatives = Array(repeating: -1, count: dim)
        repeat {
            for (key, value) in base.enumerated() where value == column {
                rows.append(key)
            }
            columns.append(column)
            print_m(rows, columns)
            alternatives[column] = row
            var min = Int.max
        zero:
            for i in rows {
                let mbase = m[i][base[i]] + u[base[i]]
                for j in 0..<dim where !columns.contains(j) {
                    let mm = m[i][j] + u[j]
                    if mm - mbase < min {
                        min = mm - mbase
                        row = i
                        column = j
                        if min == 0 { break zero }
                    }
                }
            }
            if min > 0 {
                for j in columns {
                    u[j] += min
                }
            }
            print("columns + \(min)")
            print_m(rows, columns, (row, column))
        } while base.contains(column)
        nrOfBases[column] += 1
        repeat {
            let oldColumn = base[row]
            base[row] = column
            column = oldColumn
            row = alternatives[column]
        } while row > -1
        nrOfBases[column] -= 1
        print("changing bases")
        print_m(rows, columns)
    }
    
    u = Array(repeating: 0, count: dim)
    print("Mack's algorithm solution:")
    print_m()
    var sum = 0
    for i in 0..<dim { sum += m[i][base[i]] }
    print("sum: \(sum)")
    
    print("================")
}

func brute_force() {
    var l = Array(repeating: -1, count: dim)
    var min = Int.max
    var sum = 0

    func brute(_ i: Int = 0) {
        guard i < dim else { base = l; min = sum; return }
        for j in 0..<dim where !l.contains(j) && sum + m[i][j] < min {
            sum += m[i][j]
            l[i] = j
            brute(i + 1)
            l[i] = -1
            sum -= m[i][j]
        }
    }
    
    brute();
    print("brute force solution:")
    print_m()
    print("sum: \(min)")
}

macksalgoritm()
brute_force()
