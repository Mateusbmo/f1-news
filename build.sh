#!/bin/bash
   # Exit on any error
   set -e

   # Install dependencies
   mix deps.get --only prod

   # Compile the app
   MIX_ENV=prod mix compile

   # Compile assets
   npm install --prefix assets
   npm run deploy --prefix assets
   MIX_ENV=prod mix phx.digest

   # Run migrations
   MIX_ENV=prod mix ecto.migrate

   # Build the release
   MIX_ENV=prod mix release