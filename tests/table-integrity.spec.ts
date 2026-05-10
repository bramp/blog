import { test, expect } from '@playwright/test';

test.describe('Table Integrity', () => {

  test('Tables should be rendered with the correct class', async ({ page }) => {
    // Visit a post with a table (Unrolling Loops)
    await page.goto('/post/2015/09/09/unrolling-loops-at-runtime-with-byte-buddy/');

    const table = page.locator('table.table');
    await expect(table).toBeVisible();

    // Verify it doesn't have sortable attributes by default
    const sortable = await table.getAttribute('data-sortable');
    expect(sortable).toBeNull();
  });

  test('Table content should be in the expected order', async ({ page }) => {
    await page.goto('/post/2015/09/09/unrolling-loops-at-runtime-with-byte-buddy/');

    const table = page.locator('table.table');
    const firstCell = await table.locator('tbody tr').first().locator('td').first().textContent();
    
    // In the markdown, the first row is "Loop"
    expect(firstCell).toContain('Loop');
  });
});
