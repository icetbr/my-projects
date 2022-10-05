# My Projects
A barrel folder to organize my projects.

## Why
Each project is treated as a submodule (`git submodules`) and a workspace(`npm workspaces`)
- keeps common files that each project can link to
  - some projects are so small that github reports 80% of my project is shellscript (`run.sh`), the other 20% is js
  - example: LICENSE, CONTRIBUTING.md, run.sh, .eslint.rc
- one `node_modules` for all projects, since most share the same dependencies
- handle all projects as one in VsCode, easy to make mass changes, commits, spot common patterns, etc.
- holds documentation relevant to multiple projects
  - how to create an webext -- XXX: link this from each project?
