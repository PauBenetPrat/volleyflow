# Deployment Guide

This project uses GitHub Actions to automatically build and deploy to **GitHub Pages** (100% free, no credit limits).

## Setup Instructions

### 1. Enable GitHub Pages

1. Go to your GitHub repository: `https://github.com/PauBenetPrat/volleyflow`
2. Navigate to **Settings** → **Pages**
3. Under **Source**, select:
   - **Source**: `GitHub Actions`
4. Save the settings

### 2. Push to GitHub

Once you push to the `main` branch, GitHub Actions will automatically:
1. Checkout your code
2. Setup Flutter
3. Install dependencies
4. Build the web app
5. Deploy to GitHub Pages

You can monitor the deployment in:
- **GitHub**: Actions tab in your repository
- **GitHub**: Settings → Pages (to see the deployment status)

### 3. Access Your App

After the first deployment, your app will be available at:
- `https://paubenetprat.github.io/volleyflow/`

The deployment usually takes 2-5 minutes. You'll receive an email notification when it's ready.

## Advantages of GitHub Pages

✅ **100% Free** - No credit limits or usage restrictions  
✅ **Unlimited Deploys** - Deploy as often as you want  
✅ **Fast CDN** - Global content delivery network  
✅ **HTTPS Included** - Automatic SSL certificates  
✅ **Custom Domain** - Support for custom domains (free)  
✅ **No Secrets Needed** - Works directly with GitHub  

## Manual Deployment

If you need to deploy manually:

```bash
# Build the web app
flutter build web --base-href "/volleyflow/"

# The build output will be in build/web/
# You can manually commit and push this folder to a gh-pages branch
```

## Troubleshooting

### Build fails with "flutter: command not found"
- Make sure the Flutter version in `.github/workflows/deploy-netlify.yml` matches your local version
- Check that the workflow file is correctly committed to your repository

### Pages not showing up
- Make sure GitHub Pages is enabled in Settings → Pages
- Check that the source is set to "GitHub Actions"
- Wait a few minutes after the first deployment (it can take time to propagate)

### 404 errors on navigation
- Make sure the `--base-href` flag matches your repository name
- If your repo is named differently, update the base-href in the workflow file

### Site not updating after deployment
- Check the GitHub Actions logs for errors
- Verify that the build completed successfully
- Check Settings → Pages for deployment status

## Custom Domain (Optional)

To use a custom domain:

1. Add a `CNAME` file in the `web/` folder with your domain name
2. Configure DNS records at your domain provider:
   - Type: `CNAME`
   - Name: `@` or `www`
   - Value: `paubenetprat.github.io`
3. In GitHub Settings → Pages, add your custom domain
4. GitHub will automatically configure SSL for your domain
