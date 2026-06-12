# Database Connection

The frontend can now switch between real Supabase data and local dummy JSON from the fixed Developer Menu in the lower-right corner.

## Connect Supabase

1. Create or open a Supabase project.
2. In the Supabase SQL editor, run `backend/supabase/schema.sql`.
3. Run `backend/supabase/seed_day2.sql` if you want the Day 2 demo dataset loaded into Supabase.
4. Create `frontend/.env.local` with:

```env
NEXT_PUBLIC_USE_DEMO_DATA=false
NEXT_PUBLIC_SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

5. Restart the frontend dev server so Next.js picks up the new env vars.
6. Open the dashboard and set Developer Menu > Source to `Real data (Supabase)`.

Only use the public anon key in the frontend. Do not put a Supabase service role key in `NEXT_PUBLIC_*` variables.

## Developer Menu Modes

- `Auto fallback`: uses Supabase when it is configured and the data passes the Day 2 readiness checks, otherwise falls back to local JSON.
- `Real data (Supabase)`: attempts Supabase directly. If the request fails, the dashboard falls back to dummy data and shows the `Dummy` badge.
- `Dummy data (local JSON)`: always uses files from `frontend/public/demo`.

The live dashboard expects these Supabase objects from the schema: `latest_block_risk`, `latest_scouting_priority`, and `field_reports`.
