# -*- coding: utf-8 -*-
"""
Created on Wed Mar 30 17:37:08 2022

@author: wertm
"""

from fastapi import FastAPI
from Heardle_Copy import Heardle

app = FastAPI()

@app.get('/')
async def root():
    return {'message':'Hello World'}

@app.get('/test')
async def root2():
    return {'message':'pee pee poo poo check'}

@app.get('/Heardle')
def Heardle_Copy():
    Heardle()  