# Prise en main de Ledger - Le Livre [![Build Status](https://travis-ci.org/deild/GSWL-book.svg?branch=traduction_fr)](https://travis-ci.org/deild/GSWL-book)

> Forked & Translate by from [rolfschr/GSWL-book]

_Prise en main de Ledger_ est un livre d'introduction à l'excellent outil de comptabilité en ligne de commande [Ledger](https://ledger-cli.org/)

Les couvertures du livre :

- Les bases de la comptabilité (en partie double).
- Installation et exécution du Ledger de base.
- Mise en place d'un environnement entièrement automatique pour l'utilisation en production.
- Intégration de données externes (CSV des banques, etc.) dans le journal.
- Générer automatiquement les rapports habituels sur sa situation financière.
- Sujets avancés comme les transactions automatisées (brièvement).

## Obtenir le livre

Allez à la page [Releases](https://github.com/deild/GSWL-book/releases) et téléchargez le fichier PDF.

Vous pouvez également consulter la dernière version sur [GitHub](https://deild.github.io/GSWL-book/latest.html).

## Télécharger la dernière version

```bash
mkdir -p ~/src && cd ~/src
git clone https://github.com/deild/GSWL-book.git
cd GSWL-book
make pdf # use pandoc to generate LaTeX & PDF file
```

[rolfschr/gswl-book]: https://github.com/rolfschr/GSWL-book
