// Renders one representative still per scene for both aspect ratios.
import {bundle} from '@remotion/bundler';
import {renderStill, selectComposition} from '@remotion/renderer';
import path from 'node:path';

const STILLS = [
  ['01_wake', 2.2], ['02_dashboard', 5.6], ['03_transactions', 9.6], ['04_bagilah', 14.8],
  ['05_analytics', 18.6], ['06_assistant', 22.6], ['07_universe', 24.8], ['08_hero', 27.4], ['09_end', 29.8],
];
const only = process.argv[2]; // optional: comma list of seconds, e.g. "10.6,11.4"
const layouts = (process.argv[3] ?? 'portrait,landscape').split(',');
const serveUrl = await bundle({entryPoint: path.resolve('src/index.ts')});
const list = only ? only.split(',').map((t) => [`t${t}`, Number(t)]) : STILLS;
for (const layout of layouts) {
  const id = layout === 'portrait' ? 'Promo9x16' : 'Promo16x9';
  const inputProps = {layout, audio: 'none'};
  const composition = await selectComposition({serveUrl, id, inputProps, chromiumOptions: {gl: 'angle'}});
  for (const [name, t] of list) {
    const output = `out/stills/${layout}/${name}.png`;
    await renderStill({composition, serveUrl, output, frame: Math.round(t * 30), inputProps, chromiumOptions: {gl: 'angle'}});
    console.log('rendered', output);
  }
}
