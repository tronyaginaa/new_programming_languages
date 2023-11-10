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
        task()
        print("Thread \(Thread.current) finished")
        waiter.leave()
    }
    func task() {
        result = getC(a, b)
    }
    func join() {
        waiter.wait()
    }
    
}

func getC(_ a: Vector, _ b: Vector)->Double{
    var res = 0.0
    for i in 0..<a.count{
        res += a[i] * b[i]
    }
    return res
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


var matrixA = Matrix()
matrixA += [[1, 2], [4, 6], [3, 5]]
print(matrixA)

var matrixB = Matrix()
matrixB += [[2, 3, 2], [1, 5, 2]]
print(matrixB)

var matrixC = matrixMultiplication(matrixA, matrixB)
print(matrixC)

