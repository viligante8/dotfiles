local package_manager = require('utils.package-manager')

-- Helper function to create temporary test directories
local function create_test_dir(files)
  local test_dir = "/tmp/nvim_test_" .. math.random(10000, 99999)
  vim.fn.mkdir(test_dir, "p")
  
  for filename, content in pairs(files or {}) do
    local filepath = test_dir .. "/" .. filename
    local file = io.open(filepath, "w")
    if file then
      file:write(content or "")
      file:close()
    end
  end
  
  return test_dir
end

-- Helper function to cleanup test directories
local function cleanup_test_dir(test_dir)
  if test_dir and vim.fn.isdirectory(test_dir) == 1 then
    vim.fn.delete(test_dir, "rf")
  end
end

describe("package-manager", function()
  
  describe("detect_package_manager", function()
    
    it("should detect bun when bun.lockb exists", function()
      local test_dir = create_test_dir({
        ["bun.lockb"] = "",
        ["yarn.lock"] = "",
        ["package-lock.json"] = "",
        ["package.json"] = '{"name": "test"}'
      })
      
      local result = package_manager.detect_package_manager(test_dir)
      assert.are.equal("bun", result)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should detect yarn when yarn.lock exists and no bun.lockb", function()
      local test_dir = create_test_dir({
        ["yarn.lock"] = "",
        ["package-lock.json"] = "",
        ["package.json"] = '{"name": "test"}'
      })
      
      local result = package_manager.detect_package_manager(test_dir)
      assert.are.equal("yarn", result)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should detect npm when package-lock.json exists and no bun/yarn locks", function()
      local test_dir = create_test_dir({
        ["package-lock.json"] = "{}",
        ["package.json"] = '{"name": "test"}'
      })
      
      local result = package_manager.detect_package_manager(test_dir)
      assert.are.equal("npm", result)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should fallback to npm when only package.json exists", function()
      local test_dir = create_test_dir({
        ["package.json"] = '{"name": "test"}'
      })
      
      local result = package_manager.detect_package_manager(test_dir)
      assert.are.equal("npm", result)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should return unknown when no package files exist", function()
      -- Create a deep nested directory to avoid any parent package.json files
      local deep_test_dir = "/tmp/nvim_test_" .. math.random(10000, 99999) .. "/a/b/c/d/e"
      vim.fn.mkdir(deep_test_dir, "p")
      
      local result = package_manager.detect_package_manager(deep_test_dir)
      assert.are.equal("unknown", result)
      
      -- Clean up the entire tree
      local root_test_dir = deep_test_dir:match("(/tmp/nvim_test_[0-9]+)")
      if root_test_dir then
        vim.fn.delete(root_test_dir, "rf")
      end
    end)
    
    it("should handle directory paths without trailing slash", function()
      local test_dir = create_test_dir({
        ["package.json"] = '{"name": "test"}'
      })
      
      -- Remove trailing slash if present
      local dir_without_slash = test_dir:gsub("/$", "")
      local result = package_manager.detect_package_manager(dir_without_slash)
      assert.are.equal("npm", result)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should handle directory paths with trailing slash", function()
      local test_dir = create_test_dir({
        ["package.json"] = '{"name": "test"}'
      })
      
      -- Ensure trailing slash
      local dir_with_slash = test_dir .. "/"
      local result = package_manager.detect_package_manager(dir_with_slash)
      assert.are.equal("npm", result)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should use current working directory when cwd is nil", function()
      -- Mock vim.fn.getcwd to return a known directory
      local original_getcwd = vim.fn.getcwd
      local test_dir = create_test_dir({
        ["package.json"] = '{"name": "test"}'
      })
      
      vim.fn.getcwd = function() return test_dir end
      
      local result = package_manager.detect_package_manager()
      assert.are.equal("npm", result)
      
      -- Restore original function
      vim.fn.getcwd = original_getcwd
      cleanup_test_dir(test_dir)
    end)
    
    it("should handle non-existent directory gracefully", function()
      local non_existent_dir = "/tmp/non_existent_dir_" .. math.random(10000, 99999)
      local result = package_manager.detect_package_manager(non_existent_dir)
      assert.are.equal("unknown", result)
    end)
    
    it("should prioritize bun over yarn and npm", function()
      local test_dir = create_test_dir({
        ["bun.lockb"] = "",
        ["yarn.lock"] = "",
        ["package-lock.json"] = "",
        ["package.json"] = '{"name": "test"}'
      })
      
      local result = package_manager.detect_package_manager(test_dir)
      assert.are.equal("bun", result)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should prioritize yarn over npm when both exist", function()
      local test_dir = create_test_dir({
        ["yarn.lock"] = "",
        ["package-lock.json"] = "",
        ["package.json"] = '{"name": "test"}'
      })
      
      local result = package_manager.detect_package_manager(test_dir)
      assert.are.equal("yarn", result)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should handle empty lock files", function()
      local test_dir = create_test_dir({
        ["bun.lockb"] = "",
        ["package.json"] = '{"name": "test"}'
      })
      
      local result = package_manager.detect_package_manager(test_dir)
      assert.are.equal("bun", result)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should handle directories with special characters", function()
      local base_dir = "/tmp"
      local special_dir = base_dir .. "/test dir with spaces & symbols!"
      vim.fn.mkdir(special_dir, "p")
      
      local package_json_path = special_dir .. "/package.json"
      local file = io.open(package_json_path, "w")
      if file then
        file:write('{"name": "test"}')
        file:close()
      end
      
      local result = package_manager.detect_package_manager(special_dir)
      assert.are.equal("npm", result)
      
      vim.fn.delete(special_dir, "rf")
    end)
    
  end)
  
end)
