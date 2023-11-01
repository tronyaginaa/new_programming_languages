//
//  main.swift
//  Swift-Multithreading
//
//  Created by Alexandra on 21.10.2023.
//

import Foundation

typealias Matrix = [[Int]]
typealias Vector = [Int]

func getC(_ a: Vector, _ b: Vector)->Int{
    var res = 0
    for i in 0..<a.count{
        res += a[i] * b[i]
    }
    return res
}

func squareMatrixTransposition(_ A: Matrix) -> Matrix{//
    var transposedMatrix = Array(repeating: [Int](), count: A[0].count)
    for i in A.indices{
        for j in A[i].indices{
            transposedMatrix[j] += [A[i][j]]
        }
    }
    return transposedMatrix
}

var cDictionary = [Int: (Int,Int)]()

func matrixMultiplication(_ A: Matrix, _ B: Matrix)->Matrix{
    var C = Matrix()
    let B = squareMatrixTransposition(B)
    for i in A.indices{
        C += [[]]
        for j in B.indices{
            C[i] += [getC(A[i], B[j])]
        }
    }
    return C
}


var matrixA = Matrix()
matrixA += [[1, 2], [4, 6], [3, 5]]
print(matrixA)

var matrixB = Matrix()
matrixB += [[2, 3, 2], [1, 5, 2]]
print(matrixB)

var matrixC = matrixMultiplication(matrixA, matrixB)
print(matrixC)

