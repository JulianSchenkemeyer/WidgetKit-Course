//
//  Image+Ext.swift
//  BasketballSim
//
//  Created by Sean Allen on 11/6/22.
//

import SwiftUI

extension Image {

    func teamLogoModifier(frame: CGFloat? = nil) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: frame, height: frame)
    }
}
