# Redmine plugin test action

This action is to test for [Redmine](https://www.redmine.org/) plugin.
It prepares a environment for tests and runs rake command with `redmine:plugins:test`.

## Inputs

### `plugin-name`

**Required** The name of the plugin to test. You MUST specify GitHub repository name.

### `redmine_version`

**Required** The version of Redmine to test. You can use matrix in your action.

### `redmine_repo`

**Optional** The source code repository of Redmine to download. Default `"https://github.com/redmine/redmine.git"`.

## Outputs

Nothing.

## Example usage

```yaml
- name: Redmine plugin test
  uses: two-pack/redmine-plugin-test-action@v1
  with:
    plugin-name: redmine_auto_assign_group
    redmine_version: ${{ matrix.redmine }}
```
