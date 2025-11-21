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

## Custom Domain Setup (volleyflow.net)

### Step 1: Configure DNS at Namecheap

1. Log in to your Namecheap account: https://ap.www.namecheap.com/
2. Go to **Domain List** and click **Manage** next to `volleyflow.net`
3. Go to the **Advanced DNS** tab
4. Add the following DNS records:

   **For the root domain (volleyflow.net):**
   - Type: `A Record`
   - Host: `@`
   - Value: `185.199.108.153`
   - TTL: Automatic (or 30 min)
   
   - Type: `A Record`
   - Host: `@`
   - Value: `185.199.109.153`
   - TTL: Automatic (or 30 min)
   
   - Type: `A Record`
   - Host: `@`
   - Value: `185.199.110.153`
   - TTL: Automatic (or 30 min)
   
   - Type: `A Record`
   - Host: `@`
   - Value: `185.199.111.153`
   - TTL: Automatic (or 30 min)

   **For www subdomain (www.volleyflow.net):**
   - Type: `CNAME Record`
   - Host: `www`
   - Value: `paubenetprat.github.io`
   - TTL: Automatic (or 30 min)

5. **Save** all changes

> **Note**: These are GitHub Pages' IP addresses. They may change, so check [GitHub's documentation](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site) for the latest IPs.

### Step 2: Configure Domain in GitHub

1. Go to your repository: `https://github.com/PauBenetPrat/volleyflow`
2. Navigate to **Settings** → **Pages**
3. Under **Custom domain**, enter: `volleyflow.net`
4. Check **Enforce HTTPS** (this will be available after DNS propagates)
5. Click **Save**

### Step 3: Wait for DNS Propagation

- DNS changes can take **15 minutes to 48 hours** to propagate
- You can check propagation status at: https://www.whatsmydns.net/
- Search for `volleyflow.net` and look for the A records to show the GitHub IPs

### Step 4: Verify SSL Certificate

- After DNS propagates, GitHub will automatically provision an SSL certificate
- This usually takes **10-30 minutes** after DNS is configured
- You'll see a green checkmark next to "Enforce HTTPS" when it's ready

### Step 5: Access Your App

Once everything is configured:
- **Main domain**: `https://volleyflow.net`
- **WWW subdomain**: `https://www.volleyflow.net` (optional, redirects to main)

### Troubleshooting Custom Domain

**Domain not working:**
- Wait 24-48 hours for full DNS propagation
- Verify A records are correct at https://www.whatsmydns.net/
- Check that the domain is correctly set in GitHub Settings → Pages

**SSL certificate not ready:**
- Wait 10-30 minutes after DNS is configured
- Make sure "Enforce HTTPS" is enabled in GitHub Settings → Pages
- Try accessing `http://volleyflow.net` first (without HTTPS)

**404 errors or black screen:**
- Make sure the `base-href` in the workflow is set to `"/"` (already configured)
- Clear your browser cache (Ctrl+Shift+Delete or Cmd+Shift+Delete)
- Try accessing in incognito/private mode
- Check browser console (F12) for JavaScript errors
- Verify that `404.html` exists in the build output (automatically copied by workflow)

**Debugging black screen:**
1. Open browser developer tools (F12)
2. Check the **Console** tab for JavaScript errors (red messages)
3. Check the **Network** tab to see if assets (JS, CSS, WASM files) are loading
   - Look for failed requests (red status codes)
   - Verify files are loading from `volleyflow.net`, not `github.io`
4. Verify the domain is correctly configured:
   - GitHub Settings → Pages → Custom domain should show `volleyflow.net`
   - "Enforce HTTPS" should be checked (after SSL is ready)
5. Try accessing `http://volleyflow.net` (without HTTPS) to rule out SSL issues
6. Check if the latest deployment completed successfully in GitHub Actions
