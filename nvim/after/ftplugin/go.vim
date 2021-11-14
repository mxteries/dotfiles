autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)
