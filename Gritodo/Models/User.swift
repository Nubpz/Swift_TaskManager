//
//  User.swift
//  Gritodo
//
//  Created by Nabin Poudel on 7/13/24.
//

import Foundation

struct User: Codable{
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval
}
