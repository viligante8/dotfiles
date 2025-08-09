#!/usr/bin/env nvim -l

-- Amazon Q Setup Script for New Users
print("🚀 Setting up Amazon Q for Neovim...")

-- Step 1: Check if amazon-q-lsp.nvim is available
print("\n1. Checking amazon-q-lsp.nvim...")
local lsp_ok, amazon_q_lsp = pcall(require, 'amazon-q-lsp')
if not lsp_ok then
  print("❌ amazon-q-lsp.nvim not found!")
  print("Please install it first:")
  print("  https://github.com/your-username/amazon-q-lsp.nvim")
  os.exit(1)
end
print("✅ amazon-q-lsp.nvim found")

-- Step 2: Check if amazon-q.nvim is available
print("\n2. Checking amazon-q.nvim...")
local ui_ok, amazon_q = pcall(require, 'amazon-q')
if not ui_ok then
  print("❌ amazon-q.nvim not found!")
  print("Please install it first:")
  print("  https://github.com/your-username/amazon-q.nvim")
  os.exit(1)
end
print("✅ amazon-q.nvim found")

-- Step 3: Run health checks
print("\n3. Running health checks...")
amazon_q_lsp.checkhealth()

-- Step 4: Test basic functionality
print("\n4. Testing basic functionality...")
local test_ok = amazon_q_lsp.test()
if test_ok then
  print("✅ Basic functionality test passed")
else
  print("⚠️  Some tests failed - check output above")
end

print("\n🎉 Amazon Q setup complete!")
print("\n📚 Quick Start:")
print("  <leader>qc - Open Amazon Q chat")
print("  <leader>qt - Toggle Amazon Q chat")
print("  :AmazonQStatus - Check status")
print("  :AmazonQHealth - Run health check")

print("\n💡 First time setup:")
print("  1. Make sure AWS credentials are configured")
print("  2. Run: aws sso login --profile emsi-company-micro")
print("  3. Open a code file and press <leader>qc")
