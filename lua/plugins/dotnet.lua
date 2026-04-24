return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                csharp_ls = {
                    cmd = { "csharp-ls" },
                    root_dir = function(bufnr)
                        local fname = vim.api.nvim_buf_get_name(bufnr)
                        return require("lspconfig.util").root_pattern("*.sln", "*.slnx", "*.csproj")(fname)
                            or require("lspconfig.util").find_git_ancestor(fname)
                            or vim.uv.cwd()
                    end,
                },
            },
        },
    },
}
