//
//  SlideOptionsMenu.swift
//  Chatter
//
//  Created by kotik on 10.05.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import SwiftUI
import UIKit

// боковое меню
struct Menu: View {
    
    var body: some View{

                VStack {
            
            Image("social-media")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.top, 30)
            Divider()
 
                
            Group {
                Button(action: {}) {
                    HStack(spacing: 15){
                        Image("pic_profile")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.pink)
                        
                        Text("Аккаунт")
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(.top, 20)
                }
                
                Button(action: { }) {
                    HStack(spacing: 15){
                        Image("gallery")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.yellow)
                        Text("Галерея")
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(.top, 15)
                }
                
                Button(action: { }) {
                    HStack(spacing: 15){
                        Image("notification")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.purple)
                        Text("Уведомления")
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(.top, 15)
                }
                
                Button(action: { }) {
                    HStack(spacing: 15){
                        Image("help")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.green)
                        Text("Помощь")
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(.top, 15)
                }
                Spacer()
            }
        }
                    
                .foregroundColor(.primary)
                .padding(.horizontal, 20)
                    
                
                .aspectRatio(contentMode: .fit)
                    .frame(width: -UIScreen.main.bounds.width / 1.5, height: UIScreen.main.bounds.height - 50)
                .background((Color.white).edgesIgnoringSafeArea(.all))
                .overlay(Rectangle().stroke(Color.primary.opacity(0.2), lineWidth: 1).shadow(radius: 2).edgesIgnoringSafeArea(.all))
                }
            }

