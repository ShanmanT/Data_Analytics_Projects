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

os.environ['SPOTIPY_CLIENT_ID'] = '3b230a2685714412aa4ae9b6c87860a9'
os.environ['SPOTIPY_CLIENT_SECRET'] = 'Insert Client Secret'
os.environ['SPOTIPY_REDIRECT_URI'] = 'http://127.0.0.1:9090'

scope = 'user-read-currently-playing user-read-playback-state user-modify-playback-state user-library-read streaming'

sp = spotipy.Spotify(auth_manager=SpotifyOAuth(scope=scope))

x = sp.current_playback()

tracks = []
playlist_uri = '1Pmipj5TBHHW9zDwwTeeo5'

for track in sp.playlist_tracks(playlist_uri)["items"]:
    tracks.append(track["track"]["uri"])

def Heardle():
    Seek(1)
    y = input("What do you think the track title is?: ")
    if y == sp.current_playback()['item']['name']:
        Congratulations()
    else:
        Seek(2)
        y = input("What do you think the track title is?: ")
        if y == sp.current_playback()['item']['name']:
            Congratulations()
        else:
            Seek(4)
            y = input("What do you think the track title is?: ")
            if y == sp.current_playback()['item']['name']:
                Congratulations()
            else:
                Seek(7)
                y = input("What do you think the track title is?: ")
                if y == sp.current_playback()['item']['name']:
                    Congratulations()
                else:
                    Seek(11)
                    y = input("What do you think the track title is?: ")
                    if y == sp.current_playback()['item']['name']:
                        Congratulations()
                    else: 
                        Seek(16)
                        y = input("What do you think the track title is?: ")
                        if y == sp.current_playback()['item']['name']:
                            Congratulations()
                        else:                            
                            Failure()

def Congratulations():
    print("Good job!")
    Current_Track()
    q = input("Would you like another one? ")
    if q == 'no':
        quit()
    else:
        random.shuffle(tracks)
        sp.add_to_queue(tracks[0])
        sp.next_track()
        sp.pause_playback()
        Heardle()

def Failure():
    print("Sorry the song was " + sp.current_playback()['item']['name'] + " Try Again")
    random.shuffle(tracks)
    sp.add_to_queue(tracks[0])
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