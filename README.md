# My Projects
A `pnpm` workspace of personal `git submodule` projects.

I use **pnpm** to link dependencies between projects in a way that keeps VsCode go to behaviour.


## Build files
I'm trying to DRY my projects while keeping easy for people to create MRs.

- rollup.config.js
  - available at [@icetbr/rollup-config-webext]()
  - used like `rollup -c node:@icetbr/rollup-config-webext`
- .eslintrc.json
  - available at [@icetbr/eslint-config]()
  - configured in `package.json`
- run.sh
  - available at [@icetbr/run-config]()
  - called from package.json `scripts`
- jsconfig.json
  - user's must set `"js/ts.implicitProjectConfig.module": "NodeNext"` in theirs vscode settings
    - it allows code navigation with packages using `exports` in package.json
  - I might put this in .vscode
- LICENSE
  - github NEEDS a separate file, I'm stubborn, I only put it in the README.md
- CONTRIBUTING.md
  - linked in README.md
- cspell.json
  - available at [@icetbr/cspell-config]()
  - configured in `cspell` at package.json
- .gitignore
  - needed
- package-lock.json
  - I think I can get away without this


[Contributing](https://github.com/icetbr/my-projects/blob/main/CONTRIBUTING.md)\
[License (MIT)](https://choosealicense.com/licenses/mit/)
