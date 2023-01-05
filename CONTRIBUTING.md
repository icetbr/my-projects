## Contributing
Any kind of collaboration is welcome. Open issues to report bugs, ask questions, or just talk about the project.

> This project may contain experimental ideas!

I'm usually trying out new things, like FPish style. Propose changes and alternative implementations and lets discuss their the pros and cons.

These instructions are evolving, the workflow is focused on my environment setup and what I learned so far. Feel free to suggest improvements.


## Webext Workflow

### CSS
In Firefox, make changes in the `Inspector` tab, copy them to the project's `style.css` without ever leaving the browser:
```
F12 -> Style Editor (tab) -> load style.css
```
Hit `ctrl + s` to save changes to the file.


### JS Local (alternative 1)
1) save the page on a local folder
2) edit the HTML and link your userscript
3) open the HTML in [Live Preview][1]
4) now every save in the script reloads the preview

### JS Online (alternative 2)
https://stackoverflow.com/questions/41212558/develop-tampermonkey-scripts-in-a-real-ide-with-automatic-deployment-to-openuser?answertab=modifieddesc#tab-top


### Deploy
When done (`npx run` will call [run.sh](https://github.com/icetbr/my-projects/configs/run-config/run.sh))

1) **copy the folder** of a similar project to use as a base
2) create an **icon**
  - `npx run editIcon` or https://app.corelvector.com
  - `npx run generateManifestIcons`
3) take a **screenshot**
  - `media/before.png`, `media/after.png`
4) `npx cspell`
5) `npx run createGithubRepo`
  - commit
6) `npx run syncMetadata`
  - needed fields: description, keywords, repository
    - either in `package.json` or `manifest.json`
7) publish to **openUserjs**
   - `npx run bundle`
   - commit `userscripts` repo
   - manually import the script in openuserjs.org
   - `npx run getOpenUserJsReadme`
8) publish to **firefox**
   - `npx run firstRun`
   - `npx run readmeToHtml`


[1]: https://marketplace.visualstudio.com/items?itemName=ms-vscode.live-server
<!-- http://localhost:3000/test/hackernews/Meta%20Is%20Transferring%20Jest%20to%20the%20OpenJS%20Foundation%20_%20Hacker%20News.html -->
