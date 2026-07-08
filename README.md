# DevMar - Jeu Style GTA 5

Un jeu 3D de style GTA 5 créé avec Godot 4.0.

## 🎮 Fonctionnalités

✅ **Joueur**
- Mouvement avec ZQSD
- Sprint avec MAJ
- Saut avec ESPACE
- Caméra contrôlée par souris
- Inventaire d'armes

✅ **Armes**
- Pistolet (Contrôle 1 pour équiper)
- Tir au clic gauche ou touche F
- Système de dégâts aux NPCs

✅ **NPCs**
- **Civils** (Gris) : Patrouille aléatoire
- **Policiers** (Bleu) : Patrouille normale, poursuite si joueur détecté

✅ **Système de Quête**
- Poursuites policières quand vous tirez sur les NPCs
- Policiers attaquent le joueur en cas d'alerte

✅ **Conduite** (à implémenter)
- Système de véhicules
- Gravité et physique réalistes

## 🚀 Installation

1. **Télécharger Godot 4.0+** : https://godotengine.org/
2. **Cloner le dépôt**
3. **Ouvrir le projet dans Godot**
4. **Lancer la scène main.tscn**

## 🎮 Commandes

| Touche | Action |
|--------|--------|
| ZQSD | Mouvement |
| ESPACE | Sauter |
| MAJ | Sprint |
| SOURIS | Regarder |
| CLIC GAUCHE | Tirer |
| F | Tirer (alternatif) |
| 1 | Équiper pistolet |
| 0 | Désarmer |
| ESC | Montrer souris |

## 📁 Structure

```
devmar/
├── scenes/
│   └── main.gd          # Scène principale
├── scripts/
│   ├── player.gd        # Contrôle joueur
│   ├── npc.gd          # Comportement NPC
│   └── npc_spawner.gd  # Générateur NPCs
├── project.godot       # Configuration Godot
└── README.md          # Ce fichier
```

## 🔧 À Implémenter

- [ ] Système de véhicules/conduite
- [ ] Quêtes générées aléatoirement
- [ ] Système de niveau de criminalité
- [ ] Animations
- [ ] Effets sonores et musique
- [ ] UI améliorée
- [ ] Sauvegarde/Chargement
- [ ] Plus d'armes

## 📝 Licence

MIT

---

**Créé par**: wahbi2560-cmd  
**Moteur**: Godot Engine 4.0+
