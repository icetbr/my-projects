// rollup-import-css-as-string
export const cssToEsm = () => ({
    name: 'cssToEsm',
    transform : (code, id) => !['js', 'ts'].includes(id.split('.').pop()) && { code: `export default /*css*/\`\n\n${code.replace(/\\/gm, '\\\\')}\n\`;`, map: null }
});
