//
//  PaginableArray.swift
//
//  Created by Osmely Fernandez on 12/22/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

/**
 Permite llevar un aray de elementos paginados, agregar y evitar duplicados.
 Mantiene el indice actual de pagina segun los ultimos elementos agregados.
 Usarse como source de datos de un TableviewDataSource
 */
protocol PaginableObject : Equatable {
    associatedtype type
    typealias PageIndex = Int
    var data:type { get }
    var page:PageIndex { get }
    init(data:type, page:PageIndex)
}

extension PaginableObject {
    init(_ data: type, page: PageIndex) {
        self.init(data: data, page: page)
    }
}

class PaginableArray<T:PaginableObject> {
    typealias PageIndex = Int
    
    var startPage = 1
    fileprivate(set) var elements = [T]()
    fileprivate(set) var lastPageAdded:Int!
    fileprivate(set) var isLast:Bool = false
    
    init() {
        self.lastPageAdded = self.startPage
        
    }
    
    
    func add(_ objs:[T]) {
        for o in objs {
            if let index = self.elements.firstIndex(of: o) {
                self.elements[index] = o
            }else{
                self.elements.append(o)
            }
        }
        
        if let obj = objs.first {
            lastPageAdded = obj.page
        }else{
            self.isLast = true
        }
        
    }
    
    func element(at index:Int) -> T? {
        if elements.indices.contains(index){
            return elements[index]
        }
        return nil
    }
    
    func object(at index:Int) -> T.type? {
        return self.element(at: index)?.data
    }
    
    func clear() {
        self.elements.removeAll()
        lastPageAdded = startPage
        isLast = false
    }
}
