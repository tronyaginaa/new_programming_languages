//
//  main.swift
//  Swift-Multithreading
//
//  Created by Alexandra on 21.10.2023.
//

import Foundation

typealias Matrix = [[Double]]
typealias Vector = [Double]

class multiplierThread : Thread{
    let waiter = DispatchGroup()
    let a:Vector
    let b:Vector
    let rowInd:Int
    let colInd:Int
    var result:Double = 0
    init(_ _a: Vector,
         _ _b: Vector,
         _ _rowInd: Int,
         _ _colInd: Int) {
        a = _a
        b = _b
        rowInd = _rowInd
        colInd = _colInd
    }
    override func start() {
        waiter.enter()
        super.start()
        
    }
    override func main() {
        print("Thread started")
        task()
        print("Thread finished. Result of calculating : \(result)")
        waiter.leave()
    }
    func task() {
        result = calculateCell(a, b)
    }
    func join() {
        waiter.wait()
    }
    func calculateCell(_ a: Vector, _ b: Vector)->Double{
        var res = 0.0
        for i in 0..<a.count{
            res += a[i] * b[i]
        }
        return res
    }
}

func MatrixTransposition(_ A: Matrix) -> Matrix{
    var transposedMatrix = Array(repeating: [Double](), count: A[0].count)
    for i in A.indices{
        for j in A[i].indices{
            transposedMatrix[j] += [A[i][j]]
        }
    }
    return transposedMatrix
}

func matrixMultiplication(_ A: Matrix, _ B: Matrix)->Matrix{
    var resultMatrix = Array(repeating: Array(repeating: 0.0, count: B[0].count), count: A.count)
    var threadArr = [multiplierThread]()
    let B = MatrixTransposition(B)
    var cell = 0
    for i in A.indices{
        for j in B.indices{
            threadArr.append(multiplierThread(A[i], B[j], i, j))
            threadArr[cell].start()
            cell += 1
        }
    }
    for thread in threadArr{
        thread.join()
        resultMatrix[thread.rowInd][thread.colInd] = thread.result
    }
    return resultMatrix
}

func matrixToString(_ matrix:Matrix, _ string: inout String){
    for rows in matrix {
        string += rows.map{String($0)}.joined(separator: " ")
        string += "\n"
    }
}

func generateRandomMatrix(_ rowCount: Int, _ columnCount: Int)->Matrix{
    var matrix = Matrix()
    for i in 0..<rowCount{
        matrix += [[]]
        for _ in 0..<columnCount{
            matrix[i] += [Double.random(in: -10...10)]
        }
    }
    return matrix
}

let MATRIX_A_ROW_COUNT = 2
let MATRIX_A_COLUMN_COUNT = 5
let MATRIX_B_ROW_COUNT = MATRIX_A_COLUMN_COUNT
let MATRIX_B_COLUMN_COUNT = 2

var matrixA = generateRandomMatrix(MATRIX_A_ROW_COUNT, MATRIX_A_COLUMN_COUNT)
var matrixB = generateRandomMatrix(MATRIX_B_ROW_COUNT, MATRIX_B_COLUMN_COUNT)
var matrixC = matrixMultiplication(matrixA, matrixB)

var outputString = "A:\n"
matrixToString(matrixA, &outputString)
outputString += "B:\n"
matrixToString(matrixB, &outputString)
outputString += "C:\n"
matrixToString(matrixC, &outputString)

let file = "MatrixMultiplication.txt"
if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
    let path = dir.appendingPathComponent(file)
    do {
            try outputString.write(to: path, atomically: false, encoding: String.Encoding.utf8)
        }
    catch {}
}


/*
Test matrixes
Expected multiplication result:
4 13 6
14 42 20
11 34 16
*/
matrixA = [[1, 2], [4, 6], [3, 5]]
matrixB = [[2, 3, 2], [1, 5, 2]]
matrixC = matrixMultiplication(matrixA, matrixB)

outputString = "A:\n"
matrixToString(matrixA, &outputString)
outputString += "B:\n"
matrixToString(matrixB, &outputString)
outputString += "C:\n"
matrixToString(matrixC, &outputString)

print(outputString)
