//
//  NSSearchPlainNoteDelegate.swift
//  wenote-ios
//
//  Created by Yan Cheng Cheok on 21/02/2022.
//

import Foundation

protocol NSSearchedPlainNotesDelegate {
    var searchedString: String? { get }
    
    func update(nsPlainNotes: [NSPlainNote])
}
