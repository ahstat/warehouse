#!/home/alexis/tensorflow/bin/python3
# -*-coding:utf-8 -*

# Execute it using: python3 bissextile.py

# Programme testant si une annee, saisie par l'utilisateur, est bissextile ou non

annee = input("Saisissez une année : ") # On attend que l'utilisateur fournisse l'annee qu'il désire tester
annee = int(annee) # Risque d'erreur si l'utilisateur n'a pas saisi un nombre

if annee % 400 == 0 or (annee % 4 == 0 and annee % 100 != 0):
    print("L'année saisie est bissextile.")
else:
    print("L'année saisie n'est pas bissextile.")
    
    