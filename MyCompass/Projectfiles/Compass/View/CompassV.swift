//
//  Compass.swift
//  Sensors
//
//  Created by Andreas Kluge on 09.11.23.
//

import SwiftUI

struct CompassV: View {
    
    
    
    let radius: CGFloat                 = 125
    let pi                              = Double.pi
    
    
    let dotCountMainCircle              = 180
    var spaceLengthMainCircle: CGFloat  = 0.0
    let dotLengthMainCircle: CGFloat    = 1.0
    
    var spaceLengthDegrees: CGFloat     = 0.0
    let dotCountDegrees                 = 12
    let dotLengthDegrees: CGFloat       = 2.0
    
    
    
    let degreeText: [Int] = [0,30,60,90,120,150,180,210,240,270,300,330]
    
    let directionText: [String] = ["N","E","S","W"]
    
    let rotationDegree: Double
    
    let color: Color
    
    init(givenRoatationDegree: Double, givenColor: Color){
        
        let circumerenceDegrees: CGFloat = CGFloat(2.0 * pi) * radius
        spaceLengthDegrees = circumerenceDegrees / CGFloat(dotCountDegrees) - dotLengthDegrees
        
        let circumerenceMainCircle: CGFloat = CGFloat(2.0 * pi) * radius
        spaceLengthMainCircle = circumerenceMainCircle / CGFloat(dotCountMainCircle) - dotLengthMainCircle
         
        self.rotationDegree = givenRoatationDegree
        self.color          = givenColor
    }
    
    var body: some View {
        
        ZStack{ // The rotating compass
            
            //Non moving parts
            //The centre lines
            let thickness   = 0.5
            let length      = 150.0
            Rectangle()//vertical
                .fill(color)
                .frame(width: thickness, height: length, alignment: .center)
            Rectangle() //horizontal
                .fill(color)
                .frame(width: length, height: thickness, alignment: .center)
            Rectangle()//Zero Marker Top
                .fill(color)
                .frame(width: 4.0, height: 70, alignment: .center)
                .padding(.bottom, 300)
                .padding(.leading, 0)
            
            
            ZStack{//ZStack Rotating Parts
                
                
                //Red Triangle
                GeometryReader { geometry in
                    Path { path in
                        let centerx = geometry.size.width/2 + 0.75
                        //let centery = geometry.size.height/2
                        
                        path.move(to: CGPoint(x: centerx, y: 35)) //oben anfangen
                        path.addLine(to: CGPoint(x: centerx - 5, y: 45))//links
                        path.addLine(to: CGPoint(x: centerx + 5, y: 45))//rechts
                        path.addLine(to: CGPoint(x: centerx, y: 35))//oben
                    }
                    .fill(.red)
                }
                
                //The fine detailled dashes
                Circle()
                    .stroke(color, style: StrokeStyle(lineWidth: 20, lineCap: .butt, lineJoin: .miter, miterLimit: 0, dash: [dotLengthMainCircle, spaceLengthMainCircle], dashPhase: 1.5))
                    .frame(width: radius * 2, height: radius * 2)
                
                
                //The segment 30 degree dashes
                Circle()
                    .stroke(color, style: StrokeStyle(lineWidth: 20, lineCap: .butt, lineJoin: .miter, miterLimit: 0, dash: [dotLengthDegrees, spaceLengthDegrees], dashPhase: 2))
                    .frame(width: radius * 2, height: radius * 2)
                    //.rotationEffect(.degrees(rotationDegree), anchor: .center)
                
                
                //The Degree numbers around the circle
                ForEach(0..<12) { degree in
                    DegreeNumbers(degree: degree,
                                  degreeRaw:  degreeText[degree],
                                  rotation: rotationDegree,
                                  color: color)
                    
                }
                //The cardinal point in letters
                ForEach(0..<4) { direction in
                    DirectionText(direction: direction,
                                  directionText: directionText[direction],
                                  rotation: rotationDegree,
                                  color: color)
                }
                
            }//ZStack Moving Parts
            .rotationEffect(.degrees(rotationDegree))
            
        }//ZStack
        .frame(width: 350,
               height: 370,
               alignment: .center)
        .background(.black)
    }
}


struct DegreeNumbers: View{
    
    var degree: Int
    var degreeRaw: Int
    var rotation: Double
    var color: Color
    
    var body: some View{
        VStack{
            HStack{
                Text("\(degreeRaw)")
                    .foregroundStyle(color)
                    .rotationEffect(.radians(-(Double.pi*2 / 12 * Double(degree))))
            }
            .rotationEffect(Angle(degrees: -rotation))
            Spacer()
        }
        .padding()
        .rotationEffect(.radians( (Double.pi*2 / 12 * Double(degree))))
    }
}

struct DirectionText: View{
    
    var direction: Int
    var directionText: String
    var rotation: Double
    var color: Color
    
    var body: some View{
        VStack{
            HStack{
                Text(directionText)
                    .font(.title)
                    .foregroundStyle(color)
                    .rotationEffect(.radians(-(Double.pi*2 / 4 * Double(direction))))
            }
            .rotationEffect(Angle(degrees: -rotation))
            Spacer()
        }
        .padding(.top, 75)
        .rotationEffect(.radians( (Double.pi*2 / 4 * Double(direction))))
    }
}

#Preview {
    CompassV(givenRoatationDegree: 0.0, givenColor: .white)
}
