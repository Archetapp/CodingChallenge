//
//  ProfilePage.swift
//  CodingChallenge
//
//  Created by Jared on 11/2/20.
//

import Foundation
import SwiftUI
import UIKit


let token = "ri_RkWxwnhPidepEo1xWm_ZcoPA5YW6E_jE9OcNUMeo"

struct SearchingView : View, ButtonProtocol{

    
    // MARK: -Called When the Button is Pressed
    func sendAction() {
        self.photos.currentPage = 1
        self.photos.search()
    }
    
    // MARK: - For Searching and storing photos.results.
    @ObservedObject var photos = PhotosObject()
    
    // MARK: - Used for animation
    @Namespace var namespace
    @State var currentIndex = Int()
    @State var selectedResult = Result()
    @State var currentResultImage = String()
    @State var isSelected : Bool = false
    @State var show : Bool = false
    @State var currentResultHeight : Double = 0
    @State var currentResultWidth : Double = 0

    // MARK: - Setting up the Lazy Grid.
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body : some View {
            ZStack {
                GeometryReader {
                    geometry in
                    ScrollView {
                        VStack {
                            HStack {
                                Text("Unsplash").font(.largeTitle).bold()
                                Spacer()
                            }.padding(20)
                            HStack {
                                ZStack {
                                    // MARK: - Search Bar
                                    Color.black
                                    SearchTextField(photos: self.photos, text: self.$photos.searchText, placeholder: Text("Search a topic...")
                                        .foregroundColor(Color.white.opacity(0.7)))
                                        .padding(.horizontal, 20)
                                }.frame(height: 40, alignment: .center).animation(nil).cornerRadius(20).shadow(radius: 5).animation(.spring(response: 0.4, dampingFraction: 0.8))
                                // MARK: -Search Button
                                ButtonWithAnimation(text: "Search", delegate: self)
                            }.padding()
                            if photos.results.count > 0 {
                                // MARK: - Shows the Search Results
                                    LazyVGrid(columns: gridItemLayout, alignment: .center, spacing: nil, content: {
                                        ForEach(photos.results.enumeratedArray(), id: \.offset, content: {
                                            index, value in
                                            VStack {
                                                RemoteImage(url: URL(string: photos.results[index].urls.small)!, placeholder: {Color.gray.opacity(0.5)}, image:{Image(uiImage: $0).resizable()})
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width : photos.results[index].isSelected ? geometry.size.width : (geometry.size.width / 2) - 20, height: (geometry.size.width / 2) - 20, alignment: .center)
                                                    .animation(nil)
                                                    .cornerRadius(20)
                                                    .clipped()
                                                    .shadow(radius: 5)
                                            }
                                            .matchedGeometryEffect(id: value.id, in: namespace, properties: .frame, isSource: value.isSelected)
                                            .zIndex(photos.results[index].index)
                                            .onTapGesture {
                                                currentIndex = index
                                                currentResultImage = photos.results[index].urls.regular
                                                selectedResult = photos.results[index]
                                                isSelected = true
                                                currentResultWidth = photos.results[index].width
                                                currentResultHeight = photos.results[index].height
                                                photos.results[index].index = 1.0
                                            }.onAppear() {
                                                if index == photos.results.count - 2 {
                                                    self.photos.loadNextPage()
                                                }
                                            }.animation(.spring(response: 0.4, dampingFraction: 0.8))
                                        })
                                    }).padding()
                            } else {
                                // MARK: - Shown if nothing is in the photos.
                                Text("Nothing to show.").bold()
                            }
                        }
                    }
                }
                fullScreenView.edgesIgnoringSafeArea(.all)
        }
    }
    
    // MARK: - Close the Full Screen when the x is pressed.
    func closeFullScreen() {
        self.selectedResult = Result()
        self.isSelected = false
    }
    
    
    // MARK: - Full Screen View - Called when you click on an image
    var fullScreenView : some View {
        ZStack {
            Color.white
            GeometryReader {
                reader in
                ScrollView {
                    VStack {
                        Color.white.frame(height: 50, alignment: .center)
                        VStack {
                            if self.selectedResult.id != "" {
                                RemoteImage(url: URL(string: currentResultImage)!, placeholder: {Color.gray.opacity(0.5)}, image:{Image(uiImage: $0).resizable()})
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: reader.size.width * CGFloat(currentResultHeight / currentResultWidth), alignment: .center)
                                    .cornerRadius(20)
                                    .clipped()
                                    .shadow(radius: 5.0).padding(20).zIndex(1)
                                    .onAppear() {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            show = true
                                        }
                                    }.onDisappear() {
                                        show = false
                                        photos.results[currentIndex].index =  -1.0
                                    }
                            }
                            if show {
                                VStack {
                                    InfoView(postData: self.selectedResult)
                                }.offset(y: show ? 0 : -100)
                                .opacity(show ? 1 : 0)
                                .zIndex(0)
                                .animation(.spring())
                            }
                            
                        }.padding()
                    }
                    .animation(nil)
                    .matchedGeometryEffect(id: selectedResult.id, in: namespace, properties: .frame, isSource: isSelected)
                            .animation(.spring(response: 0.4, dampingFraction: 0.8))
                
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8))
                .background(
                    Color.white
                        .frame(width: reader.size.width, height: reader.size.height, alignment: .center)
                        .opacity(isSelected ? 1 : 0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8))
                        .edgesIgnoringSafeArea(.all)
                )
                .frame(width: reader.size.width)
                        .animation(nil)
                        .zIndex(1)
            }.padding()
            VStack {
                HStack {
                    Spacer()
                    Button(action: self.closeFullScreen, label: {
                        Image(systemName: "xmark.circle.fill").resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                            .rotationEffect( isSelected ? Angle.init(degrees: 0) : Angle.init(degrees: 90)).animation(.spring())
                    }).foregroundColor(.black)
                }
                Spacer()
            }.padding(EdgeInsets(top: 50, leading: 10, bottom: 10, trailing: 10))
        }
        .opacity(isSelected ? 1.0 : 0)
        .animation(.spring(response: 0.4, dampingFraction: 0.8))
    }
}
