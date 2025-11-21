# Verificació del Deploy a GitHub Pages

Si `https://paubenetprat.github.io/volleyflow/` no funciona, segueix aquests passos en ordre:

## Pas 1: Verificar que GitHub Pages està activat

1. Ves a: `https://github.com/PauBenetPrat/volleyflow/settings/pages`
2. **IMPORTANT**: Verifica que:
   - **Source** està configurat com: `GitHub Actions` (NO "Deploy from a branch")
   - Si diu "Deploy from a branch", **CANVIA-HO** a "GitHub Actions"
   - **Custom domain** pot estar buit o mostrar `volleyflow.net` (això està bé)

## Pas 2: Verificar que el workflow s'ha executat

1. Ves a: `https://github.com/PauBenetPrat/volleyflow/actions`
2. Busca el workflow "Build and Deploy to GitHub Pages"
3. Verifica:
   - Hi ha una execució recent? (darrers 10 minuts)
   - L'estat és verda (✓) o groc (⚠)?
   - Si és vermell (✗), clica per veure l'error

## Pas 3: Si no hi ha cap workflow recent

1. Ves a: `https://github.com/PauBenetPrat/volleyflow/actions`
2. Clica a "Build and Deploy to GitHub Pages" (a la llista de workflows)
3. Clica el botó "Run workflow" (dreta superior)
4. Deixa "Use workflow from" com "main"
5. Clica "Run workflow"
6. Espera 2-5 minuts

## Pas 4: Verificar que el deploy ha funcionat

1. Després d'esperar 2-5 minuts, ves a: `https://github.com/PauBenetPrat/volleyflow/settings/pages`
2. A la part inferior, hauries de veure:
   - "Your site is live at `https://paubenetprat.github.io/volleyflow/`"
   - O un missatge similar

## Pas 5: Si el workflow ha fallat

Si el workflow mostra errors:

1. Clica al workflow que ha fallat
2. Clica al job "build" que ha fallat
3. Expandeix els passos per veure on ha fallat
4. Errors comuns:
   - **"flutter: command not found"**: El workflow està correcte, potser cal esperar
   - **"Permission denied"**: Verifica que GitHub Pages està activat
   - **"404.html not found"**: El workflow hauria de copiar-lo automàticament

## Pas 6: Verificar el contingut del build

Per verificar que el build genera el contingut correcte:

1. Ves a: `https://github.com/PauBenetPrat/volleyflow/actions`
2. Clica al workflow més recent (que hagi completat)
3. Clica al job "build"
4. Expandeix "Build web"
5. Hauries de veure que ha compilat correctament

## Pas 7: Verificar que el fitxer existeix al repositori

1. Ves a: `https://github.com/PauBenetPrat/volleyflow`
2. Verifica que existeix: `.github/workflows/deploy-pages.yml`
3. Verifica que existeix: `web/404.html`

## Pas 8: Provar localment

Per verificar que el build funciona:

```bash
cd /Users/paubenetprat/git/flutter/volleyball_coaching_app
flutter build web --base-href "/volleyflow/"
```

Això hauria de generar una carpeta `build/web/` amb el contingut.

## Pas 9: Verificar la configuració del repositori

1. Ves a: `https://github.com/PauBenetPrat/volleyflow/settings`
2. Ves a "Actions" → "General"
3. Verifica que "Workflow permissions" està configurat com:
   - "Read and write permissions" (recomanat)
   - O "Read repository contents and packages permissions" amb "Allow GitHub Actions to create and approve pull requests" activat

## Solució Ràpida: Forçar un nou deploy

Si res funciona, prova això:

1. **Fes un petit canvi** al codi (afegir un espai a qualsevol fitxer)
2. **Commit i push**:
   ```bash
   git add .
   git commit -m "Trigger deployment"
   git push
   ```
3. **Espera 2-5 minuts**
4. **Verifica**: `https://paubenetprat.github.io/volleyflow/`

## Si encara no funciona

Comparteix aquesta informació:

1. Screenshot de `Settings → Pages` (mostrant el Source)
2. Screenshot de `Actions` (mostrant l'estat del workflow)
3. Si hi ha errors al workflow, copia el missatge d'error
4. Resultat de `https://paubenetprat.github.io/volleyflow/` (screenshot o descripció)

