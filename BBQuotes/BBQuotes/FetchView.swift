//
//  QuoteView.swift
//  BBQuotes
//
//  Created by Tom Molinaro on 10/11/25.
//

import SwiftUI

struct FetchView: View {
    
    // give us access to properties and methods of ViewModel
    let vm = ViewModel()
    // I don't know why this isn't var since it will be changing, no?
    let show: String
    
    @State var showCharacterInfo = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(show.removeCaseAndSpace())
                    .resizable()
                    .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)
                    
                VStack {
                    // Forces the 2 spacers to take up all the space of the parent view, therefore leaving minimal space for the button, and furthermore, pushing the button to the bottom of the screen
                    VStack{
                        Spacer(minLength:60)
                        
                        switch vm.status {
                        case .notStarted:
                            EmptyView()
                            
                        case .fetching:
                            ProgressView()
                            
                        case .successQuote:
                            Text("\"\(vm.quote.quote)\"")
                                // will scale down as much as 50% to make room for excessive text
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius:25))
                                .padding(.horizontal)
                            
                            ZStack(alignment: .bottom) {
                                AsyncImage(url: vm.character.images[0]) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                                
                                Text(vm.quote.character)
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                                    .fontWeight(.bold)
                            }
                            .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                            .clipShape(.rect(cornerRadius: 50))
                            .onTapGesture {
                                showCharacterInfo.toggle()
                            }
                            
                        case .successEpisode:
                            EpisodeView(episode: vm.episode)
                            
                        case .failed(let error):
                            Text(error.localizedDescription)
                        }
                                                
                        Spacer(minLength:20)
                    }
                            
                    HStack {
                        Button {
                            // allows a unit of asyncronous work to run in syncronous environments
                            Task {
                                await vm.getQuoteData(for: show)
                            }
                        } label: {
                            Text("Get Random Quote")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color("\(show.removeSpaces())Button").opacity(0.75))
                                .clipShape(.rect(cornerRadius:10))
                                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 5)
                        }
                        
                        Spacer()
                        
                        Button {
                            // allows a unit of asyncronous work to run in syncronous environments
                            Task {
                                await vm.getEpisode(for: show)
                            }
                        } label: {
                            Text("Get Random Episode")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color("\(show.removeSpaces())Button").opacity(0.75))
                                .clipShape(.rect(cornerRadius:10))
                                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 5)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer(minLength: 95)
                    
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .toolbarBackgroundVisibility(.visible, for: .tabBar)
        .sheet(isPresented: $showCharacterInfo) {
            CharacterView(character: vm.character, show: show)
        }
    }
}

#Preview {
//    QuoteView(show: Constants.bbName)
    FetchView(show: Constants.bcsName)
        .preferredColorScheme(.dark)
}
