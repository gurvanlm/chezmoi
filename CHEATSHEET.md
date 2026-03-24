# Cheatsheet — Workflow quotidien

## Démarrer sa journée

```bash
# Ouvrir une session tmux pour un projet
tn monprojet           # crée la session "monprojet"

# Reprendre une session existante
ta                     # se rattacher à la dernière session
tmux attach -t monprojet  # session spécifique

# Lister les sessions actives
tl
```

Chaque projet = une session tmux. Tu peux switcher entre elles sans perdre ton contexte.

---

## Tmux — travailler avec les panes et fenêtres

Le prefix est **Ctrl+Space** (noté `P` ci-dessous). Tu appuies sur Ctrl+Space, tu relâches, puis tu appuies sur la touche suivante.

### Panes (diviser l'écran)

```
P + |       Diviser verticalement (côte à côte)
P + -       Diviser horizontalement (haut/bas)
P + h/j/k/l Naviguer entre panes (gauche/bas/haut/droite)
P + H/J/K/L Redimensionner un pane
P + x       Fermer le pane actif
P + z       Zoom/dézoom un pane (plein écran temporaire)
```

**Exemple concret** : tu veux un éditeur à gauche et un terminal à droite :
```
P + |       → split vertical
# pane gauche : nvim fichier.py
# pane droit : python fichier.py pour tester
P + h/l     → naviguer entre les deux
```

### Fenêtres (onglets)

```
P + c       Nouvelle fenêtre
P + 1-9     Aller à la fenêtre N
P + n/p     Fenêtre suivante/précédente
P + ,       Renommer la fenêtre
P + &       Fermer la fenêtre
```

**Exemple** : fenêtre 1 = code, fenêtre 2 = logs docker, fenêtre 3 = git

### Sessions

```
P + d       Détacher (quitter sans fermer, tout tourne en fond)
P + s       Voir et switcher entre sessions
P + F       Navigation fzf (sessions, fenêtres, panes)
P + $       Renommer la session
```

**Exemple workflow multi-projets** :
```bash
tn projet-api          # session 1
tn projet-front        # session 2
# Dans tmux : P + s pour switcher entre les deux
# ou P + F pour chercher avec fzf
```

### Sauvegarder / restaurer

```
P + Ctrl+s    Sauvegarder toutes les sessions (resurrect)
P + Ctrl+r    Restaurer après un reboot
```

Continuum sauvegarde automatiquement toutes les 15 minutes.

---

## Naviguer dans les fichiers

### Chercher un fichier par nom

```bash
# fzf — fuzzy search
Ctrl+T      # dans le terminal : cherche un fichier, insère le chemin

# Dans nvim
Espace+f    # ouvre le file finder
```

### Chercher du texte dans les fichiers

```bash
rg "pattern"              # cherche dans tous les fichiers récursivement
rg "TODO" --type py       # seulement dans les .py
rg "import" src/          # seulement dans le dossier src/
rg -i "error" --glob "*.log"  # insensible à la casse, dans les .log

# Dans nvim
Espace+g    # grep interactif avec preview
```

### Chercher un fichier par type

```bash
fd "*.toml"              # ⚠ fd utilise des regex, pas des globs
fd -e toml               # par extension (plus simple)
fd -e py test            # fichiers .py contenant "test" dans le nom
fd -t d src              # seulement les dossiers contenant "src"
```

### Explorer les dossiers

```bash
y                        # ouvre yazi (file manager)
                         # navigation : flèches ou h/j/k/l
                         # Entrée : ouvrir
                         # q : quitter (le shell sera dans le dossier où tu étais)
                         # d : supprimer (corbeille)
                         # D : supprimer définitivement

z projet                 # zoxide : saute dans le dossier le plus fréquenté contenant "projet"
z api                    # → ~/projets/mon-api/ (il apprend tes habitudes)
```

---

## Lire et afficher

```bash
cat fichier.py           # → bat avec syntax highlighting
ll                       # → eza avec icônes, permissions, git status
ls                       # → eza simple
tree                     # → eza en arbre
tree src/                # arbre d'un dossier spécifique

du ~/.config             # → dust : espace disque en arbre visuel
df                       # → duf : partitions montées

glow README.md           # rendu Markdown dans le terminal
tldr tar                 # man page simplifiée avec exemples
```

---

## Git

### Commandes rapides (aliases)

```bash
git st                   # status
git lg                   # log graph compact
git co ma-branche        # checkout
git sw ma-branche        # switch (moderne)
git br                   # branches
git ci -m "message"      # commit
git last                 # dernier commit
git unstage fichier      # retirer du staging
```

### Lazygit (interface interactive)

```bash
lg                       # ouvre lazygit dans le repo courant
```

Dans lazygit :
- **Tab 1-5** : switcher entre les panneaux (status, fichiers, branches, commits, stash)
- **Espace** : stage/unstage un fichier
- **c** : commit
- **p** : push
- **P** : pull
- **b** : branches
- **?** : aide complète

### Gittyup (interface graphique)

```bash
gittyup                  # ouvre l'interface GUI
```

---

## Docker

```bash
docker compose up -d     # démarrer les services
docker compose logs -f   # suivre les logs
docker compose down      # arrêter

lzd                      # lazydocker : interface interactive
```

Dans lazydocker : naviguer avec les flèches, Entrée pour les logs, `d` pour descendre dans un container.

---

## Neovim — l'essentiel

```bash
nvim fichier.py          # ouvrir un fichier
vi fichier.py            # alias → nvim
```

### Modes

- **Normal** (par défaut) : navigation, commandes
- **Insert** (`i`) : taper du texte
- **Visual** (`v`) : sélectionner
- **Echap** : revenir en mode Normal

### Survie (mode Normal)

```
i           Passer en mode insertion
Echap       Revenir en mode normal
:w          Sauvegarder
:q          Quitter
:wq         Sauvegarder et quitter
u           Annuler
Ctrl+r      Refaire
```

### Navigation

```
h/j/k/l     Gauche/Bas/Haut/Droite
gg          Début du fichier
G           Fin du fichier
w/b         Mot suivant/précédent
0/$         Début/fin de ligne
Ctrl+d/u    Demi-page bas/haut
```

### Édition rapide

```
dd          Supprimer la ligne
yy          Copier la ligne
p           Coller
ciw         Changer le mot sous le curseur (change inner word)
ci"         Changer le contenu entre guillemets
/mot        Chercher "mot" (n pour suivant, N pour précédent)
```

### Raccourcis custom (leader = Espace)

```
Espace+f    Chercher un fichier (telescope)
Espace+g    Grep dans les fichiers (telescope)
Espace+b    Buffers ouverts
Espace+r    Fichiers récents
Espace+/    Chercher dans le fichier courant
Espace+e    File tree (neo-tree)
Espace+w    Sauvegarder
Espace+q    Quitter
Espace+x    Sauvegarder et quitter
```

---

## API / HTTP

```bash
http GET httpbin.org/get                    # requête GET simple
http POST api.example.com/data name=Gurvan  # POST JSON
http -f POST api.example.com/form key=value # POST form
```

---

## Maintenance

```bash
tools-update --check     # vérifier les mises à jour de tous les outils
tools-update             # mode interactif : choisir quoi mettre à jour
sudo apt update && sudo apt upgrade  # pour les outils APT (docker, vscode, dbeaver, tmux)
```

---

## Raccourcis shell (zsh)

```
Ctrl+R      Recherche historique fuzzy (fzf)
Ctrl+T      Insérer un chemin de fichier (fzf)
Alt+C       Naviguer dans un dossier (fzf)
↑/↓         Historique filtré (tape un début puis flèche)
Tab         Complétion intelligente (fzf-tab)
```
