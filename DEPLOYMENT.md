# Deployment Guide

This project uses GitHub Actions to automatically build and deploy to Netlify.

## Setup Instructions

### 1. Get Netlify Credentials

1. Go to [Netlify](https://app.netlify.com/)
2. Navigate to **User settings** → **Applications** → **New access token**
3. Create a new token and copy it (this is your `NETLIFY_AUTH_TOKEN`)
4. Go to your site settings → **General** → **Site details**
5. Copy your **Site ID** (this is your `NETLIFY_SITE_ID`)

### 2. Configure GitHub Secrets

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret** and add:

   - **Name**: `NETLIFY_AUTH_TOKEN`
   - **Value**: The token you copied from Netlify

4. Click **New repository secret** again and add:

   - **Name**: `NETLIFY_SITE_ID`
   - **Value**: The Site ID you copied from Netlify

### 3. Configure Netlify Build Settings

1. Go to your Netlify site dashboard
2. Navigate to **Site settings** → **Build & deploy** → **Build settings**
3. **Disable** the build command (leave it empty or set to `echo "Build handled by GitHub Actions"`)
4. Set **Publish directory** to: `build/web` (this won't be used since we deploy via GitHub Actions, but it's good to have it set)

### 4. Push to GitHub

Once you push to the `main` branch, GitHub Actions will automatically:
1. Checkout your code
2. Setup Flutter
3. Install dependencies
4. Build the web app
5. Deploy to Netlify

You can monitor the deployment in:
- **GitHub**: Actions tab in your repository
- **Netlify**: Deploys tab in your site dashboard

## Manual Deployment

If you need to deploy manually:

```bash
# Build the web app
flutter build web

# The build output will be in build/web/
# You can manually upload this folder to Netlify via drag & drop
```

## Troubleshooting

### Build fails with "flutter: command not found"
- Make sure the Flutter version in `.github/workflows/deploy-netlify.yml` matches your local version
- Check that the workflow file is correctly committed to your repository

### Deployment fails with authentication error
- Verify that `NETLIFY_AUTH_TOKEN` and `NETLIFY_SITE_ID` are correctly set in GitHub Secrets
- Make sure the token hasn't expired (create a new one if needed)

### Site not updating after deployment
- Check the GitHub Actions logs for errors
- Verify that the build completed successfully
- Check Netlify deploy logs for any issues

