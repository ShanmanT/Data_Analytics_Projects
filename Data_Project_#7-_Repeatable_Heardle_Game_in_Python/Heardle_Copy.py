# -*- coding: utf-8 -*-
"""
Created on Wed Mar 16 13:53:11 2022

@author: wertm
"""
import os
import time
import random

import spotipy
from spotipy.oauth2 import SpotifyOAuth
from fuzzywuzzy import process

os.environ['SPOTIPY_CLIENT_ID'] = '3b230a2685714412aa4ae9b6c87860a9'
os.environ['SPOTIPY_CLIENT_SECRET'] = '2b784db93ce14a9cad249fd50a24b5a8'
os.environ['SPOTIPY_REDIRECT_URI'] = 'http://127.0.0.1:9090'

scope = 'user-read-currently-playing user-read-playback-state user-modify-playback-state user-library-read streaming'

sp = spotipy.Spotify(auth_manager=SpotifyOAuth(scope=scope))

x = sp.current_playback()

tracksUri = []
songArtistList = []
playlist_uri = '1Pmipj5TBHHW9zDwwTeeo5'

HeardleIntervals = [1,2,4,7,11,16]

for track in sp.playlist_tracks(playlist_uri)["items"]:
    tracksUri.append(track["track"]["uri"])
    songArtistList.append(track["track"]["name"]+ ' - '+track["track"]["artists"][0]["name"])


def searchSongList():
    searchTerm = input("What would you like to search for?: ")
    #Old code without using fuzzy case
    # result = []
    # # for songArtist in songArtistList :
    #     if searchTerm.lower() in songArtist.lower():
    #         result.append(songArtist)
    # for song in result:
    #     print(song)
    results = process.extract(searchTerm.lower(),songArtistList,limit=1000)
    for i in range(len(results)):
        if results[i][1] > 50:
            print(results[i][0])
        else:
            pass

def Heardle(): #Move it around so default is search and rest comes into play
    song = sp.current_playback()['item']['name']
    for i in HeardleIntervals:
        Seek(i)
        y = input("What do you think the track title is?(type search to find list of songs): ")
        if y.lower() == song.lower():
            Congratulations() #The input should be replay for enter or replay and then skip for anything else
            return
        elif y.lower() == 'search':
            searchSongList()
        elif y.lower() == 'skip':
            Failure()
        else:
            print("Oops try again")
    Failure()            
            
    
def Congratulations():
    print("Good job!")
    Current_Track()
    q = input("Would you like another one? ")
    if q.lower() == 'no':
        quit()
    else:
        random.shuffle(tracksUri)
        sp.add_to_queue(tracksUri[0])
        sp.next_track()
        sp.pause_playback()
        Heardle()

def Failure():
    print("Sorry about that")
    Current_Track()
    print("Try Again")
    random.shuffle(tracksUri)
    sp.add_to_queue(tracksUri[0])
    sp.next_track()
    sp.pause_playback()
    Heardle()

def Seek(x, device = '1ed441e74cf729ae48e8c65d205618b62862cbfb'):
    sp.seek_track(0,device_id = device)    
    sp.start_playback()
    time.sleep(x)
    sp.pause_playback()
       
def Current_Track():
    print('Title is '+sp.current_playback()['item']['name'])
    print('Album is '+sp.current_playback()['item']['album']['name'])
    print('Artist is '+sp.current_playback()['item']['artists'][0]['name'])
    print('Time is '+str(sp.current_playback()['progress_ms']/1000)+' seconds')