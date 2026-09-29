import React from 'react';
import {Composition, continueRender, delayRender, staticFile} from 'remotion';
import {Film, FilmProps} from './Film';

// Fonts bundled with the app (apps/mobile/assets/fonts), loaded before any frame renders.
const fontHandle = delayRender('Loading Plus Jakarta Sans');
Promise.all([
  new FontFace('Plus Jakarta Sans', `url(${staticFile('fonts/PlusJakartaSans-Variable.ttf')})`, {weight: '200 800'}).load(),
  new FontFace('Bodoni Moda', `url(${staticFile('fonts/BodoniModa-Variable.ttf')})`, {weight: '400 900'}).load(),
])
  .then((faces) => {
    faces.forEach((f) => document.fonts.add(f));
    continueRender(fontHandle);
  })
  .catch((e) => {
    console.error(e);
    continueRender(fontHandle);
  });

const defaults: FilmProps = {layout: 'portrait', audio: 'guide-vo'};

export const Root: React.FC = () => (
  <>
    <Composition id="Promo9x16" component={Film} durationInFrames={900} fps={30} width={1080} height={1920} defaultProps={defaults} />
    <Composition
      id="Promo16x9"
      component={Film}
      durationInFrames={900}
      fps={30}
      width={1920}
      height={1080}
      defaultProps={{...defaults, layout: 'landscape'} as FilmProps}
    />
  </>
);
