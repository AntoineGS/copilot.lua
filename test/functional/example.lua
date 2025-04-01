local jobopts = { rpc = true, width = 80, height = 24 }

describe("Math in Vim script", function()
  local nvim -- Channel of the embedded Neovim process

  before_each(function()
    -- Start a new Neovim process
    nvim = vim.fn.jobstart({ "nvim", "--embed", "--headless" }, jobopts)
  end)

  after_each(function()
    -- Terminate the Neovim process
    vim.fn.jobstop(nvim)
  end)

  it("Outputs the correct info", function()
    local result = vim.api.nvim_exec2("Copilot status", {})
    assert.True(type(result) == "string")
    assert.True(string.match(result, "ERROR.*setup is not called yet"))
  end)

  it("Can add up two numbers", function()
    local result = vim.rpcrequest(nvim, "nvim_eval", "2 + 3")
    assert.is.equal(5, result)
  end)

  it("Sets a buffer file type", function()
    vim.rpcrequest(nvim, "nvim_buf_set_option", 0, "filetype", "lua")
    local result = vim.rpcrequest(nvim, "nvim_eval", "&filetype")
    assert.is.equal("lua", result)
  end)

  it("Creates new buffers with empty file type", function()
    local result = vim.rpcrequest(nvim, "nvim_eval", "&filetype")
    assert.is.equal("", result)
  end)
end)
