//
//  TitlePageView.swift
//  CYOATemplate
//
//  Created by Nathan on 2023-06-10.
//

import SwiftUI
import RetroText

struct TitlePageView: View {
    
    @Binding var retroGameFontActive: Bool
    
    @State private var showingPopover = false
    
    @State var selection: Int? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                if retroGameFontActive == true {
                    Color(.systemCyan)
                        .ignoresSafeArea()
                } else {
                    Color(.systemGreen)
                        .ignoresSafeArea()
                }
                
                
                VStack {
                    HStack {
                        
                        Spacer()
                        
                        Label(title: {
                            Text("")
                            //                        Text("Settings")
                            
                        }, icon: {
                            Image(systemName: "gearshape.2")
                            
                        })
                        .padding(.trailing)
                        .onTapGesture {
                            showingPopover = true
                        }
                        .popover(isPresented: $showingPopover) {
                            HStack {
                                
                                VStack {
                                    HStack {
                                        Text("Retro Mode")
                                            .padding()
                                        Toggle("", isOn: $retroGameFontActive)
                                            .padding()
                                    }
                                    Spacer()
                                }
                                
                                Spacer()
                                
                                VStack {
                                    Button(action: {
                                        showingPopover = false
                                    }, label: {
                                        Label(title: {
                                            Text("Back")
                                        }, icon: {
                                            Image(systemName: "arrowshape.turn.up.backward")
                                        })
                                        .foregroundColor(.blue)
                                        .padding()
                                    })
                                    
                                    Spacer()
                                    
                                }
                                
                            }
                        }
                        .padding()
                    }
                    
                    Text("Bouhadja.")
                        .retroFont(.pixelEmulator, size: 45)
                        .padding(.top, 200)
                        .foregroundColor(Color(.brown))
                    Text("By: Nathan & Jacobo")
                        .retroFont(.pixelEmulator, size: 18)
                        .foregroundColor(Color(.brown))
                        .padding(.bottom)
                    
                    NavigationLink(destination: GameView(retroGameFontActive: $retroGameFontActive).navigationBarBackButtonHidden(true), tag: 1, selection: $selection) {
                        Button(action: {
                            self.selection = 1
                        }, label: {
                            Text("Enter")
                                .foregroundColor(.brown)
                        })
                        .buttonStyle(.bordered)
                    }
                    
                    .padding(.top)
                    
                    Spacer()
                }
            }
        }
    }
}

struct TitlePageView_Previews: PreviewProvider {
    static var previews: some View {
        TitlePageView(retroGameFontActive: .constant(false))
    }
}
