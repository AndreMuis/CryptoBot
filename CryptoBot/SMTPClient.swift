//
//  SMTPClient.swift
//  CryptoBot
//
//  Created by Andre Muis on 4/24/22.
//

import Combine
import Foundation

import SwiftSMTP

struct SMTPClient {
    func sendEmail(subject: String, text: String) -> Future<Void, Error> {
        let future = Future<Void, Error> { promise in
            do {
                guard let hostname = AppDefaults.shared.smtpServerHostname else {
                    throw AppError.genericError(message: "unable to retrieve SMTP server hostname from app defaults")
                }

                guard let email = AppDefaults.shared.smtpServerEmail else {
                    throw AppError.genericError(message: "unable to retrieve SMTP server email from app defaults")
                }

                guard let password = AppDefaults.shared.smtpServerPassword else {
                    throw AppError.genericError(message: "unable to retrieve SMTP server password from app defaults")
                }

                let smtp = SMTP(hostname: hostname, email: email, password: password)

                let userFrom = Mail.User(email: Constants.fromEmail)
                let userTo = Mail.User(email: email)

                let mail = Mail(
                    from: userFrom,
                    to: [userTo],
                    subject: "Crypto Bot: \(subject)",
                    text: text
                )

                smtp.send(mail) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }

        return future
    }
}
