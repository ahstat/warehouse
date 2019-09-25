##
# Chapter 1: Introduction
##

##
# Chapter 2: Calculus
##
3.11 + 2.08 # given result is 5.1899999999999995
10 // 3 # 3, which is the floor of the result
10 % 3 # 1, which is the remainder of the result

##
# Chapter 3: Variables
##
a = 5
b = 32
a,b = b,a # permutation
type(a)
print("a =", a, "and b =", b)

##
# Chapter 4: if/else
##
a = 8
if a > 0:
    print("a greater than 0")
elif a < 0:
    print("a lower than 0")
else:
    print("a is zero")

# Additional commands: and, or, not
if a > 0 and a < 100:
    print("a is in the interval")
else:
    print("a is outside the interval")

##
# Chapter 5: Loops
##
nb = 7
i = 0 # variable to increment
while i < 10:
    print(i + 1, "*", nb, "=", (i + 1) * nb)
    i += 1

chaine = "Bonjour les ZER0S"
for lettre in chaine:
    print(lettre)

# break
while 1: # 1 est toujours vrai -> boucle infinie
    lettre = input("Tapez 'Q' pour quitter : ")
    if lettre == "Q":
        print("Fin de la boucle")
        break
    
# continue
i = 1
while i < 20: # Tant que i est inferieure a 20
    if i % 3 == 0:
        i += 4 # On ajoute 4 a i
        print("On incrémente i de 4. i est maintenant égale à", i)
        continue # On retourne au while sans executer les autres lignes
    print("La variable i =", i)
    i += 1 # Dans le cas classique on ajoute juste 1 a i

##
# Chapter 6: Using Modules
##
def table(nb, max=10):
    """Fonction affichant la table de multiplication par nb
    de 1*nb à max*nb
    
    (max >= 0)"""
    i = 0
    while i < max:
        print(i + 1, "*", nb, "=", (i + 1) * nb)
        i += 1
        
help(table)
    
def carre(valeur):
    return valeur * valeur
    
# lambda function:
f = lambda x: x * x
f(5)

import math
help("math")
help("math.sqrt")
math.sqrt(16)
import math as mathematiques
from math import fabs
fabs(-5)
from math import *

##
# Chapter 7: Creating Modules
##

# __init__.pydans un répertoire destiné à devenir un package. 
# Ce fichier est optionnel depuis la version 3.3 de Python

# Hierarchy: functions, modules, packages

##
# Chapter 8: Exceptions
##

1/0
#ZeroDivisionError: division by zero
#type of exception: message to understand the exception

## Basic exception:
annee = input("Please enter a year: ")
try: # On essaye de convertir l'année en entier
    annee = int(annee)
except: # all possible exceptions. This is not elegant
    print("Erreur lors de la conversion de l'année.")

## Type aware exception:
numerateur = 1
denominateur = 0
try:
    resultat = numerateur / denominateur
except NameError:
    print("La variable numerateur ou denominateur n'a pas été définie.")
except TypeError:
    print("La variable numerateur ou denominateur possède un type incompatible avec la division.")
except ZeroDivisionError as exception_type:
    print("La variable denominateur est égale à 0, l'erreur est:", exception_type)
    
## More complete 'try' bloc:
numerateur = 1
denominateur = 2
try:
    resultat = numerateur / denominateur
except NameError:
    print("La variable numerateur ou denominateur n'a pas été définie.")
except TypeError:
    print("La variable numerateur ou denominateur possède un type incompatible avec la division.")
    pass # we can also pass the exception.
except ZeroDivisionError as exception_type:
    print("La variable denominateur est égale à 0, l'erreur est:", exception_type)
else:
    print("Le résultat obtenu est", resultat)
finally:
    print("Goodbye")
    # Instruction(s) exécutée(s) qu'il y ait eu des erreurs ou non

## Assertions:
var = 5
assert var == 5
assert var == 8
# In practice: https://stackoverflow.com/questions/33491975/why-not-use-pythons-assert-statement-in-tests-these-days

## Raise an exception:
annee = input() # L'utilisateur saisit l'année
try:
    annee = int(annee) # On tente de convertir l'année
    if annee<=0:
        raise ValueError("l'année saisie est négative ou nulle")
except ValueError:
    print("La valeur saisie est invalide (l'année est peut-être négative).")
    
##
# Chapter 9: TP
##
# -*- coding: utf-8 -*-
"""
Created on Wed Aug 22 14:13:03 2018

@author: alexis
"""

from random import randrange
from math import ceil

#randrange(0, 50) # any number between 0 to 49 == randrange(50)
#mise = 3
#ceil(mise / 2)

mon_argent = 100 # en dollar
while mon_argent > 0:
    print("Vous avez maintenant", mon_argent, "$ restants")
    ma_mise = input("Quelle est votre mise ? ")
    if ma_mise == "q":
        break
    
    mon_numero = input("Quel est votre numero ? (entre 0 et 49): ")
        
    # Test ma_mise    
    try:
        ma_mise = int(ma_mise) # On tente de convertir la mise
        if ma_mise <= 0:
            raise ValueError("Vous devez parier une mise positive")
        elif ma_mise > mon_argent:
            raise ValueError("Vous devez parier moins que votre argent disponible")
    except ValueError:
        print("La mise est incorrecte")

    # Test mon_numero
    try:
        mon_numero = int(mon_numero) # On tente de convertir le numero
        if mon_numero < 0 or mon_numero > 49:
            raise ValueError("Le numero doit etre entre 0 et 49")
    except ValueError:
        print("Le numero est incorrect")
        pass
    
    # Rien ne va plus
    casino_numero = randrange(0, 50)
    if casino_numero == mon_numero:
        mon_argent = mon_argent + 3 * ma_mise
        print("Vous avez mise le bon numero !")
    elif casino_numero % 2 == mon_numero % 2:
        mon_argent = mon_argent + ceil(ma_mise / 2)
        print("Vous avez mise la bonne couleur. Le numero gagnant etait", casino_numero)
    else:
        mon_argent = mon_argent - ma_mise
        print("Vous avez perdu. Le numero gagnant est ", casino_numero)
    