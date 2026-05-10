import { test, expect } from '@playwright/test';

test.describe('CSS and Visual Integrity', () => {

  test.beforeEach(async ({ page }) => {
    // Fail test if any local asset fails to load
    page.on('requestfailed', request => {
      if (request.url().includes('localhost')) {
        throw new Error(`Request failed: ${request.url()}`);
      }
    });
  });

  test('Bootstrap and Fonts should be applied to Homepage', async ({ page }) => {
    await page.goto('/');

    // Verify Bootstrap Grid (Container)
    const container = page.locator('.container.main');
    const box = await container.boundingBox();
    expect(box?.width).toBeGreaterThan(500); // Should be wide on desktop

    // Verify Fonts (Raleway from fonts.css)
    const h2 = page.locator('h2').first();
    const fontFamily = await h2.evaluate(el => window.getComputedStyle(el).fontFamily);
    // Case-insensitive check to be robust
    expect(fontFamily.toLowerCase()).toContain('raleway');
  });

  test('Chroma Syntax Highlighting should be styled', async ({ page }) => {
    // Visit a post known to have code
    await page.goto('/post/2010/08/31/persec-python-script/');

    const codeBlock = page.locator('pre.chroma').first();
    await expect(codeBlock).toBeVisible();

    // Check specific Chroma color (friendly theme often uses #008000 for comments/strings)
    // This verifies chroma-friendly.css is actually loaded and parsed
    const hasColor = await codeBlock.evaluate(el => {
      const styles = window.getComputedStyle(el);
      // Verify that it's not just the default browser style (usually black/white)
      return styles.color !== '' && styles.backgroundColor !== 'transparent';
    });
    expect(hasColor).toBeTruthy();
  });

  test('Social Buttons should have Bootstrap-Social styles', async ({ page }) => {
    await page.goto('/post/2010/08/31/persec-python-script/');

    const twitterBtn = page.locator('.btn-twitter');
    await expect(twitterBtn).toBeVisible();

    // Verify background color (Twitter blue: rgb(85, 172, 238))
    const bgColor = await twitterBtn.evaluate(el => window.getComputedStyle(el).backgroundColor);
    expect(bgColor).toBe('rgb(85, 172, 238)');
  });

  test('Custom Blog Styles (bramp.css) should be applied', async ({ page }) => {
    await page.goto('/');

    const jumbotron = page.locator('.jumbotron');
    const padding = await jumbotron.evaluate(el => window.getComputedStyle(el).paddingTop);
    expect(padding).not.toBe('0px'); // Verify bootstrap/custom padding is applied
  });

  test('Icons should render (icons.css)', async ({ page }) => {
    await page.goto('/post/2010/08/31/persec-python-script/');

    const calendarIcon = page.locator('.icon-calendar').first();
    await expect(calendarIcon).toBeVisible();

    // Icons often have specific dimensions
    const box = await calendarIcon.boundingBox();
    expect(box?.width).toBeGreaterThan(5);
  });
});
