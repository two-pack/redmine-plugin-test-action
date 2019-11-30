const path = require('path');
const core = require('@actions/core');
const exec = require('@actions/exec');

async function run() {
  try {
    const plugin_name = core.getInput('plugin-name');
    const redmine_version = core.getInput('redmine_version');
    var redmine_repo = core.getInput('redmine_repo');
    if (redmine_repo == '') {
      redmine_repo = 'https://github.com/redmine/redmine.git';
    }

    await exec.exec(path.join(__dirname, 'redmine-plugin-test.sh'),
                    [plugin_name, redmine_version, redmine_repo]);
  } catch (error) {
    core.setFailed(error.message);
  }
}

run();
