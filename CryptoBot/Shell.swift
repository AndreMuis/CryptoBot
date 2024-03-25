//
//  Shell.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/25/22.
//

import Foundation

struct Shell {
    func getSignature(text: String) throws -> String {
        guard let byBitAPISecret = AppDefaults.shared.byBitAPISecret else {
            throw AppError.genericError(message: "could not retrieve ByBit API secret key from app defaults")
        }

        let text = text.replacingOccurrences(of: "\"", with: "\\\"")

        let command = "echo -n \"\(text)\" | openssl dgst -sha256 -hmac \(byBitAPISecret)"

        return try self.run(command)
    }

    private func run(_ command: String) throws -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["-c", command]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        try process.run()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        process.waitUntilExit()

        if let output = output, process.terminationStatus == 0 {
            return output.replacingOccurrences(of: "\n", with: "")
        } else {
            throw AppError.genericError(message: "unable to execute shell command: \(command)")
        }
    }
}
