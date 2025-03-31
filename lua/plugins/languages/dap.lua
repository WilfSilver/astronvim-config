local ac = require "autocommands"
---@type LazySpec
return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    cmd = { "DapInstall", "DapUninstall" },
    config = function()
      require("mason-nvim-dap").setup {
        automatic_installation = true,
      }
    end,
  },

  {
    dependencies = { "mfussenegger/nvim-dap" },
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function() require("dap-python").setup "/usr/bin/python" end,
  },

  {
    dependencies = { "mfussenegger/nvim-dap" },
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      -- Taken from https://medium.com/@chrisatmachine/lunarvim-as-a-java-ide-da65c4a77fb4
      local jdtls = require "jdtls"
      local home = os.getenv "HOME"
      local workspace_path = home .. "/.local/share/lunarvim/jdtls-workspace/"
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local workspace_dir = workspace_path .. project_name

      local os_config = "linux"
      if vim.fn.has "mac" == 1 then os_config = "mac" end

      local capabilities = require("lvim.lsp").common_capabilities()
      local extendedClientCapabilities = jdtls.extendedClientCapabilities
      extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

      local bundles = {}
      local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")

      -- vim.list_extend(bundles,
      --   vim.split(
      --     vim.fn.glob(
      --       home .. "/git/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
      --       true), "\n"))
      -- vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/git/vscode-java-test/server/*.jar", true), "\n"))
      vim.list_extend(
        bundles,
        vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar", true), "\n")
      )
      vim.list_extend(
        bundles,
        vim.split(
          vim.fn.glob(
            mason_path .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
            true
          ),
          "\n"
        )
      )

      -- lvim.builtin.dap.active = true
      local config = {
        cmd = {
          "java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xms1g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens",
          "java.base/java.util=ALL-UNNAMED",
          "--add-opens",
          "java.base/java.lang=ALL-UNNAMED",
          "-javaagent:" .. mason_path .. "packages/jdtls/lombok.jar",
          "-jar",
          vim.fn.glob(mason_path .. "packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
          "-configuration",
          mason_path .. "packages/jdtls/config_" .. os_config,
          "-data",
          workspace_dir,
        },
        root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
        capabilities = capabilities,

        settings = {
          java = {
            eclipse = {
              downloadSources = true,
            },
            configuration = {
              updateBuildConfiguration = "interactive",
              runtimes = {
                {
                  name = "JavaSE-21",
                  path = "/usr/lib/jvm/java-21-openjdk/",
                  -- path = home .. "/.sdkman/candidates/java/21.0.1-tem/",
                },
              },
            },
            maven = {
              downloadSources = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            references = {
              includeDecompiledSources = true,
            },
            inlayHints = {
              parameterNames = {
                enabled = "all", -- literals, all, none
              },
            },
            format = {
              enabled = false,
            },
          },
          signatureHelp = { enabled = true },
          extendedClientCapabilities = extendedClientCapabilities,
        },
        init_options = {
          bundles = bundles,
        },

        on_attach = function(client, bufnr)
          local _, _ = pcall(vim.lsp.codelens.refresh)
          jdtls.setup_dap { hotcodereplace = "auto" }
          require("lvim.lsp").on_attach(client, bufnr)
          local status_ok, jdtls_dap = pcall(require, "jdtls.dap")
          vim.print "Loading Java DAP"
          if status_ok then
            jdtls_dap.setup_dap_main_class_configs()
          else
            vim.print "Could not load jdtls.dap"
          end
        end,
      }

      ac.add {
        { "BufWritePost" },
        {
          pattern = { "*.java" },
          callback = function()
            local _, _ = pcall(vim.lsp.codelens.refresh)
          end,
        },
      }

      jdtls.start_or_attach(config)
    end,
  },

  -- {
  --   "HUAHUAI23/telescope-dapzzzz",
  --   config = function()
  --     require("telescope").load_extension "i23"
  --     keys.add_key("n", "dl", { require("telescope").extensions.i23.dap23, "Load launch.js" })
  --   end,
  -- },
}
