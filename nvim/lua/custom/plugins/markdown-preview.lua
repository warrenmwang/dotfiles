-- TODO: find a better plugin for markdown preview
-- this plugin is fucking ass. this is broken. there are hacky solutions in the github issues.
-- but what's the point if it breaks at each Lazy update.
return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = function()
    if vim.fn.has 'win32' == 1 then
      -- return 'cd app; npx --yes yarn install'
      return 'npm install'
    else
      -- return 'cd app && npx --yes yarn install'
      return 'npm install'
    end
  end,
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
  end,
  ft = { 'markdown' },
  event = 'BufRead',
}
