# Troubleshooting: 404 Error on volleyflow.net

Si estàs rebent un error 404 a `volleyflow.net`, segueix aquests passos:

## 1. Verificar Configuració a GitHub

### Verificar que GitHub Pages està activat:

1. Ves a: `https://github.com/PauBenetPrat/volleyflow/settings/pages`
2. Verifica:
   - **Source**: Ha de dir `GitHub Actions` (no "Deploy from a branch")
   - **Custom domain**: Ha de mostrar `volleyflow.net`
   - **Enforce HTTPS**: Hauria d'estar activat (si el SSL està llest)

### Verificar que hi ha hagut un deploy recent:

1. Ves a: `https://github.com/PauBenetPrat/volleyflow/actions`
2. Verifica que hi ha un workflow recent que ha completat amb èxit
3. Si hi ha errors, clica al workflow per veure els detalls

## 2. Verificar DNS

### Comprovar que el DNS està configurat correctament:

1. Ves a: https://www.whatsmydns.net/
2. Cerca: `volleyflow.net`
3. Verifica que els registres A mostren les IPs de GitHub:
   - `185.199.108.153`
   - `185.199.109.153`
   - `185.199.110.153`
   - `185.199.111.153`

### Si el DNS no està configurat:

1. Entra a Namecheap: https://ap.www.namecheap.com/
2. Ves a **Domain List** → **Manage** → **Advanced DNS**
3. Afegeix els 4 registres A com s'indica a DEPLOYMENT.md
4. Espera 15 minuts - 48 hores per la propagació

## 3. Verificar que l'app funciona a GitHub Pages

Abans de configurar el domini personalitzat, verifica que funciona amb la URL de GitHub:

1. Ves a: `https://paubenetprat.github.io/volleyflow/`
2. Si funciona aquí però no amb el domini personalitzat, el problema és la configuració del domini
3. Si no funciona aquí tampoc, el problema és el deploy

## 4. Forçar un nou deploy

Si tot està configurat però encara no funciona:

1. Ves a: `https://github.com/PauBenetPrat/volleyflow/actions`
2. Clica a "Build and Deploy to GitHub Pages"
3. Clica "Run workflow" → "Run workflow" (per forçar un nou deploy)

## 5. Verificar el domini a GitHub

Després de configurar el domini a Namecheap:

1. Ves a: `https://github.com/PauBenetPrat/volleyflow/settings/pages`
2. A la secció "Custom domain":
   - Escriu: `volleyflow.net`
   - Clica "Save"
3. Espera uns minuts
4. GitHub crearà automàticament un fitxer CNAME (no cal crear-lo manualment)

## 6. Verificar SSL Certificate

Després de configurar el domini:

1. Espera 10-30 minuts perquè GitHub generi el certificat SSL
2. Ves a: `https://github.com/PauBenetPrat/volleyflow/settings/pages`
3. Hauries de veure un checkmark verd al costat de "Enforce HTTPS"
4. Si no apareix, espera una mica més o verifica que el DNS està configurat correctament

## 7. Provar sense HTTPS

Si encara no funciona amb HTTPS:

1. Prova accedir a: `http://volleyflow.net` (sense la 's')
2. Si funciona aquí, el problema és el certificat SSL
3. Espera una mica més perquè GitHub generi el certificat

## 8. Verificar el contingut del deploy

Per verificar que el deploy ha funcionat:

1. Ves a: `https://github.com/PauBenetPrat/volleyflow/settings/pages`
2. A la part inferior, hauries de veure "Your site is live at..."
3. Si no apareix res, el deploy no s'ha completat

## Solució Ràpida

Si res funciona, prova aquests passos en ordre:

1. **Verifica DNS**: https://www.whatsmydns.net/ → Cerca `volleyflow.net`
2. **Verifica GitHub Pages**: Settings → Pages → Custom domain = `volleyflow.net`
3. **Força un nou deploy**: Actions → Run workflow
4. **Espera 30 minuts** per DNS + SSL
5. **Prova amb HTTP primer**: `http://volleyflow.net`
6. **Prova amb HTTPS després**: `https://volleyflow.net`

## Contacte

Si després de seguir tots aquests passos encara no funciona, comparteix:
- Screenshot de GitHub Settings → Pages
- Resultat de https://www.whatsmydns.net/ per volleyflow.net
- Logs del darrer workflow a GitHub Actions

