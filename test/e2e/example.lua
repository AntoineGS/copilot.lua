local jobopts = { rpc = true, width = 80, height = 24 }

print("test")

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

  it("Can add up two numbers", function()
    local result = rpcrequest(nvim, "nvim_eval", "2 + 3")
    assert.is.equal(5, result)
  end)

  it("Sets a buffer file type", function()
    rpcrequest(nvim, "nvim_buf_set_option", 0, "filetype", "lua")
    local result = rpcrequest(nvim, "nvim_eval", "&filetype")
    assert.is.equal("lua", result)
  end)

  it("Creates new buffers with empty file type", function()
    local result = rpcrequest(nvim, "nvim_eval", "&filetype")
    assert.is.equal("", result)
  end)
end)
