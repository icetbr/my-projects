## Contributing
Any kind of collaboration is welcome. Open issues to report bugs, ask questions, or just talk about the project.

Source code might be a bit unusual since I'm usually trying out new things, like FPish style.

The following workflows represent how I currently develop.

## Browser extensions: development (webext-*)
I use mostly Firefox as an IDE. There are a few ways you can develop:

### If just CSS (alternative 1)
In the Style Editor tab of DevTools, load `pathToProject/style.css`. Anything you write here is automatically applied. Hit `ctrl + s` to save changes to the file.

### If just CSS (alternative 2)
For quick exploration, make changes in the `Inspector` tab, and after you're done, click the Changes subtab (right pane) and everything you made will be there to be copied.

### If JS (alternative 1)
In the console tab of DevTools, CTRL + B will give you near the samething as Style Editor for scripts. Use `var`instead of `const` or `let` for easy overriding without having to reload the page. CTRL + ENTER will run everything in the window or just yopur selection

### If JS (alternative 2)
1) save the page on a local folder
2) edit the HTML and link your userscript
3) open the HTML in [Live Preview][1]
4) now every save in the script reloads the preview

### If JS Online (alternative 3)
https://stackoverflow.com/questions/41212558/develop-tampermonkey-scripts-in-a-real-ide-with-automatic-deployment-to-openuser?answertab=modifieddesc#tab-top

### Extension (alternative 4)
- **FF**: npx run build. In the browser: about:debugging, This Firefox, Load Temporary Addon
- **Chrome**: npx run build && npx run adjustManifestV3. In the browser: More Tools -> Extensions, Load unpacked


## Browser extensions: deploy
> NOTE: `npx run TARGET` targets are defined in [run.sh](https://github.com/icetbr/my-projects/configs/run-config/common.sh)

When you're finished developing:

### First time / new project
1) **copy the folder** of a similar project to use as a base
   - delete manifest.js addonIds
   - delete .git folder
   - don't delete icon.svg (it will be replaced)

2) create an **icon**
    - `npx run editIcon` or https://app.corelvector.com
    - `npx run generateManifestIcons`

3) take a **1280 x 800 screenshot**
    - chrome store requirement
    - use Flameshot + remind last position OR
    - F12 -> responsive Design -> click screenshot button (ctrl + shift + s)
    - inkscape modifications
      - **blur**: add rectangles on parts to hide, copy image, blur it, set clip group with blurred + rectangles
    - `media/before.jpg`, `media/after.jpg`

4) `npx cspell`
   - `npx run bundle` and test the userscript

5) `npx run createGithubRepo`
    - commit

6) `npx run syncMetadata`
    - needed fields: description, keywords, repository
    - either in `package.json` or `manifest.json`

7) publish to **OpenUserJs**
    - `npx run bundle`
    - commit `userscripts` repo
    - manually import the script in openuserjs.org
    - `npx run openuserReadme`
    - update the README with the published URL

8) publish to **firefox**
    - `npx run firefoxFirst`
    - get id after first publish, add to manifest.json
    - description
    - categories: Appearance
    - 128px icon
    - tags
    - update the README with the published URL
    - update manifest.json addonIds[0]
      - "addonIds": ["firefoxurl"]

9)  publish to **chrome**
    - get id after first publish, add to manifest.json
    - `npx run firstChrome`
    - description
      - replace: list dash for a bullet point
      - replace: bold for capslock
    - TAB Store Listing
      - description
      - category: social & communication?
      - 128 x 128 icon path
      - 1280 x 800 screenshot path
      - language: english (US)
    - TAB Private Practices
      - Single Purpose: see [boilerplate](docs/boilerplate.md)
      - Host Permission: I need to change the appearance of the site
      - Remote Code: no
      - Mark all 3 last disclosure checkboxes
    - update the README with the published URL
    - update manifest.json addonIds[1]
      - "addonIds": ["firefoxurl", "chromeUrl"]

### Just updating
- **OpenUserJs**
  - `npx run bundle`
  - commit `userscripts` repo
- `npx run firefox`
- `npx run chrome`

- update the readmes
  - `npx run openuserReadme`
  - `npx run firefoxReadme`
  - `npx run chromeReadme`



[1]: https://marketplace.visualstudio.com/items?itemName=ms-vscode.live-server
<!-- http://localhost:3000/test/hackernews/Meta%20Is%20Transferring%20Jest%20to%20the%20OpenJS%20Foundation%20_%20Hacker%20News.html -->
