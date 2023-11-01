//
//  CustomError.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/23/22.
//

import Foundation

enum AppError: Error {
    case generic(String, String, Int, String)

    static func genericError(filePath: String = #file,
                             functionName: String = #function,
                             lineNumber: Int = #line,
                             message: String) -> AppError {
        let filename = URL(string: filePath)?.lastPathComponent ?? filePath

        return AppError.generic(filename, functionName, lineNumber, message)
    }
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .generic(let filename, let functionName, let lineNumber, let message):
            return "\(filename): \(functionName)(\(lineNumber)): \(message)"
        }
    }
}
