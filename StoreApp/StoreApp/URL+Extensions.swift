//
//  URL+Extensions.swift
//  StoreApp
//
//  Created by Vladimir Fibe on 2/10/23.
//

import Foundation

extension URL {
    static var development: URL {
        URL(string: "https://api.escuelajs.co/")!
    }
    
    static var production: URL {
        URL(string: "https://production.api.escuelajs.co/")!
    }
    
    static var `default`: URL {
        #if DEBUG
        return development
        #else
        return production
        #endif
    }
    
    static var allCategories: URL {
        URL(string: "/api/v1/categories", relativeTo: Self.default)!
    }
    
    static func productsByCategory(_ id: Int) -> URL {
        URL(string: "/api/v1/categories/\(id)/products", relativeTo: Self.default)!
    }
    
    static var createProduct: URL {
        URL(string: "/api/v1/products/", relativeTo: Self.default)!
    }
    
    static func deletetProduct(_ productId: Int) -> URL {
        URL(string: "/api/v1/products/\(productId)", relativeTo: Self.default)!
    }
}
