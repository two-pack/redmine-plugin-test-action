const path = require('path');
const core = require('@actions/core');
const exec = require('@actions/exec');

async function run() {
  try {
    const plugin_name = core.getInput('plugin_name');
    const redmine_version = core.getInput('redmine_version');
    const ruby_version = core.getInput('ruby_version');
    await exec.exec(path.join(__dirname, 'redmine-plugin-test.sh'),
                    [plugin_name, redmine_version, ruby_version]);
  } catch (error) {
    core.setFailed(error.message);
  }
}

run();
