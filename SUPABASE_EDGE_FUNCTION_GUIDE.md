# Guia: Afegir Funció Edge delete-user a Supabase

Aquesta guia t'explica com crear una funció Edge a Supabase per eliminar comptes d'usuari i totes les seves dades associades.

## Requisits Previs

- Compte de Supabase configurat
- Supabase CLI instal·lat (opcional, però recomanat)
- Accés al dashboard de Supabase

## Opció 1: Utilitzant el Dashboard de Supabase (Més Fàcil)

### Pas 1: Accedir a Edge Functions

1. Obre el teu projecte a [Supabase Dashboard](https://app.supabase.com)
2. Vés a **Edge Functions** al menú lateral
3. Fes clic a **Create a new function**

### Pas 2: Crear la Funció

1. **Nom de la funció**: `delete-user`
2. **Template**: Selecciona "Deno" o "TypeScript"
3. Fes clic a **Create function**

### Pas 3: Codi de la Funció

Substitueix el codi per defecte amb aquest:

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Get the authorization header
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: 'No authorization header' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Create Supabase client with service role key (for admin operations)
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false
        }
      }
    )

    // Get the user ID from the request body
    const { userId } = await req.json()
    
    if (!userId) {
      return new Response(
        JSON.stringify({ error: 'User ID is required' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Verify the user making the request matches the userId
    const token = authHeader.replace('Bearer ', '')
    const { data: { user }, error: userError } = await supabaseAdmin.auth.getUser(token)
    
    if (userError || !user || user.id !== userId) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized' }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Delete all user data from related tables
    // Ajusta aquestes taules segons la teva estructura de base de dades
    
    // Eliminar equips de l'usuari
    await supabaseAdmin
      .from('teams')
      .delete()
      .eq('user_id', userId)

    // Eliminar convocatòries de l'usuari
    await supabaseAdmin
      .from('match_rosters')
      .delete()
      .eq('user_id', userId)

    // Eliminar perfil de l'usuari (si tens una taula profiles)
    await supabaseAdmin
      .from('profiles')
      .delete()
      .eq('id', userId)

    // Finalment, eliminar l'usuari de l'autenticació
    const { error: deleteError } = await supabaseAdmin.auth.admin.deleteUser(userId)

    if (deleteError) {
      throw deleteError
    }

    return new Response(
      JSON.stringify({ success: true, message: 'Account deleted successfully' }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
```

### Pas 4: Configurar Variables d'Entorn

Les variables `SUPABASE_URL` i `SUPABASE_SERVICE_ROLE_KEY` s'assignen automàticament. Si no funcionen:

1. Vés a **Project Settings** → **API**
2. Copia el **Project URL** i **service_role key**
3. Vés a **Edge Functions** → **Settings**
4. Afegeix les variables d'entorn:
   - `SUPABASE_URL`: El teu Project URL
   - `SUPABASE_SERVICE_ROLE_KEY`: El teu service_role key (⚠️ **Mai** el compartis públicament!)

### Pas 5: Desplegar la Funció

1. Fes clic a **Deploy** per desplegar la funció
2. Espera que es completi el desplegament

## Opció 2: Utilitzant Supabase CLI (Recomanat per Desenvolupament)

### Pas 1: Instal·lar Supabase CLI

```bash
# macOS
brew install supabase/tap/supabase

# O amb npm
npm install -g supabase
```

### Pas 2: Inicialitzar el Projecte

```bash
# Inicia sessió
supabase login

# Enllaça el teu projecte
supabase link --project-ref your-project-ref
```

### Pas 3: Crear la Funció

```bash
# Crea una nova funció
supabase functions new delete-user
```

Això crearà un directori `supabase/functions/delete-user/` amb un fitxer `index.ts`.

### Pas 4: Afegir el Codi

Edita `supabase/functions/delete-user/index.ts` i afegeix el codi de l'Opció 1.

### Pas 5: Desplegar

```bash
# Desplega la funció
supabase functions deploy delete-user
```

## Verificació

### Provar la Funció Manualment

Pots provar la funció des del dashboard:

1. Vés a **Edge Functions** → **delete-user**
2. Fes clic a **Invoke**
3. Afegeix aquest JSON al body:
```json
{
  "userId": "user-uuid-here"
}
```
4. Afegeix l'Authorization header amb el token de l'usuari
5. Fes clic a **Invoke**

### Provar des de l'App Flutter

La funció ja està integrada al codi. Quan un usuari faci clic a "Delete Account", es cridarà automàticament.

## Seguretat Important

⚠️ **Assegura't que:**
- La funció verifica que l'usuari que fa la petició és el mateix que es vol eliminar
- Utilitzes el `service_role_key` només a la funció Edge (mai al client)
- Les taules que elimines són les correctes segons la teva estructura de base de dades

## Ajustar les Taules

Modifica la secció de eliminació de dades segons les teves taules:

```typescript
// Exemple: Si tens altres taules
await supabaseAdmin
  .from('taula_nom')
  .delete()
  .eq('user_id', userId)
```

## Troubleshooting

### Error: "No authorization header"
- Assegura't que l'app envia el token d'autenticació

### Error: "Unauthorized"
- Verifica que l'userId del body coincideix amb l'usuari autenticat

### Error: "Failed to delete account"
- Revisa els logs de la funció Edge al dashboard
- Verifica que les taules existeixen i tenen la columna `user_id`

## Recursos

- [Documentació de Supabase Edge Functions](https://supabase.com/docs/guides/functions)
- [Supabase Auth Admin API](https://supabase.com/docs/reference/javascript/auth-admin-deleteuser)


