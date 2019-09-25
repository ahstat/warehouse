# -*- coding: utf-8 -*-
"""
Created on Wed Aug 22 14:43:49 2018

@author: alexis
"""

##
# Chapter 1: Strings
##
chaine = "NE CRIE PAS SI FORT !"
chaine.lower() # Mettre la chaîne en minuscule
# .lower() est une methode, utilisable sur les objets de classe str

minuscules = "une chaine en minuscules"
minuscules.upper() # Mettre en majuscules
minuscules.capitalize() # La première lettre en majuscule

espaces = "   une  chaine avec  des espaces   "
espaces.strip() # On retire les espaces au début et à la fin de la chaîne

titre = "introduction"
titre.upper().center(20)


prenom = "Paul"
nom = "Dupont"
age = 21
print("Je m'appelle {0} {1} et j'ai {2} ans.".format(prenom, nom, age))

# formatage d'une adresse
adresse = """
{no_rue}, {nom_rue}
 {code_postal} {nom_ville} ({pays})
""".format(no_rue=5, nom_rue="rue des Postes", code_postal=75003, nom_ville="Paris", pays="France")
print(adresse)

# concatenation
prenom = "Paul"
message = "Bonjour"
chaine_complete = message + " " + prenom
print(chaine_complete) # Résultat :

age = 99
message = "J'ai " + str(age) + " ans."
print(message)

## String elements
chaine = "Salut les ZER0S !"
chaine[0] # Première lettre de la chaîne
chaine[2] # Troisième lettre de la chaîne
chaine[-1] # Dernière lettre de la chaîne
len(chaine)

chaine[0] = "M" # TypeError: 'str' object does not support item assignment
"M" + chaine[1:]

help(str.count)
chaine.count("S") # 2
chaine.find("S") # 0 (return the first position of "S")
chaine.replace("S", "M") # replace all "S" with "M"

##
# Chapter 2: Lists and tuples
##

## Empty list
ma_liste = list()
ma_liste # []
type(ma_liste) # list

## A list
ma_liste = [1, 2, 3, 4, 5] # Une liste avec cinq objets
print(ma_liste)

## Another list
ma_liste = [1, 3.5, "une chaine", []]
ma_liste[1] # 3.5

## Lists are mutable (contrary to str)
ma_liste = [1, 2, 3]
ma_liste.append(56) # list.append(x) adds x in list and outputs None
print(ma_liste)

# Methods on lists modify the object!
## More complete example:
chaine1 = "une petite phrase"
chaine2 = chaine1.upper() # On met en majuscules chaine1
chaine1                   # On affiche la chaîne d'origine
# Elle n'a pas été modifiée par la méthode upper (chaine1 is unmutable)

chaine2                   # On affiche chaine2
# C'est chaine2 qui contient la chaîne en majuscules

# Voyons pour les listes à présent
liste1 = [1, 5.5, 18]
liste2 = liste1.append(-15) # On ajoute -15 à liste1
liste1                      # On affiche liste1
# Cette fois, l'appel de la méthode a modifié l'objet d'origine (liste1)
# Voyons ce que contient liste2
liste2
# Rien ? Vérifions avec print
print(liste2)
# Outputs None

## Another examples
ma_liste = ['a', 'b', 'd', 'e']
ma_liste.insert(2, 'c') 
print(ma_liste)

ma_liste1 = [3, 4, 5]
ma_liste2 = [8, 9, 10]
ma_liste1 + ma_liste2
ma_liste1.extend(ma_liste2) # this is changing ma_liste1

## Delete elements in a list
variable = 34
del variable
variable # does not exist anymore

# Remove at a specified position
ma_liste = [-5, -2, 1, 4, 7, 10]
del ma_liste[0] # On supprime le premier élément de la liste
ma_liste # [-2, 1, 4, 7, 10]

# Remove a specified element (only the first element encountered)
ma_liste = [-5, -2, 1, 4, 7, 10]
ma_liste.remove(-2)
ma_liste # [-5, 1, 4, 7, 10]

## Select elements in a list
for elt in ma_liste:
    print(elt)

for elt in enumerate(ma_liste):
    print(elt) # each elt is a tuple of length 2

for i, elt in enumerate(ma_liste):
    print("À l'indice {} se trouve {}.".format(i, elt))

# Enumerate ["a", "b", "c"]: (0, "a") (1, "b") (2, "c")
# Zip ["a", "b", "c"] ["d", "e", "f"]: ("a", "d") ("b", "e") ("c", "f")

## Tuples
tuple_vide = ()
tuple_non_vide = (1,) # est équivalent à ci dessous
tuple_non_vide = 1,
tuple_avec_plusieurs_valeurs = (1, 2, 5)

a, b = 3, 4 # same as: (a, b) = (3, 4)

# Return a tuple:
def decomposer(entier, divise_par):
    """Cette fonction retourne la partie entière et le reste de
    entier / divise_par"""

    p_e = entier // divise_par
    reste = entier % divise_par
    return p_e, reste

decomposer(10, 3)

##
# Chapter 3: Lists and tuples 2
##

## Convert strings to lists:
ma_chaine = "Bonjour à tous"
ma_chaine.split(" ")
# ['Bonjour', 'à', 'tous']
ma_chaine.split() # by default, splits /n /t and " "
# ['Bonjour', 'à', 'tous']

## Join list into string
ma_liste = ['Bonjour', 'à', 'tous']
" ".join(ma_liste)

def afficher_flottant(flottant):
    """Fonction prenant en paramètre un flottant et renvoyant une chaîne de caractères représentant la troncature de ce nombre. La partie flottante doit avoir une longueur maximum de 3 caractères.

    De plus, on va remplacer le point décimal par la virgule"""
    
    if type(flottant) is not float:
        raise TypeError("Le paramètre attendu doit être un flottant")
    flottant = str(flottant)
    partie_entiere, partie_flottante = flottant.split(".")
    # La partie entière n'est pas à modifier
    # Seule la partie flottante doit être tronquée
    return ",".join([partie_entiere, partie_flottante[:3]])
    
afficher_flottant(3.999999)

## Parametres de fonctions:
# like for print: print("a", "b", "c", "d") is valid
help(print) # see print(value, ...) which corresponds to print(*values)
# Example:
def fonction_inconnue(*parametres):
     """Test d'une fonction pouvant être appelée avec un nombre variable de paramètres"""
     
     print("J'ai reçu : {}.".format(parametres))
 
fonction_inconnue() # On appelle la fonction sans paramètre
#J'ai reçu : ().
fonction_inconnue(33)
#J'ai reçu : (33,).
fonction_inconnue('a', 'e', 'f')
#J'ai reçu : ('a', 'e', 'f').
var = 3.5
fonction_inconnue(var, [4], "...")
#J'ai reçu : (3.5, [4], '...').
# Explanation: *parametres is considered as a tuple of elements

def fonction_inconnue(nom, prenom, *commentaires):
    print("J'ai reçu : {}.".format(commentaires))
    print(nom, prenom)
fonction_inconnue("bonjour", "aa", "ab", "cd")

def afficher(*parametres, sep=' ', fin='\n'):
    """Fonction chargée de reproduire le comportement de print.
    
    Elle doit finir par faire appel à print pour afficher le résultat.
    Mais les paramètres devront déjà avoir été formatés. 
    On doit passer à print une unique chaîne, en lui spécifiant de ne rien mettre à la fin :

    print(chaine, end='')"""
    
    # Les paramètres sont sous la forme d'un tuple
    # Or on a besoin de les convertir
    # Mais on ne peut pas modifier un tuple
    # On a plusieurs possibilités, ici je choisis de convertir le tuple en liste
    parametres = list(parametres)
    # On va commencer par convertir toutes les valeurs en chaîne
    # Sinon on va avoir quelques problèmes lors du join
    for i, parametre in enumerate(parametres):
        parametres[i] = str(parametre)
    # La liste des paramètres ne contient plus que des chaînes de caractères
    # À présent on va constituer la chaîne finale
    chaine = sep.join(parametres)
    # On ajoute le paramètre fin à la fin de la chaîne
    chaine += fin
    # On affiche l'ensemble
    print(chaine, end='')

afficher(5, 4, 5)

liste_des_parametres = [1, 4, 9, 16, 25, 36]
print(*liste_des_parametres)
# contrary here: like to transform the list into one by one elements

## List comprehensions
liste_origine = [0, 1, 2, 3, 4, 5]
[nb * nb for nb in liste_origine]

liste_origine = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
[nb for nb in liste_origine if nb % 2 == 0]

inventaire = [
 ("pommes", 22),
 ("melons", 4),
 ("poires", 18),
 ("fraises", 76),
 ("prunes", 51),
]

# My method
# https://stackoverflow.com/questions/7851077/how-to-return-index-of-a-sorted-list
names, quantity = zip(*inventaire)
idx = sorted(range(len(quantity)), key=lambda k: quantity[k], reverse=True)
[(names[elmt], quantity[elmt]) for elmt in idx]

# Correction
inventaire_inverse = [(qtt, nom_fruit) for nom_fruit,qtt in inventaire]
inventaire = [(nom_fruit, qtt) for qtt,nom_fruit in sorted(inventaire_inverse, \
    reverse=True)]

# Note: sorted works in all cases, using alphanumerical order.

##
# Chapter 4: Dictionaries
##
mon_dictionnaire = dict()
type(mon_dictionnaire)
mon_dictionnaire

mon_dictionnaire["pseudo"] = "OldName"
mon_dictionnaire["mot de passe"] = "*"
mon_dictionnaire["pseudo"] = "NewName"

# New dictionary
mon_dictionnaire = {}
mon_dictionnaire[0] = "a"
mon_dictionnaire[1] = "e"
mon_dictionnaire[2] = "i"
mon_dictionnaire[3] = "o"
mon_dictionnaire[4] = "u"
mon_dictionnaire[5] = "y"
mon_dictionnaire

placard = {"chemise":3, "pantalon":6, "tee-shirt":7}

## Set:
mon_ensemble = {'pseudo', 'mot de passe'}
mon_ensemble = {1, 2, 2, 3, 3}
mon_ensemble # {1, 2, 3}

## Delete keys in a dictionary
placard = {"chemise":3, "pantalon":6, "tee shirt":7}
del placard["chemise"]
placard

placard = {"chemise":3, "pantalon":6, "tee shirt":7}
placard.pop("chemise") # outputs 3 and delete this entry
placard

## Let different functions in a dictionary
def fete():
    print("C'est la fête.")

def oiseau():
    print("Fais comme l'oiseau...")

fonctions = {}
fonctions["fete"] = fete # on ne met pas les parenthèses
fonctions["oiseau"] = oiseau
fonctions["oiseau"]
fonctions["oiseau"]() # on essaye de l'appeler
# output: Fais comme l'oiseau...

## Iterator on dictionaries
fruits = {"pommes":21, "melons":3, "poires":31}
for cle in fruits:
    print(cle) 
# order in a dictionary is not fixed
    
for cle in fruits.keys():
    print(cle) 

for valeur in fruits.values():
    print(valeur)

for key, val in fruits.items():
    print("La clé {} contient la valeur {}.".format(key, val))

## Parametres de fonctions:
# Ici pour les dictionnaires en utilisant **dico
def fonction_inconnue(**parametres_nommes):
    """Fonction permettant de voir comment récupérer les paramètres nommés
       dans un dictionnaire"""
    print("J'ai reçu en paramètres nommés : {}.".format(parametres_nommes))

fonction_inconnue() # Aucun paramètre
# J'ai reçu en paramètres nommés : {}
fonction_inconnue(p=4, j=8)
# J'ai reçu en paramètres nommés : {'p': 4, 'j': 8}

def fonction_inconnue(*en_liste, **en_dictionnaire):
    print("J'ai reçu en paramètres nommés : {}.".format(en_dictionnaire))
    print("J'ai reçu en paramètres non nommés : {}.".format(en_liste))
    print(en_dictionnaire['p'])

fonction_inconnue('a', 'b', p = 'c')

# Contrary:
# Parameters can be set into a dictionary
parametres = {"sep":" >> ", "end":" -\n"}
print("Voici", "un", "exemple", "d'appel", **parametres)
# Same as:
print("Voici", "un", "exemple", "d'appel", sep=" >> ", end=" -\n")

##
# Chapter 5: Files
##
import os
my_dir = os.path.expanduser('~/Documents/GitHub/warehouse/ocr_python/part2_chapter5')
os.chdir(my_dir) # change directory
ls

os.getcwd() #(CWD = « Current Working Directory »).

## Open file to read it (do not use this, see with keyword 'with' after)
mon_fichier = open("fichier.txt", "r")
mon_fichier
#<_io.TextIOWrapper name='fichier.txt' encoding='UTF-8'>
type(mon_fichier)
#<class '_io.TextIOWrapper'>

## Read file
contenu = mon_fichier.read()
print(contenu)
contenu.split()

## Close file after use
mon_fichier.close()

## Write file
mon_fichier = open("fichier2.txt", "w") # Argh j'ai tout écrasé !
mon_fichier.write("Premier test d'écriture dans un fichier via Python")
mon_fichier.close()

## More careful, by checking that file can be opened using 'with'
# This is the good answer to open a file!
with open('fichier.txt', 'r') as mon_fichier:
    texte = mon_fichier.read()
# There can be an exception. But if an exception occurs, mon_fichier will be
# closed at the end.

# No need to use mon_fichier.close() here, 'with' manages this.
# 'with' is a word to create a context-manager.
mon_fichier.closed # Check that file has been closed.

## Pickle module to save in binary any Python object
import pickle

score = {
    "joueur 1":    5,
    "joueur 2":   35,
    "joueur 3":   20,
    "joueur 4":    2,
    }

with open('donnees', 'wb') as fichier: # we save into file 'donnees'
    mon_pickler = pickle.Pickler(fichier)
    # enregistrement:
    mon_pickler.dump(score) # dump method to save an object

## Pickle module to load a saved Python object
with open('donnees', 'rb') as fichier:
    mon_depickler = pickle.Unpickler(fichier)
    # Lecture des objets contenus dans le fichier:
    score_recupere = mon_depickler.load()
print(score_recupere)

##
# Chapter 6: Variable scope and references
##


def set_var(nouvelle_valeur):
    """Fonction nous permettant de tester la portée des variables
    définies dans notre corps de fonction"""
    
    # On essaye d'afficher la variable var, si elle existe
    try:
        print("Avant l'affectation, notre variable var vaut {0}.".format(var))
    except NameError:
        print("La variable var n'existe pas encore.")
    var = nouvelle_valeur
    print("Après l'affectation, notre variable var vaut {0}.".format(var))

set_var(8)
var # do not exist, var is in local scope
set_var(8)

# Rule of Python regarding to variable outside current scope:
# can use them but cannot reassign them (even in the local scope)
# (However, can use methods, see next paragraph)
var = 999
def local(val):
    print(var)
    return(val + var)
local(1) # 1000

var = 999
def local(val):
    var = 2
    return(val + var)
local(1) # 3

def local(val):
    ''' Check https://stackoverflow.com/questions/9264763/unboundlocalerror-in-python
    to understand why there is an UnboundLocalError here '''
    print(var)
    var = 2 # create local variable 'var'
    return(val + var)
local(1) # UnboundLocalError: local variable 'var' referenced before assignment

# Use method to change a liste:
def ajouter(liste, valeur_a_ajouter):
    """Cette fonction insère à la fin de la liste la valeur que l'on veut ajouter"""
    liste.append(valeur_a_ajouter)

ma_liste=['a', 'e', 'i']
ajouter(ma_liste, 'o')
print(ma_liste) # ['a', 'e', 'i', 'o']

## References and list
ma_liste1 = [1, 2, 3]
ma_liste2 = ma_liste1 # ma_liste1 and ma_liste2 reference to the same object
ma_liste3 = ma_liste1.copy() # To copy, we need to say this explicitly
# alternative: list(ma_liste1)
ma_liste2.append(4)
print(ma_liste2)
#[1, 2, 3, 4]
print(ma_liste1)
#[1, 2, 3, 4]
print(ma_liste3) # [1, 2, 3]

# id for each object:
id(ma_liste1) # 140574738700680
id(ma_liste2) # 140574738700680
id(ma_liste3) # 140574738816712

ma_liste4 = list(ma_liste1)
ma_liste1 == ma_liste2 # True
ma_liste1 == ma_liste4 # True

ma_liste1 is ma_liste2 # True
ma_liste1 is ma_liste4 # False

## Global variables
# Can be read and modified everywhere, in any scope
i = 4 # Une variable, nommée i, contenant un entier
def inc_i():
    """Fonction chargée d'incrémenter i de 1"""
    global i # Python recherche i en dehors de l'espace local de la fonction
    i += 1

print(i)
inc_i()
print(i)
inc_i()
print(i)
inc_i()
print(i)

##
# Chapter 7: TP
##
# -*- coding: utf-8 -*-
global words
global nb_tries_param
words = ['ACCOUDOIR', 'ARRIVER', 'MARCHER', 'ETEINDRE', 'JARRE', 'POULIE']
nb_tries_param = 8 

from random import randrange
import os
import pickle

## player selecting a letter
def select_letter():
    valid_charac = False
    while not valid_charac:
        charac = input('Please select a letter: ')
        try:
            charac = charac[0]
        except IndexError as error:
            print(error)
            continue
        
        charac = charac.upper()
        if charac not in map(chr, range(65, 91)):
            print('invalid value')
        else:
            valid_charac = True
    return(charac)

## playing one game
def play():
    current_word = words[randrange(0, len(words))]
    remaining_letters = set(current_word)
    hidden_word = list('*' * len(current_word))
    nb_tries = nb_tries_param

    print(current_word)
    
    gagne = False
    
    while not gagne and nb_tries > 0:
        print(''.join(hidden_word))
        my_letter = select_letter()
        print('Vous avez choisi: ' + my_letter + '.')   
        if my_letter in remaining_letters:
            print('Bien joue !')
            remaining_letters.remove(my_letter)
            # https://stackoverflow.com/questions/6294179/how-to-find-all-occurrences-of-an-element-in-a-list
            indices = [i for i, x in enumerate(list(current_word)) if x == my_letter]
            for idx in indices:
                hidden_word[idx] = my_letter
        else:
            print("Il n'y a pas cette lettre, ou elle a deja ete joue.")
            nb_tries -= 1
            print('Essais restants: ' + str(nb_tries) + '.')
    
        if not remaining_letters:
            gagne = True
            print('gagne! Le mot est bien: ' + ''.join(hidden_word))
            print('il vous restait ' + str(nb_tries) + ' essais.')
            
        if nb_tries == 0:
            print('perdu! Le mot etait: ' + current_word)

    return(nb_tries)

## managing files
def create_if_not_exist(file = 'scores'):
    if not os.path.exists(file):
        with open(file, 'wb') as fichier:
            mon_pickler = pickle.Pickler(fichier)
            mon_pickler.dump({})

def loading(file = 'scores'):
    with open('scores', 'rb') as fichier:
        mon_pickler = pickle.Unpickler(fichier)
        scores = mon_pickler.load()
    return(scores)
    
def writing(file = 'scores'):
    with open('scores', 'wb') as fichier: # we save into file 'scores'
        mon_pickler = pickle.Pickler(fichier)
        # enregistrement:
        mon_pickler.dump(scores) # dump method to save an object

## main
my_dir = os.path.expanduser('~/Documents/GitHub/warehouse/ocr_python/part2_chapter7')
os.chdir(my_dir) # change directory
create_if_not_exist('scores') # create binary file containing dict()
scores = loading('scores')

player_name = input('Please enter your name : ')

try:
    scores[player_name]
except KeyError:
    scores[player_name] = 0
    
score_to_add = play()
scores[player_name] += score_to_add
writing('scores')
print(scores)

# Correction:
'8'.isalnum() # checks whether a string is 100% alphanumerical
'aa'.isalpha() # checks whether a string is 100% alphabetic
# 'str' object does not support item assignment


