require("packer").startup(function(use)
    use("wbthomason/packer.nvim")
    use({
        "catppuccin/nvim",
        as = "catppuccin",
        config = function()
            vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
            require("catppuccin").setup()
            vim.cmd([[colorscheme catppuccin]])
        end
    })
    use("sheerun/vim-polyglot")
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate | TSEnable highlight",
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false
                }
            })
        end
    })
    use("nvim-treesitter/playground")
    -- https://github.com/tpope/vim-sensible
    use("tpope/vim-sensible")
    -- https://github.com/github/copilot.vim
    use("github/copilot.vim")
    -- spell checking, use Zl for list of replacements, Zg to add, Zt to toggle
    use({"kamykn/spelunker.vim", requires = {"kamykn/popup-menu.nvim"}})
    -- show git status on lines
    use({
        "lewis6991/gitsigns.nvim",
        config = function() require("gitsigns").setup() end
    })
    -- Git support
    use("tpope/vim-fugitive")
    -- Github support, :Gbrowse and <C-X><C-O> for omnicomplete
    use("tpope/vim-rhubarb")
    -- navigate tmux panes with <C-movement> keys
    use("christoomey/vim-tmux-navigator")
    -- needed for telescope
    use({
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/plenary.nvim", "BurntSushi/ripgrep",
            "nvim-telescope/telescope-fzf-native.nvim",
            "nvim-telescope/telescope-github.nvim", "sharkdp/fd",
            "kyazdani42/nvim-web-devicons",
            "nvim-telescope/telescope-ui-select.nvim",
            {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
        },
        config = function() require("plugin.telescope") end
    })
    use({
        "nvim-telescope/telescope-frecency.nvim",
        requires = {"tami5/sqlite.lua"}
    })
    use({
        "nvim-telescope/telescope-symbols.nvim",
        requires = {"nvim-telescope/telescope.nvim"}
    })
    -- this updates inputs and pickers to be good looking
    use("stevearc/dressing.nvim")
    -- LSP
    use({
        "williamboman/mason.nvim",
        config = function() require("mason").setup() end
    })
    use({
        "williamboman/mason-lspconfig.nvim",
        requires = {"williamboman/mason.nvim", "neovim/nvim-lspconfig"},
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()
        end
    })
    use({"neovim/nvim-lspconfig", config = function() require("plugin.lsp") end})
    -- auto-complete
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline", "hrsh7th/cmp-vsnip", "hrsh7th/vim-vsnip"
        },
        config = function() require("plugin.nvim-cmp") end
    })

    -- statusline stuff
    use({
        "nvim-lualine/lualine.nvim",
        config = function() require("lualine").setup() end,
        requires = {"kyazdani42/nvim-web-devicons"}
    })
    -- file explorer
    use({
        "kyazdani42/nvim-tree.lua",
        config = function() require("plugin.nvim-tree") end,
        requires = {"kyazdani42/nvim-web-devicons"}
    })

    use({
        "jose-elias-alvarez/typescript.nvim",
        config = function() require("plugin.typescript") end
    })
    -- dashboard
    use({
        "goolord/alpha-nvim",
        config = function()
            require("alpha").setup(require("alpha.themes.startify").config)
        end,
        requires = {"kyazdani42/nvim-web-devicons"}
    })
    -- nice override of the vim.notify function
    use({
        "rcarriga/nvim-notify",
        run = function() vim.notify = require("notify") end
    })
    -- easymotion style jumps, overrides s|S for in buffer jumps and gs for cross
    -- buffer
    use({
        "ggandor/leap.nvim",
        config = function() require("leap").set_default_keymaps() end,
        requires = {"tpope/vim-repeat"}
    })
    -- gcc or gc[move] to toggle comments
    use({
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup() end
    })
    use("folke/lsp-colors.nvim")
    use({
        "renerocksai/telekasten.nvim",
        config = function() require("plugin.telekasten") end
    })

    use({
        "folke/zen-mode.nvim",
        config = function() require("zen-mode").setup() end
    })
    use("pantharshit00/vim-prisma")

    use({
        "ruifm/gitlinker.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function() require("gitlinker").setup() end
    })
    use({
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim", "haydenmeade/neotest-jest"
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-jest")({jestCommand = "yarn run jest --"})
                }
            })
        end
    })
    use({
        "jbyuki/venn.nvim",
        config = function()
            local toggle = function()
                local venn_enabled = vim.inspect(vim.b.venn_enabled)
                if venn_enabled == "nil" then
                    vim.b.venn_enabled = true
                    vim.cmd([[setlocal ve=all]])
                    -- draw a line on HJKL keystrokes
                    vim.keymap.set({"n"}, "J", "<C-v>j:VBox<CR>",
                                   {buffer = true})
                    vim.keymap.set({"n"}, "K", "<C-v>k:VBox<CR>",
                                   {buffer = true})
                    vim.keymap.set({"n"}, "L", "<C-v>l:VBox<CR>",
                                   {buffer = true})
                    vim.keymap.set({"n"}, "H", "<C-v>h:VBox<CR>",
                                   {buffer = true})
                    vim.keymap.set({"v"}, "f", ":VBox<CR>", {buffer = true})
                else
                    vim.cmd([[setlocal ve=]])
                    vim.cmd([[mapclear <buffer>]])
                    vim.b.venn_enabled = nil
                end
            end
            vim.keymap.set("n", "<leader>v", toggle)
        end
    })
    --[[ plugins to try but who has the time?
	-- like a git status ui thing
	TimUntersberger/neogit
	-- better diff view stuff
	sindrets/diffview.nvim
	-- another git suite thing
	tanvirtin/vgit.nvim
	-- markdown to table of contents
	mzlogin/vim-markdown-toc
	-- add a 1s delay to any hjkl movement
	takac/vim-hardtime
--]]
end)
