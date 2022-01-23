//
//  User.swift
//  goraInterviewTask
//
//  Created by Khurshed Umarov on 21.01.2022.
//

import Foundation

/// User structure for response
struct User: Codable{
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

// MARK: - Address
struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

// MARK: - Geo
struct Geo: Codable {
    let lat, lng: String
}

// MARK: - Company
struct Company: Codable {
    let name, catchPhrase, bs: String
}

