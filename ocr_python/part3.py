# -*- coding: utf-8 -*-

##
# Chapter 1: First approach to classes
##

## Most simple
class Personne:
    '''Classe definissant une personne caracterisee par :
        - son nom,
        - son prenom,
        - son age,
        - son lieu de residence'''
        
    def __init__(self): # notre methode constructeur
        '''Pour l'instant, on ne va definir qu'un seul attribut'''
        self.nom = 'Dupont'
        # 'self' est l'objet en train de se creer        
bernard = Personne()
bernard # <__main__.Personne at 0x7ff7150fd160>
bernard.nom # 'Dupont'
bernard.nom = 'Martin' # bad practice in C++ without get/set, but may be ok in Python?
bernard.nom # Martin

## With parameters
class Personne():
    '''Classe definissant une personne caracterisee par :
        - son nom,
        - son prenom,
        - son age,
        - son lieu de residence'''
        
    def __init__(self, prenom, nom = 'Dupont'): # notre methode constructeur
        '''Pour l'instant, on ne va definir qu'un seul attribut'''
        self.nom = nom
        self.prenom = prenom
        self.age = 33 # Cela n'engage à rien
        self.lieu_residence = "Paris"
        
jean = Personne(prenom = 'Jean')
jean # <__main__.Personne at 0x7ff7150fd160>
jean.nom
jean.prenom

## Class attributes
# Attributes following the whole class, not individual objects.
# For example, an attribute can count the number of objects of the class
class Compteur:
    '''Cette classe possede un attribut de classe qui s'incremente a chaque
    fois que l'on cree un objet de ce type'''
    objets_crees = 0 # Le compteur vaut 0 au depart
    
    def __init__(self):
        '''A chaque fois qu'on cree un objet, on incremente le compteur'''
        Compteur.objets_crees += 1
        
Compteur.objets_crees
# 0
a = Compteur() # on cree un premier objet
Compteur.objets_crees
# 1
b = Compteur()
Compteur.objets_crees
# 2

## Methods
class TableauNoir:
    '''Classe definissant une surface sur laquelle on peut ecrire,
    que l'on peut lire et effacer, par jeu de methodes. L'attribut
    modifie est "surface"'''
    
    def __init__(self):
        '''Par defaut, notre surface est vide'''
        self.surface = ''
        
    def ecrire(self, message_a_ecrire):
        '''Methode permettant d'ecrire sur la surface du tableau.
        Si la surface n'est pas vide, on saute une ligne avant de rajouter le
        message a ecrire'''
        if self.surface != '':
            self.surface += '\n'
        self.surface += message_a_ecrire
        
    def lire(self):
        '''Methode pour afficher la surface du tableau'''
        print(self.surface)
        
    def effacer(self):
        '''Methode pour effacer la surface du tableau'''
        self.surface = ''

tab = TableauNoir()
tab.surface
tab.ecrire('Bonjour')
tab.surface
tab.ecrire('Au revoir')
print(tab.surface)

# Chaque attribut est propre a l'objet. Chaque objet peut avoir des attributs
# differents.
# Chaque methode est propre a la classe. L'objet appelle la methode qui reste
# dans la classe.
# Chaque methode a son 'self' en premier argument (convention)
tab.ecrire # <bound method TableauNoir.ecrire... <-- dans la classe
TableauNoir.ecrire # <function __main__.TableauNoir.ecrire>
help(TableauNoir.ecrire)

# Those two commands are similar:
TableauNoir.ecrire(tab, "essai")
tab.ecrire("essai")

#
tab.lire()
tab.effacer()
tab.lire() # ''

help(TableauNoir) # for a whole resume of the class

## Class methods
# Using and modifying the class attributes:
# Not used a lot.
class Compteur:
    '''Cette classe possede un attribut de classe qui s'incremente a chaque
    fois que l'on cree un objet de ce type'''
    objets_crees = 0 # le compteur vaut 0 au depart
    def __init__(self):
        '''A chaque fois qu'on cree un objet, on incremente le compteur'''
        Compteur.objets_crees += 1
    def combien(cls):
        '''Methode de classe affichant combien d'objets ont ete crees'''
        print("Jusqu'a present, {} objets ont ete crees".format(cls.objets_crees))
    
    combien = classmethod(combien) # to let Python understand it is a class method

Compteur.combien()
a = Compteur()
Compteur.combien()
b = Compteur()
b.combien() # same as Compteur.combien() here

## Static methods
class Test:
    """Une classe de test tout simplement"""
    def afficher():
        """Fonction chargée d'afficher quelque chose"""
        print("On affiche la même chose.")
        print("peu importe les données de l'objet ou de la classe.")
    afficher = staticmethod(afficher)

# Static method is not related to a class or object.
# Here no argument.
# (if we need arguments, @staticmethod decorator to add see next chapters)
Test.afficher()
a = Test()
a.afficher()

## Special methods
# Of the form __mamethode__
# See next chapters. Do not use such name for normal methods

## Liste des attributs et methods: dir (introspection of an object)
class Test:
    """Une classe de test tout simplement"""
    def __init__(self):
        """On définit dans le constructeur un unique attribut"""
        self.mon_attribut = "ok"
    
    def afficher_attribut(self):
        """Méthode affichant l'attribut 'mon_attribut'"""
        print("Mon attribut est {0}.".format(self.mon_attribut))

un_test = Test()
un_test.afficher_attribut()
dir(un_test)
# ['__class__',
# '__delattr__',
# '__dict__',
# '__dir__',
# '__doc__',
# '__eq__',
# '__format__',
# '__ge__',
# '__getattribute__',
# '__gt__',
# '__hash__',
# '__init__',
# '__le__',
# '__lt__',
# '__module__',
# '__ne__',
# '__new__',
# '__reduce__',
# '__reduce_ex__',
# '__repr__',
# '__setattr__',
# '__sizeof__',
# '__str__',
# '__subclasshook__',
# '__weakref__',
# 'afficher_attribut',
# 'mon_attribut']

# All the __method__ are special methods of Python, see next chapters.

## Dict summarizes all attributes of the object (introspection of an object)
un_test.__dict__
# {'mon_attribut': 'ok'}

# Possible to change directly an attributes from the dictionary:
# But not recommanded at all!
un_test.__dict__["mon_attribut"] = "plus ok"
un_test.afficher_attribut()

##
# Chapter 2: Properties (this is something quite specific to Python)
##

# Contrary to C++ for example, it is ok to to get/set directly using:
# mon_objet.mon_attribut (get)
# mon_objet.mon_attribut = new_value (set)

# Contrary to C++, there is no private attributes

class Personne:
    """Classe définissant une personne caractérisée par :
    - son nom ;
    - son prénom ;
    - son âge ;
    - son lieu de résidence"""

    def __init__(self, nom, prenom):
        """Constructeur de notre classe"""
        self.nom = nom
        self.prenom = prenom
        self.age = 33
        self._lieu_residence = "Paris" # Notez le souligné _ devant le nom
        
    def _get_lieu_residence(self):
        """Méthode qui sera appelée quand on souhaitera accéder en lecture
        à l'attribut 'lieu_residence'"""
        print("On accède à l'attribut lieu_residence !")
        return self._lieu_residence # note that we access _lieu_residence with a _
        # ok to access to this private variable because we are inside the class
        
    def _set_lieu_residence(self, nouvelle_residence):
        """Méthode appelée quand on souhaite modifier le lieu de résidence"""
        print("Attention, il semble que {} déménage à {}.".format( \
                self.prenom, nouvelle_residence))
        self._lieu_residence = nouvelle_residence
    # On va dire à Python que notre attribut lieu_residence pointe vers une
    # propriété
    # Here and only here we define 'lieu_residence'
    lieu_residence = property(_get_lieu_residence, _set_lieu_residence)
    # Usually 2 parameters get/set, but maximum 4: get/set/destructor/help
    # Also possible with only 1 parameter get (so cannot modify the attribute)

jean = Personne('jean', 'bonneau')
jean.lieu_residence # get
# On accède à l'attribut lieu_residence !
# Paris
jean.lieu_residence = 'Moscou'
# Attention, il semble que bonneau déménage à Moscou.
jean.lieu_residence
# On accède à l'attribut lieu_residence !
# Moscou

# Convention: do not access to attributes or methods beginning with _:
# DO NOT: jean._lieu_residence; jean._get_lieu_residence()
# It is kind of private variable.

## For some recurrent action, we prefer special method instead of properties
# (see next chapter)

##
# Chapter 3: Special methods
##

# Example of why there are useful:
# - Let Python understand what 'mon_objet1 + mon_objet2' does mean,
# - Let Python understand what 'mon_objet[indice]' means

# Each special method has the shape __method__

# In this chapter:
# 1. special methods working on the object in general
# 2. special methods working on attributes

#### 1. Special methods when we create and delete objects:

## __init__
# The constructor
class Exemple:
    """Un petit exemple de classe"""
    def __init__(self, nom):
        """Exemple de constructeur"""
        self.nom = nom
        self.autre_attribut = "une valeur"

mon_objet = Exemple("un premier exemple")

## __del__
# The destructor
# When 'del object' is called, 
# local variable of a function when the function is finished, etc.
#
# Usually, Python manages this! Shape like this:
class Exemple:
    def __del__(self):
        """Méthode appelée quand l'objet est supprimé"""
        print("C'est la fin ! On me supprime !")

a = Exemple()
del a
# C'est la fin ! On me supprime !

## __repr__
# Representation of an object
a = Exemple()
a # <__main__.Exemple at 0x7ff714068198> ... not beautiful!
# __repr__ will change this:
class Personne:
    """Classe représentant une personne"""
    def __init__(self, nom, prenom):
        """Constructeur de notre classe"""
        self.nom = nom
        self.prenom = prenom
        self.age = 33
    def __repr__(self): # __repr__ only takes 'self' as an argument
        """Quand on entre notre objet dans l'interpréteur"""
        return "Personne: nom({}), prénom({}), âge({})".format(
                self.nom, self.prenom, self.age)

a = Personne('alesi', 'jean')
a # Personne: nom(alesi), prénom(jean), âge(33)

# repr(a) gives the same result

## __str__
# Representation when calling print(object)
# By default, output is same as for repr(object), but can be changed:
class Personne:
    """Classe représentant une personne"""
    def __init__(self, nom, prenom):
        """Constructeur de notre classe"""
        self.nom = nom
        self.prenom = prenom
        self.age = 33
    def __str__(self): # __str__ only takes 'self' as an argument
        """Méthode permettant d'afficher plus joliment notre objet"""
        return "{} {}, âgé de {} ans".format(
                self.prenom, self.nom, self.age)

a = Personne('alesi', 'jean')
a # <__main__.Personne at 0x7ff714078c50>, because __repr__ has not been defined
print(a) # jean alesi, âgé de 33 ans

#### 2. special methods working on attributes

## __getattr__
# If called attribute does not exist,
# and if __getattr__ method exists,
# then the object calls __getattr__ with the missing attributes as a parameter
# Example:
 
class Protege:
     """Classe possédant une méthode particulière d'accès à ses attributs :
     Si l'attribut n'est pas trouvé, on affiche une alerte et renvoie None"""

     
     def __init__(self):
         """On crée quelques attributs par défaut"""
         self.a = 1
         self.b = 2
         self.c = 3
     def __getattr__(self, nom):
         """Si Python ne trouve pas l'attribut nommé nom, il appelle
         cette méthode. On affiche une alerte"""
         print("Alerte ! Il n'y a pas d'attribut {} ici !".format(nom))
         # self.a = nom # just to test.

pro = Protege()
pro.a
#1
pro.c
#3
pro.e
#Alerte ! Il n'y a pas d'attribut e ici !

## __setattr__
# Called everytime 'objet.nom_attribut = nouvelle_valeur' is done
# Shape of code:
def __setattr__(self, nom_attr, val_attr):
        """Méthode appelée quand on fait objet.nom_attr = val_attr.
        On se charge d'enregistrer l'objet"""
        # First we use the common 'set' defined inside Python.
        object.__setattr__(self, nom_attr, val_attr) # /!\
        # Then we add a custom behavior: self.enregistrer()
        self.enregistrer()
        
# /!\: All classes inherit from class 'object'. So 'object.__setattr__' is the
# default set behavior.
# Note that we cannot remove 'object.' because this would cause an infinite
# recursion.

## __delattr__
# Called everytime an attribute is deleted
pro.__delattr__('a') # delete attribute 'a'
# __delattr__ manage deletion carefully.
# for example, we can decide to forbid deletion of attributes.
class Protege2:
     """Classe possédant une méthode particulière pour supprimer les attributs :
     Suppression interdite"""
     def __init__(self):
         """On crée quelques attributs par défaut"""
         self.a = 1
         self.b = 2
         self.c = 3
     def __delattr__(self, nom_attr):
         """On ne peut supprimer d'attribut, on lève l'exception
         AttributeError"""
         raise AttributeError("Vous ne pouvez supprimer aucun attribut de cette classe")

protege2 = Protege2()
protege2.a
protege2.__delattr__(a) # AttributeError: Vous ne pouvez supprimer aucun attribut de cette classe

# usually we do not delete attributes using 'del pro.a'

## Bonus: Syntax command(object, value) instead of object.__command__(value)
objet = MaClasse() # On crée une instance de notre classe
getattr(objet, "nom") # Semblable à objet.nom
setattr(objet, "nom", val) # = objet.nom = val ou objet.__setattr__("nom", val)
delattr(objet, "nom") # = del objet.nom ou objet.__delattr__("nom")
hasattr(objet, "nom") # Renvoie True si l'attribut "nom" existe, False sinon
# Why use this? objet = 'name_of_my_object' is a string now.

## Les méthodes de conteneur






