//
//  InertialSystem.swift
//  Sensors
//
//  Created by Andreas Kluge on 10.11.23.
//

import SwiftUI

struct InertialSystem: View {
    
    var offSetX: Double
    var offSetY: Double
    var givenColor: Color
    
    var body: some View {
        ZStack{
            //Circle center level
            Circle()
                .fill(givenColor)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100, alignment:.center)
                .opacity(0.2)
            
            Rectangle()
                .fill(givenColor)
                .frame(width: 1, height:20, alignment: .center)
            Rectangle()
                .fill(givenColor)
                .frame(width: 20, height:1, alignment: .center)
        }
        .frame(width: 350,
        height: 370,
               alignment: .center)
        .offset(x: offSetX, y: offSetY)
    }
}

#Preview {
    InertialSystem(offSetX: 0.0, offSetY: 0.0, givenColor: .white)
}
