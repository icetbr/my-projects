import metablock from 'rollup-plugin-userscript-metablock';
import cleanup from 'rollup-plugin-cleanup';
// import execute from 'rollup-plugin-execute';
import nodeResolve from '@rollup/plugin-node-resolve';

import { readFileSync } from 'fs';

const manifest = JSON.parse(readFileSync('./manifest.json'));
const meta = JSON.parse(readFileSync('./metablock.json'));

const refreshBrowser = 'xdotool windowactivate $(xdotool search --class chrome | tail -1) key ctrl+r windowactivate $(xdotool getactivewindow)';

// NEED full path because of https://github.com/rollup/rollup/issues/4251 ?
// import { cssToEsm } from '@icetbr/utils/rollup';
import { cssToEsm } from './extras.js';

/**
 * @type {import('rollup').RollupOptions}
 */
export default {
    input: 'src/content.js',
    plugins: [
        nodeResolve(),
        cssToEsm(),
        cleanup({
            comments: 'none',
            maxEmptyLines: 1,
        }),
        // execute(refreshBrowser), // I uncomment as needed, I don't use this everytime
    ],
    treeshake: {
        moduleSideEffects: 'no-external', // fixes sort of a bug, where some imports will be kept even if not used; there are other ways to avoid this, like the commented external bellow
    },
    // external: ['util'],
    output: [
        { file: 'dist/content.js' },

        // comment this entry if needed
        {
            file: `../userscripts/scripts/${meta.downloadURL.split('/').at(-1)}`,
            plugins: [
                metablock({
                    order: ['name', 'description', 'version', 'author', 'icon', 'include', 'license', 'namespace', 'updateURL', 'downloadURL', 'require'],
                    override: {
                        name: manifest.name,
                        version: manifest.version,
                        description: manifest.description,
                        author: manifest.author,
                        match: manifest.content_scripts[0]?.matches[0],
                        include: manifest.content_scripts[0].include_globs?.[0],
                    },
                }),
            ]
        },
    ],
};
