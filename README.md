# pre-commit-hooks
custom pre-commit hooks for http://pre-commit.com/

## Available Hooks

### rails-outdated-schema

This hook checks if your db/schema.rb  is outdated. If you've made changes to your migrations but haven't updated the schema, this hook will fail and remind you to do so.

### rails-missing-migration-file

This hook checks if there are missing migration files. If you've modified the schema but haven't added the corresponding migration file, this hook will fail and remind you to add it.

## Usage
Add a file named .pre-commit-config.yaml into the root directory of your repository

```yaml
- repo: https://github.com/jiikko/pre-commit-hooks.git
  rev: 0.1.0
  hooks:
    - id: rails-outdated-schema
    - id: rails-missing-migration-file
```
