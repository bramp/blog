import { test, expect } from '@playwright/test';

test.describe('Visual Integrity', () => {

  test('Homepage should have a navbar and footer', async ({ page }) => {
    await page.goto('/');

    const navbar = page.locator('nav.navbar');
    await expect(navbar).toBeVisible();

    const footer = page.locator('footer');
    await expect(footer).toBeVisible();
  });

  test('Navbar should contain the author name', async ({ page }) => {
    await page.goto('/');
    const title = page.locator('.navbar-brand [itemprop="name"]');
    await expect(title).toContainText('Andrew Brampton');
  });

  test('Main content area should be present', async ({ page }) => {
    await page.goto('/');
    const main = page.locator('main');
    await expect(main).toBeVisible();
  });

  test('Post pages should have a title and date', async ({ page }) => {
    await page.goto('/post/2015/09/09/unrolling-loops-at-runtime-with-byte-buddy/');
    
    const h1 = page.locator('h1');
    await expect(h1).toBeVisible();
    await expect(h1).not.toBeEmpty();

    const date = page.locator('time');
    await expect(date).toBeVisible();
  });
});
