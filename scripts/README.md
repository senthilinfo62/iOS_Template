# 🛠️ Scripts

This directory contains essential utility scripts for the iOS Template project.

## 📋 Available Scripts

### **1. fix_alamofire_dependency.sh** 🔧
**Purpose**: Fixes Alamofire dependency issues that may occur during development.

**Usage**:
```bash
./scripts/fix_alamofire_dependency.sh
```

**What it does**:
- Cleans derived data and package cache
- Resolves Swift Package Manager dependencies fresh
- Tests the build to ensure Alamofire is working
- Provides troubleshooting tips

**When to use**:
- When you see "Missing package product 'Alamofire'" error
- After cleaning project or switching branches
- When package dependencies seem corrupted

### **2. setup_ci_cd.sh** 🚀
**Purpose**: Sets up CI/CD pipeline with GitHub Actions for automated builds and TestFlight uploads.

**Usage**:
```bash
./scripts/setup_ci_cd.sh
```

**What it does**:
- Creates GitHub Actions workflow files
- Sets up automated testing on pull requests
- Configures TestFlight deployment pipeline
- Sets up code quality checks (linting, etc.)

**When to use**:
- When setting up the project for the first time
- When you want to enable automated builds and deployments
- When configuring CI/CD for a team environment

## 🔧 Script Maintenance

### **Adding New Scripts**
When adding new scripts to this directory:

1. **Make them executable**:
   ```bash
   chmod +x scripts/your_script.sh
   ```

2. **Follow naming convention**:
   - Use lowercase with underscores: `script_name.sh`
   - Be descriptive about the script's purpose

3. **Add documentation**:
   - Update this README with script description
   - Include usage examples
   - Explain when to use the script

4. **Include error handling**:
   - Use `set -e` for strict error handling
   - Provide clear error messages
   - Include cleanup on failure

### **Script Guidelines**
- Keep scripts focused on a single purpose
- Include colored output for better UX
- Provide clear success/failure feedback
- Include help/usage information
- Test scripts thoroughly before committing

## 🚀 Quick Reference

```bash
# Fix Alamofire dependency issues
./scripts/fix_alamofire_dependency.sh

# Setup CI/CD pipeline
./scripts/setup_ci_cd.sh

# Make all scripts executable (if needed)
chmod +x scripts/*.sh
```

## 📚 Related Documentation

- [Clean Architecture Structure](../docs/CLEAN_ARCHITECTURE_STRUCTURE.md)
- [iOS Development Prerequisites](../docs/IOS_DEVELOPMENT_PREREQUISITES.md)
- [CI/CD Pipeline Guide](../docs/CI_CD_PIPELINE.md)

---

**Note**: These scripts are designed to be run from the project root directory. Always ensure you're in the correct location before executing any script.
