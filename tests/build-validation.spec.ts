import { test, expect } from '@playwright/test';
import { existsSync, readdirSync } from 'fs';
import { join } from 'path';

// --- File Existence Checks ---
const criticalFiles = [
  'public/index.html',
  'public/404.html',
  'public/sitemap.xml',
  'public/robots.txt',
  'public/CNAME',
  'public/favicon.ico',
  'public/about-me/index.html',
  'public/post/index.html',
  'public/index.xml', // RSS
  // Sample Posts
  'public/post/2006/06/25/flvtool-a-command-line-flash-video-file-flv-editor/index.html',
  'public/post/2017/12/16/parsing-with-antlr4-and-go/index.html',
  'public/post/2015/08/07/introducing-hilbert/index.html',
  // Redirects
  'public/antlr4/index.html',
  'public/hilbert/index.html',
  'public/goredirects/index.html',
  // Assets
  'public/js/all.min.js',
  'public/css/all.min.css',
];

test.describe('Static Site Build Validation', () => {
  
  test('Critical files should exist', async () => {
    for (const file of criticalFiles) {
      const path = join(process.cwd(), file);
      // For assets, we expect a hash in the filename, so we check the directory
      if (file.includes('.min.js') || file.includes('.min.css')) {
          const dir = join(process.cwd(), file.split('/').slice(0, -1).join('/'));
          const fileName = file.split('/').pop() || '';
          const namePart = fileName.split('.').slice(0, -2).join('.'); // e.g. "all" from "all.min.js"
          const files = readdirSync(dir);
          if (!files.some(f => f.startsWith(namePart + '.') && (f.endsWith('.js') || f.endsWith('.css')))) {
              throw new Error(`Asset missing in ${dir}: ${file} (found: ${files.join(', ')})`);
          }
          continue;
      }
      if (!existsSync(path)) {
        throw new Error(`Critical file missing: ${file}`);
      }
    }
  });

  test('Homepage should render correctly', async ({ page }) => {
    await page.goto('/');
    await expect(page).toHaveTitle(/bramp.net/);
    await expect(page.locator('h2')).toContainText(/Welcome to my site/);
  });

  test('Sample blog post should render correctly', async ({ page }) => {
    await page.goto('/post/2006/06/25/flvtool-a-command-line-flash-video-file-flv-editor/');
    await expect(page.locator('h1')).toContainText(/flvtool\+\+/);
    await expect(page.locator('.post')).toBeVisible();
    
    // Verify CSS is loaded (by checking a style or existence of a class)
    const container = page.locator('.container.main');
    await expect(container).toBeVisible();
  });

  test('Go Redirects should contain meta tags', async ({ page }) => {
    // Fetch the HTML directly to avoid redirects/JS execution
    const response = await page.request.get('/antlr4/');
    expect(response.ok()).toBeTruthy();
    
    const html = await response.text();
    // Use regex to be flexible about quotes and attribute order
    expect(html).toMatch(/name=["']?go-import["']?/);
    expect(html).toMatch(/content=["']?bramp.net\/antlr4 git/);
  });

  // Track failed requests for LOCAL assets only
  test.beforeEach(async ({ page }) => {
    const isLocal = (url: string) => url.startsWith('http://localhost') || url.startsWith('https://blog.bramp.net');

    page.on('requestfailed', request => {
      const url = request.url();
      if (isLocal(url)) {
         console.error(`Request failed: ${url} (${request.failure()?.errorText})`);
         throw new Error(`Network request failed for local asset: ${url}`);
      }
    });
    
    page.on('response', response => {
      const url = response.url();
      if (response.status() >= 400 && isLocal(url)) {
        console.error(`Status ${response.status()} for ${url}`);
        throw new Error(`Status ${response.status()} for local asset: ${url}`);
      }
    });
  });
});
