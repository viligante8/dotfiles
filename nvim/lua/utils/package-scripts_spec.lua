local package_scripts = require('utils.package-scripts')

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

describe("package-scripts", function()
  
  describe("get_script_icon", function()
    
    it("should return correct icons for known categories", function()
      assert.are.equal('▶️', package_scripts.get_script_icon('start'))
      assert.are.equal('🧪', package_scripts.get_script_icon('test'))
      assert.are.equal('🔨', package_scripts.get_script_icon('build'))
      assert.are.equal('🔍', package_scripts.get_script_icon('lint'))
      assert.are.equal('✨', package_scripts.get_script_icon('format'))
      assert.are.equal('🚀', package_scripts.get_script_icon('deploy'))
      assert.are.equal('🧹', package_scripts.get_script_icon('clean'))
      assert.are.equal('👀', package_scripts.get_script_icon('watch'))
      assert.are.equal('📚', package_scripts.get_script_icon('docs'))
      assert.are.equal('📦', package_scripts.get_script_icon('install'))
      assert.are.equal('🐛', package_scripts.get_script_icon('debug'))
      assert.are.equal('⚙️', package_scripts.get_script_icon('lifecycle'))
    end)
    
    it("should return unknown icon for unrecognized category", function()
      assert.are.equal('📄', package_scripts.get_script_icon('unknown'))
      assert.are.equal('📄', package_scripts.get_script_icon('nonexistent'))
      assert.are.equal('📄', package_scripts.get_script_icon(''))
    end)
    
  end)
  
  describe("get_categories", function()
    
    it("should return all available categories", function()
      local categories = package_scripts.get_categories()
      
      -- Check that essential categories are present
      local expected_categories = {
        'start', 'test', 'build', 'lint', 'format', 'deploy',
        'clean', 'watch', 'docs', 'install', 'debug', 'lifecycle', 'unknown'
      }
      
      for _, expected in ipairs(expected_categories) do
        local found = false
        for _, category in ipairs(categories) do
          if category == expected then
            found = true
            break
          end
        end
        assert.is_true(found, "Category '" .. expected .. "' not found in categories list")
      end
    end)
    
  end)
  
  describe("get_package_scripts", function()
    
    it("should return error when package.json is missing", function()
      local test_dir = create_test_dir({})
      
      local scripts, error = package_scripts.get_package_scripts(test_dir)
      assert.is_nil(scripts)
      assert.is_not_nil(error)
      assert.is_true(error:find("No package.json found") ~= nil)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should return error for invalid JSON", function()
      local test_dir = create_test_dir({
        ["package.json"] = '{"name": "test", invalid json}'
      })
      
      local scripts, error = package_scripts.get_package_scripts(test_dir)
      assert.is_nil(scripts)
      assert.is_not_nil(error)
      assert.is_true(error:find("Invalid JSON") ~= nil)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should return empty array when package.json has no scripts", function()
      local test_dir = create_test_dir({
        ["package.json"] = '{"name": "test", "version": "1.0.0"}'
      })
      
      local scripts, error = package_scripts.get_package_scripts(test_dir)
      assert.is_nil(error)
      assert.is_not_nil(scripts)
      assert.are.equal(0, #scripts)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should return empty array when scripts field is not a table", function()
      local test_dir = create_test_dir({
        ["package.json"] = '{"name": "test", "scripts": "not a table"}'
      })
      
      local scripts, error = package_scripts.get_package_scripts(test_dir)
      assert.is_nil(error)
      assert.is_not_nil(scripts)
      assert.are.equal(0, #scripts)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should parse scripts correctly with proper categorization", function()
      local test_dir = create_test_dir({
        ["package.json"] = [[{
          "name": "test",
          "scripts": {
            "start": "node index.js",
            "test": "jest",
            "build": "webpack",
            "lint": "eslint .",
            "debug": "node --inspect index.js",
            "custom-script": "echo hello"
          }
        }]]
      })
      
      local filter_options = { exclude_lifecycle = false } -- Override default to include all scripts
      local scripts, error = package_scripts.get_package_scripts(test_dir, filter_options)
      assert.is_nil(error)
      assert.is_not_nil(scripts)
      assert.are.equal(6, #scripts)
      
      -- Find specific scripts and check their properties
      local script_map = {}
      for _, script in ipairs(scripts) do
        script_map[script.name] = script
      end
      
      assert.is_not_nil(script_map["start"])
      assert.are.equal("start", script_map["start"].category)
      assert.are.equal("node index.js", script_map["start"].command)
      assert.is_false(script_map["start"].is_lifecycle)
      
      assert.is_not_nil(script_map["test"])
      assert.are.equal("test", script_map["test"].category)
      
      assert.is_not_nil(script_map["build"])
      assert.are.equal("build", script_map["build"].category)
      
      assert.is_not_nil(script_map["debug"])
      assert.are.equal("debug", script_map["debug"].category)
      assert.is_true(script_map["debug"].is_debug)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should identify lifecycle scripts correctly", function()
      local test_dir = create_test_dir({
        ["package.json"] = [[{
          "name": "test",
          "scripts": {
            "preinstall": "echo preinstall",
            "install": "echo install",
            "postinstall": "echo postinstall",
            "pretest": "echo pretest",
            "posttest": "echo posttest"
          }
        }]]
      })
      
      local filter_options = { exclude_lifecycle = false } -- Override default to include lifecycle scripts
      local scripts, error = package_scripts.get_package_scripts(test_dir, filter_options)
      assert.is_nil(error)
      assert.is_not_nil(scripts)
      
      -- All scripts should be marked as lifecycle
      for _, script in ipairs(scripts) do
        assert.is_true(script.is_lifecycle)
        assert.are.equal("lifecycle", script.category)
      end
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should exclude lifecycle scripts when filter option is set", function()
      local test_dir = create_test_dir({
        ["package.json"] = [[{
          "name": "test",
          "scripts": {
            "preinstall": "echo preinstall",
            "start": "node index.js",
            "test": "jest"
          }
        }]]
      })
      
      -- Default behavior excludes lifecycle scripts, so we don't need to set exclude_lifecycle = true
      local scripts, error = package_scripts.get_package_scripts(test_dir)
      assert.is_nil(error)
      assert.is_not_nil(scripts)
      assert.are.equal(2, #scripts) -- Only start and test, preinstall excluded
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should exclude debug scripts when filter option is set", function()
      local test_dir = create_test_dir({
        ["package.json"] = [[{
          "name": "test",
          "scripts": {
            "start": "node index.js",
            "debug": "node --inspect index.js",
            "test": "jest"
          }
        }]]
      })
      
      local filter_options = { exclude_debug = true }
      local scripts, error = package_scripts.get_package_scripts(test_dir, filter_options)
      assert.is_nil(error)
      assert.is_not_nil(scripts)
      assert.are.equal(2, #scripts) -- Only start and test, debug excluded
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should filter by include patterns", function()
      local test_dir = create_test_dir({
        ["package.json"] = [[{
          "name": "test",
          "scripts": {
            "start": "node index.js",
            "test": "jest",
            "build": "webpack",
            "lint": "eslint ."
          }
        }]]
      })
      
      local filter_options = { include_patterns = { "^test", "^build" } }
      local scripts, error = package_scripts.get_package_scripts(test_dir, filter_options)
      assert.is_nil(error)
      assert.is_not_nil(scripts)
      assert.are.equal(2, #scripts) -- Only test and build
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should filter by exclude patterns", function()
      local test_dir = create_test_dir({
        ["package.json"] = [[{
          "name": "test",
          "scripts": {
            "start": "node index.js",
            "test": "jest",
            "build": "webpack",
            "lint": "eslint ."
          }
        }]]
      })
      
      local filter_options = { exclude_patterns = { "^test", "^lint" } }
      local scripts, error = package_scripts.get_package_scripts(test_dir, filter_options)
      assert.is_nil(error)
      assert.is_not_nil(scripts)
      assert.are.equal(2, #scripts) -- Only start and build
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should filter by categories", function()
      local test_dir = create_test_dir({
        ["package.json"] = [[{
          "name": "test",
          "scripts": {
            "start": "node index.js",
            "test": "jest",
            "build": "webpack",
            "lint": "eslint ."
          }
        }]]
      })
      
      local filter_options = { categories = { "test", "build" } }
      local scripts, error = package_scripts.get_package_scripts(test_dir, filter_options)
      assert.is_nil(error)
      assert.is_not_nil(scripts)
      assert.are.equal(2, #scripts) -- Only test and build categories
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should sort scripts alphabetically", function()
      local test_dir = create_test_dir({
        ["package.json"] = [[{
          "name": "test",
          "scripts": {
            "z-last": "echo last",
            "a-first": "echo first",
            "m-middle": "echo middle"
          }
        }]]
      })
      
      local scripts, error = package_scripts.get_package_scripts(test_dir)
      assert.is_nil(error)
      assert.is_not_nil(scripts)
      assert.are.equal(3, #scripts)
      assert.are.equal("a-first", scripts[1].name)
      assert.are.equal("m-middle", scripts[2].name)
      assert.are.equal("z-last", scripts[3].name)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should find package.json in parent directories", function()
      local test_dir = create_test_dir({
        ["package.json"] = [[{
          "name": "test",
          "scripts": {
            "start": "node index.js"
          }
        }]]
      })
      
      -- Create a subdirectory
      local sub_dir = test_dir .. "/subdirectory"
      vim.fn.mkdir(sub_dir, "p")
      
      local scripts, error = package_scripts.get_package_scripts(sub_dir)
      assert.is_nil(error)
      assert.is_not_nil(scripts)
      assert.are.equal(1, #scripts)
      assert.are.equal("start", scripts[1].name)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should handle empty package.json file", function()
      local test_dir = create_test_dir({
        ["package.json"] = ""
      })
      
      local scripts, error = package_scripts.get_package_scripts(test_dir)
      assert.is_nil(scripts)
      assert.is_not_nil(error)
      assert.is_true(error:find("Invalid JSON") ~= nil)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should handle package.json with null scripts", function()
      local test_dir = create_test_dir({
        ["package.json"] = '{"name": "test", "scripts": null}'
      })
      
      local scripts, error = package_scripts.get_package_scripts(test_dir)
      assert.is_nil(error)
      assert.is_not_nil(scripts)
      assert.are.equal(0, #scripts)
      
      cleanup_test_dir(test_dir)
    end)
    
  end)
  
  describe("get_scripts_by_category", function()
    
    it("should group scripts by category correctly", function()
      local test_dir = create_test_dir({
        ["package.json"] = [[{
          "name": "test",
          "scripts": {
            "start": "node index.js",
            "serve": "serve dist",
            "test": "jest",
            "test:watch": "jest --watch",
            "build": "webpack",
            "build:prod": "webpack --mode=production"
          }
        }]]
      })
      
      local filter_options = { exclude_lifecycle = false } -- Override default to include all scripts
      local grouped, error = package_scripts.get_scripts_by_category(test_dir, filter_options)
      assert.is_nil(error)
      assert.is_not_nil(grouped)
      
      -- Check start category
      assert.is_not_nil(grouped.start)
      assert.are.equal(2, #grouped.start) -- start and serve
      
      -- Check test category  
      assert.is_not_nil(grouped.test)
      assert.are.equal(2, #grouped.test) -- test and test:watch
      
      -- Check build category
      assert.is_not_nil(grouped.build)
      assert.are.equal(2, #grouped.build) -- build and build:prod
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should return error when no package.json exists", function()
      local test_dir = create_test_dir({})
      
      local grouped, error = package_scripts.get_scripts_by_category(test_dir)
      assert.is_nil(grouped)
      assert.is_not_nil(error)
      
      cleanup_test_dir(test_dir)
    end)
    
  end)
  
  describe("has_package_json", function()
    
    it("should return true when package.json exists", function()
      local test_dir = create_test_dir({
        ["package.json"] = '{"name": "test"}'
      })
      
      local result = package_scripts.has_package_json(test_dir)
      assert.is_true(result)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should return false when package.json does not exist", function()
      local test_dir = create_test_dir({})
      
      local result = package_scripts.has_package_json(test_dir)
      assert.is_false(result)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should find package.json in parent directories", function()
      local test_dir = create_test_dir({
        ["package.json"] = '{"name": "test"}'
      })
      
      local sub_dir = test_dir .. "/subdirectory"
      vim.fn.mkdir(sub_dir, "p")
      
      local result = package_scripts.has_package_json(sub_dir)
      assert.is_true(result)
      
      cleanup_test_dir(test_dir)
    end)
    
  end)
  
  describe("get_package_json_path", function()
    
    it("should return path when package.json exists", function()
      local test_dir = create_test_dir({
        ["package.json"] = '{"name": "test"}'
      })
      
      local path = package_scripts.get_package_json_path(test_dir)
      assert.is_not_nil(path)
      assert.is_true(path:find("package.json") ~= nil)
      
      cleanup_test_dir(test_dir)
    end)
    
    it("should return nil when package.json does not exist", function()
      local test_dir = create_test_dir({})
      
      local path = package_scripts.get_package_json_path(test_dir)
      assert.is_nil(path)
      
      cleanup_test_dir(test_dir)
    end)
    
  end)
  
end)
