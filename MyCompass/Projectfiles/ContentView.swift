//
//  ContentView.swift
//  Sensors
//
//  Created by Andreas Kluge on 08.11.23.
//

import SwiftUI

struct ContentView: View {
    

    enum Theme: String, Identifiable{
        case white, red, blue, cyan, teal, yellow, purple, green
        var id: Self { self }
        func color() -> Color{
            switch self{
            case .white:
                return Color.white
            case .red:
                return Color.red
            case .blue:
                return Color.blue
            case .cyan:
                return Color.cyan
            case .teal:
                return Color.teal
            case .yellow:
                return Color.yellow
            case .purple:
                return Color.purple
            case .green:
                return Color.green
            }
        }
        
        func description() -> String{
            switch self{
            case .white:
                return "White"
            case .red:
                return "Red"
            case .blue:
                return "Blue"
            case .cyan:
                return "Cyan"
            case .teal:
                return "Teal"
            case .yellow:
                return "Yellow"
            case .purple:
                return "Purple"
            case .green:
                return "Green"
            }
        }
    }
    private var themesList: [Theme] = [.white, .red, .blue, .cyan, .teal, .yellow, .purple, .green]
    
    @State private var dayMode: Bool = true
    
    @AppStorage("ThemeColorDay") private var themeColorDay: Theme = .white
    @AppStorage("ThemeColorNight") private var themeColorNight: Theme = .red
    
    
    @StateObject var contentViewModel: ContenViewModel = ContenViewModel()
    
    var body: some View {
        VStack {
            Spacer(minLength: 100)


            ZStack{
                CompassV(givenRoatationDegree: contentViewModel.headingDM,
                         givenColor: dayMode ? themeColorDay.color() : themeColorNight.color())
                
                
                InertialSystem( offSetX: contentViewModel.trimX,
                                offSetY: contentViewModel.trimY,
                                givenColor: dayMode ? themeColorDay.color() : themeColorNight.color())
                 
            }
            
            
            HStack{ // The degree of heading
                
                
                HStack{
                    Spacer()
                    Text("\((Int)(contentViewModel.headingDM * -1))°")
                        .foregroundStyle(dayMode ? themeColorDay.color() : themeColorNight.color())
                        .font(.system(size: 70, weight:.thin))
                        .frame(maxWidth: .infinity ,alignment: .trailing)
                }
                
                
                HStack{//Northing,Easting, City, State
                 
                    Text(contentViewModel.headingText)
                        .foregroundStyle(dayMode ? themeColorDay.color() : themeColorNight.color())
                        .font(.system(size: 70, weight:.thin))
                       
                     
                    Spacer()
                }
                
            }
            .frame(maxWidth: 350,
                   maxHeight: 120)
            
            Spacer()
            
            VStack{
                HStack{
                    //37°19'20'' N
                    Text(contentViewModel.latitudeText)
                        .foregroundStyle(dayMode ? themeColorDay.color() : themeColorNight.color())
                        .font(.title3)
                    //122°1'40'' W
                    Text(contentViewModel.longitudeText)
                        .foregroundStyle(dayMode ? themeColorDay.color() : themeColorNight.color())
                        .font(.title3)
                }
                HStack{
                    Text(contentViewModel.address)
                        .foregroundStyle(dayMode ? themeColorDay.color() : themeColorNight.color())
                        .font(.title3)
                }

                HStack{
                    Text(contentViewModel.city)
                        .foregroundStyle(dayMode ? themeColorDay.color() : themeColorNight.color())
                        .font(.title3)
                    
                    Text(contentViewModel.state)
                        .foregroundStyle(dayMode ? themeColorDay.color() : themeColorNight.color())
                        .font(.title3)
                }

            
                Text("\((Int)(contentViewModel.altitude)) m Höhe")
                    .foregroundStyle(dayMode ? themeColorDay.color() : themeColorNight.color())
                    .font(.title3)
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        dayMode.toggle()
                    }, label: {
                        
                        if(dayMode){
                            
                            ZStack{
                                HStack{
                                    Text(LocalizedStringKey("Nightmode"))
                                        .foregroundStyle(dayMode ? themeColorDay.color() : themeColorNight.color())
                                }
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                    .stroke(dayMode ? themeColorDay.color() : themeColorNight.color())
                                    .frame(width: 150,height:30, alignment: .center)
                                
                                
                            }

                        }
                        else{
                            ZStack{
                                Text(LocalizedStringKey("Daymode"))
                                    .foregroundStyle(dayMode ? themeColorDay.color() : themeColorNight.color())
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                    .stroke(dayMode ? themeColorDay.color() : themeColorNight.color())
                                    .frame(width: 150,height:30, alignment: .center)
                                
                                
                            }
                        }
                    })
                    
                    Picker("ThemeColor: ", selection: dayMode ? $themeColorDay : $themeColorNight){
                        ForEach(themesList){ theme in
                            Text(theme.description()).tag(theme.color())
                        }
                    }
                    .tint(dayMode ? themeColorDay.color() : themeColorNight.color())
                    .labelsHidden()
                    .padding(.trailing,30)
                    
                    
                }.padding(.bottom, 30)
                
            }
            
            Spacer()
            
            
        }
        .scaledToFill()
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .center)
        .background(.black)
        .environmentObject(contentViewModel)
    }

}

#Preview {
    ContentView()
}


