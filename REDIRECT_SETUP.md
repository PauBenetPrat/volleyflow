# Configuració de Redirecció: volleyflow.net → app.volleyflow.net

Aquest document explica com configurar el subdomini `app.volleyflow.net` i redirigir el tràfic de `volleyflow.net` a `app.volleyflow.net`.

## Pas 1: Configurar el subdomini `app.volleyflow.net` a Namecheap

1. Inicia sessió al teu compte de Namecheap: https://ap.www.namecheap.com/
2. Vés a **Domain List** i clica **Manage** al costat de `volleyflow.net`
3. Vés a la pestanya **Advanced DNS**
4. Afegeix el següent registre DNS per al subdomini `app`:

   **Per al subdomini app (app.volleyflow.net):**
   - Type: `CNAME Record`
   - Host: `app`
   - Value: `paubenetprat.github.io`
   - TTL: Automatic (o 30 min)

5. **Desa** els canvis

> **Nota**: El CNAME és més simple que els A records i és la forma recomanada per a subdominis a GitHub Pages.

## Pas 2: Configurar el domini personalitzat a GitHub

1. Vés al teu repositori: `https://github.com/PauBenetPrat/volleyflow`
2. Navega a **Settings** → **Pages**
3. Sota **Custom domain**, introdueix: `app.volleyflow.net`
4. Marca **Enforce HTTPS** (això estarà disponible després que el DNS es propagui)
5. Clica **Save**

## Pas 3: Esperar la propagació del DNS

- Els canvis de DNS poden trigar **15 minuts a 48 hores** a propagar-se
- Pots comprovar l'estat de propagació a: https://www.whatsmydns.net/
- Cerca `app.volleyflow.net` i comprova que el CNAME apunti a `paubenetprat.github.io`

## Pas 4: Verificar el certificat SSL

- Després que el DNS es propagui, GitHub proporcionarà automàticament un certificat SSL
- Això sol trigar **10-30 minuts** després de configurar el DNS
- Veuràs una marca de verificació verda al costat de "Enforce HTTPS" quan estigui llest

## Pas 5: Configurar la redirecció de volleyflow.net amb Namecheap

Per redirigir `volleyflow.net` a `app.volleyflow.net`, utilitzarem la redirecció DNS de Namecheap:

### Configuració a Namecheap

1. **Accedeix a la gestió del domini**:
   - Inicia sessió a Namecheap: https://ap.www.namecheap.com/
   - Vés a **Domain List** i clica **Manage** al costat de `volleyflow.net`
   - Vés a la pestanya **Advanced DNS**

2. **Elimina o desactiva els A records existents** (si n'hi ha):
   - Elimina els A records que apunten a les IPs de GitHub (185.199.108.153, etc.)
   - Això és necessari perquè la redirecció funcioni correctament

3. **Afegeix el registre de redirecció**:
   - Clica **Add New Record**
   - Type: **URL Redirect Record** (o **Redirect Domain**)
   - Host: `@` (per al domini principal `volleyflow.net`)
   - Value: `https://app.volleyflow.net`
   - Redirect Type: `301 Permanent Redirect` (recomanat per SEO)
   - TTL: Automatic (o 30 min)

4. **Desa els canvis**

> **Nota**: 
> - La redirecció pot trigar uns minuts a activar-se
> - Namecheap pot mostrar una pàgina intermediària de redirecció, però això és normal
> - Per HTTPS, Namecheap gestionarà el certificat automàticament

## Verificació Final

Després de configurar tot:

1. **Verifica `app.volleyflow.net`**:
   - Hauria de mostrar la teva app Flutter
   - Hauria de tenir HTTPS funcionant

2. **Verifica `volleyflow.net`**:
   - Hauria de redirigir automàticament a `app.volleyflow.net`
   - La redirecció hauria de ser transparent per als usuaris

## Troubleshooting

**El subdomini no funciona:**
- Espera 24-48 hores per a la propagació completa del DNS
- Verifica que el CNAME estigui correcte a https://www.whatsmydns.net/
- Comprova que el domini estigui configurat correctament a GitHub Settings → Pages

**La redirecció no funciona:**
- Espera uns minuts després de configurar la redirecció a Namecheap (pot trigar a activar-se)
- Verifica que el registre de redirecció estigui configurat correctament a Namecheap Advanced DNS
- Assegura't que no hi hagi A records actius que puguin interferir amb la redirecció
- Prova a accedir a `http://volleyflow.net` (sense HTTPS) per descartar problemes de certificat
- Si utilitzes HTTPS, Namecheap gestionarà el certificat automàticament, però pot trigar uns minuts

**Certificat SSL no llest:**
- Espera 10-30 minuts després de configurar el DNS
- Assegura't que "Enforce HTTPS" estigui habilitat a GitHub Settings → Pages
- Prova a accedir primer amb HTTP i després amb HTTPS

## Canvis Realitzats al Repositori

El workflow `.github/workflows/deploy-pages.yml` ha estat actualitzat per utilitzar `app.volleyflow.net` com a domini personalitzat. El fitxer CNAME es genera automàticament amb cada desplegament.

