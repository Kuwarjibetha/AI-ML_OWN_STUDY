import speech_recognition as sr
import webbrowser
import pyttsx3  # convert speech into text
import requests
from openai import OpenAI
from gtts import gTTS;
import pygame
import os


recognizer = sr.Recognizer()
engine = pyttsx3.init() 
newsapi = "<Your Key Here>"

def speak_old(text):
    engine.say(text)
    engine.runAndWait()
