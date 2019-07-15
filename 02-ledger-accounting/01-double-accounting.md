
# Une introduction à Ledger #

Ce chapitre présente la philosophie de la comptabilité en partie double, Ledger comme outil en ligne de commande et son utilisation de base.


## Comptabilité en partie double ##

La comptabilité en partie double est une approche comptable standard.
En comptabilité, chaque type de dépenses ou de revenus et chaque "emplacement" qui détient une valeur monétaire est appelé un "compte" (pensez "catégorie").
Des exemples de comptes peuvent être "Epicerie", "Vélo", "Vacances", "Compte chèque de la Banque X", "Salaire" ou "Hypothèque".
Dans la comptabilité en partie double, on suit le flux d'argent d'un compte à l'autre.
Un montant d'argent figure toujours deux fois ("double") dans les registres : A l'endroit d'où il vient et à l'endroit où il a été déplacé.
C'est-à-dire, ajouter 1000€ *ici* signifie retirer 1000€ de *là* en même temps.
En conséquence, *le solde total de tous les comptes est toujours nul*.
L'argent n'est jamais ajouté à un compte sans indiquer d'où vient exactement le même montant.
Toutefois, plus de deux comptes peuvent être impliqués dans une même transaction.

Par exemple, l'achat d'un livre en ligne pour 15€ déplace l'argent du compte "Carte de crédit X" vers le compte "Livres".
Recevoir un salaire de 2000€ de votre patron signifie transférer 2000€ du compte "Salaire" au compte "Banque" (ou autre).
L'achat de produits d'épicerie et de détergents au supermarché peut faire passer de l'argent de la "Carte de crédit X" à l'"Épicerie" et au "Ménage".

En général, les noms de compte dépendent de la situation.
Mais, on a habituellement les comptes principaux suivants :

* Dépenses
* Revenus
* Actifs
* Passifs
* Créances
* Fonds propres

Le niveau de détail requis pour les sous-catégories ("Dépenses" -> "Epicerie" -> "Fruits" -> "Bananes") est à la hauteur des exigences.

## Ledger ##

[Ledger](https://www.ledger-cli.org) est un outil en ligne de commande de comptabilité en partie double créé par [John Wiegley](http://newartisans.com/) avec une communauté de collaborateurs actifs.
C'est un outil extrêmement puissant et il faut du temps et des efforts pour être en mesure de libérer sa puissance.
Cependant, une fois maîtrisé, il n'y a pas grand-chose qui peut vous manquer lorsque vous faites de la comptabilité personnelle ou professionnelle.

Une documentation détaillée est disponible à l'adresse suivante [http\://ledger-cli.org](https://www.ledger-cli.org).

L'utilisation de Ledger se résume à deux types d'action distincts : Mise à jour de la liste des transactions (le "journal") et utilisation de Ledger pour visualiser/interpréter ces données.

Ledger suit les bonnes vieilles traditions Unix et stocke les données dans des fichiers texte en clair.
Ces données comprennent principalement le journal avec les transactions et quelques méta-informations.
Une transaction typique dans Ledger ressemble à ceci :

~~~{.scheme}
2042/02/21 Shopping
	Expenses:Food:Groceries                 $42.00
	Assets:Checking                        -$42.00
~~~

Toute transaction commence par une ligne d'en-tête contenant la date et quelques méta-informations (dans le cas ci-dessus seulement un commentaire décrivant la transaction).
L'en-tête est suivi d'une liste des comptes impliqués dans la transaction (un "enregistrement" par ligne, chaque ligne commençant par un espace blanc).
Les comptes ont des noms arbitraires, mais Ledger utilise les deux points pour distinguer les sous-catégories.
Le nom du compte est suivi d'au moins deux espaces blancs et du montant d'argent qui a été ajouté (positif) ou supprimé (négatif) de ce même compte.
En fait, Ledger est assez intelligent pour calculer le montant approprié aussi il aurait été parfaitement valide de n'écrire que :

~~~{.scheme}
2042/02/21 Shopping
    Expenses:Food:Groceries                 $42.00
    Assets:Checking
~~~

Le fichier journal est aussi simple que cela et il n'y a pas grand-chose à en savoir pour le moment.
Notez que Ledger ne modifie jamais vos fichiers.

Les transactions suivantes illustrent quelques concepts de base utilisés dans la double comptabilité et Ledger :

~~~{.scheme}
; The opening balance sets up your initial financial state.
; This is needed as one rarely starts with no money at all.
; Your opening balance is the first "transaction" in your journal.
; The account name is not special. We only need something convenient here.
2041/12/31 * Opening Balance
    Assets:Checking                       $1000.00
    Equity:OpeningBalances

; The money comes from the employer and goes into the bank account.
2041/01/31 * Salary
    Income:Salary                           -$1337
    Assets:Checking                          $1337

; Groceries were paid using the bank account's electronic cash card
; so the money comes directly from the bank account.
2042/02/15 * Shopping
    Expenses:Food:Groceries                 $42.00
    Assets:Checking

; Although we know the cash sits in the wallet, everything in cash is
; considered as "lost" until recovered (see next transaction and later chapters).
2042/02/15 * ATM withdrawal
    Expenses:Unknown                       $150.00
    Assets:Checking

; Paying food with cash: Moving money from the Expenses:Unknown
; account to the food account.
2042/02/15 * Shopping
    Expenses:Food:Groceries                 $23.00
    Expenses:Unknown

; Ledger automatically reduces 'Expenses:Unknown' by $69.
2042/02/22 * Shopping
    Expenses:Food:Groceries                 $23.00
    Expenses:Clothing                       $46.00
    Expenses:Unknown

; You can use positive (add money to an account) or negative
; (remove money from an account) amounts interchangeably.
2042/02/22 * Shopping
    Expenses:Food:Groceries
    Expenses:Unknown                       -$42.00
~~~

L'exemple ci-dessus a déjà introduit quelques concepts sympathiques de Ledger.
Cependant, la lecture du fichier texte est un peu ennuyeuse.
Avant de laisser Ledger l'analyser pour nous, vous devrez probablement en premier lieu l'installer ...

## Installation de Ledger ##

La dernière version de Ledger peut être obtenue sur son [site Web](https://www.ledger-cli.org/download.html).
Je recommande d'avoir au moins la version 3.1 fonctionnelle.

D'autres dépendances pour l'écosystème présenté dans ce livre sont :

* [Git](http://git-scm.com/)
* [Python](https://www.python.org/)

Facultatif mais recommandé :

* [gnuplot](http://www.gnuplot.info/)
* [tig](https://github.com/jonas/tig)
* [tmux](http://tmux.sourceforge.net/)
* [tmuxinator](https://github.com/tmuxinator/tmuxinator)

### Linux & BSD ###

Vous trouverez ce dont vous avez besoin sur le [site de téléchargement](https://www.ledger-cli.org/download.html).

Lorsque vous utilisez Linux, ce pourrait être juste une question de :

~~~{.bash}
$ sudo apt-get install ledger
# or
$ sudo yum install ledger
# or ...
~~~

Cependant, le paquet de la distribution peut être plus ancien que celui fourni sur le site de téléchargement.
Ledger est livré avec une très bonne documentation d'installation.
Reportez-vous à la [page Github](https://github.com/ledger/ledger) pour plus de détails.

### macOS / OS X / Mac OS X ###

La façon la plus simple d'installer Ledger sur un Mac est avec [Homebrew](https://brew.sh/).
Installez Homebrew en utilisant la méthode actuellement recommandée, puis installez Ledger avec une simple commande :

```{.bash}
$ brew install ledger
```

### Windows ###

Ledger est difficile à exécuter sous Windows (vous auriez probablement besoin de le compiler vous-même et c'est souvent un casse-pieds sous Windows).
De plus, l'installation présentée dans ce livre fait un usage intensif de l'infrastructure traditionnelle de la ligne de commande Unix.
Je recommande donc d'installer VirtualBox et d'installer Ledger sur une machine Linux.
Vous pouvez utiliser VirtualBox simple ou VirtualBox avec Vagrant par dessus.
Ce dernier est probablement plus facile et plus rapide.
Il vous sera tout à fait possible de vous connecter à votre machine virtuelle via SSH dans Windows par la suite, vous n'aurez donc pas besoin "d'utiliser" l'environnement Linux.

Instructions étape par étape (sans Vagrant) :

* Télécharger et installer [VirtualBox](https://www.virtualbox.org/).
* Téléchargez une distribution ISO d'une distribution Linux de votre choix ([Ubuntu](http://www.ubuntu.com/desktop)?).
* Installez Linux sur la machine virtuelle.
* Installez le serveur OpenSSH *server* ("``$ sudo apt-get install openssh-server``" pour Ubuntu).
* Assurez-vous que vous pouvez [accéder à la vm via SSH](http://stackoverflow.com/a/10532299).
* Exécutez la machine en [mode headless](https://www.virtualbox.org/manual/ch07.html#vboxheadless) si vous le souhaitez.
* Installez [babun](https://github.com/babun/babun) (construit sur [Cygwin](https://www.cygwin.com/)) sur votre machine Windows.
* Connectez-vous à la vm via SSH.
* Suivez les instructions pour installer Ledger sous Linux.

Instructions étape par étape (avec Vagrant) :

* Télécharger et installer [VirtualBox](https://www.virtualbox.org/) & [Vagrant](https://www.vagrantup.com/).
* Téléchargez ce [Vagrantfile](https://github.com/rolfschr/GSWL-ecosystem/blob/master/contrib/Vagrantfile) depuis Github.
* Ouvrez un terminal, allez à l'emplacement du Vagrantfile et lancez ``vagrant up`` (ceci configurera une machine Ubuntu avec Ledger installé).
* Pour se connecter à la VM via SSH, utilisez ``vagrant up`` suivi de ``vagrant ssh`` depuis le même dossier.

## Un premier avant-goût ##

Avec une installation fonctionnelle de Ledger sur votre machine, récupérez ces [exemples de transactions](https://gist.github.com/rolfschr/318f1f91f8f845864568) depuis Github (cliquez sur le bouton 'Raw') et copiez-les dans un fichier texte appelé ``journal.txt``.
Alors, lancez ceci :

~~~{.bash}
$ # Usage: ledger -f <journal-file> [...]
$ ledger -f journal.txt balance
$ ledger -f journal.txt balance Groceries
$ ledger -f journal.txt register

# Start an interactive session
# and type "balance", then  press Enter
# (press ctrl+d to quit)
$ ledger -f journal.txt
~~~

Cela devrait vous donner une première impression sur Ledger.
Vous en verrez plus dans le chapitre Rapports plus loin.
Mais d'abord, nous devons mettre en place notre propre écosystème Ledger.

\newpage
