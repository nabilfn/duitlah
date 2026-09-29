import React, {useMemo} from 'react';
import {AbsoluteFill, Audio, staticFile, useCurrentFrame, useVideoConfig} from 'remotion';
import {ThreeCanvas} from '@remotion/three';
import {useThree} from '@react-three/fiber';
import {useLayoutEffect} from 'react';
import {FPS, inOut, prog, s} from './anim';
import {CAM, homography, Layout, poseAt, projector, SCREEN_ZOOM} from './camera';
import {T} from './timeline';
import {PhoneModel} from './three/PhoneModel';
import {PhoneUI} from './PhoneUI';
import {Background} from './stage/Background';
import {Headlines} from './stage/Headlines';
import {BagilahStage} from './stage/BagilahStage';
import {Universe} from './stage/Universe';
import {EndCard} from './stage/EndCard';

export type FilmProps = {layout: Layout; audio: 'vo' | 'guide-vo' | 'no-vo' | 'none'};

const CameraRig: React.FC = () => {
  const camera = useThree((st) => st.camera) as import('three').PerspectiveCamera;
  useLayoutEffect(() => {
    camera.fov = CAM.fov;
    camera.near = 0.1;
    camera.far = 200;
    camera.position.set(0, 0, CAM.z);
    camera.lookAt(0, 0, 0);
    camera.updateProjectionMatrix();
  }, [camera]);
  return null;
};

export const Film: React.FC<FilmProps> = ({layout, audio}) => {
  const frame = useCurrentFrame();
  const {width: w, height: h} = useVideoConfig();
  const sec = frame / FPS;
  const pose = poseAt(layout, sec);

  // Screen quad → CSS homography (UI stays DOM-crisp, perspective matches the 3D device).
  const project = useMemo(() => projector(w, h, pose), [w, h, pose]);
  const quad = [project(0, 0), project(390, 0), project(390, 844), project(0, 844)];
  const matrix = homography(390 * SCREEN_ZOOM, 844 * SCREEN_ZOOM, quad);
  const landPose = poseAt(layout, T.ringLand[1]);
  const projectLand = useMemo(() => projector(w, h, landPose), [w, h, landPose]);

  // Background falls out of focus for Bagilah, returns for Analytics.
  const blur = prog(frame, T.phoneBlur[0], T.phoneBlur[1], inOut) * (1 - prog(frame, T.phoneFocus[0], T.phoneFocus[1], inOut));
  const recede = prog(frame, T.recede[0], T.recede[1], inOut);
  const streak = prog(frame, T.streak[0], T.streak[1], (x) => x);
  const phoneOpacity = 1 - prog(frame, T.recede[0] + 0.15, T.recede[1] - 0.1, inOut);
  const macro = prog(frame, 0.25, 0.9, inOut) * (1 - prog(frame, 2.2, 3.2, inOut));
  const rimBoost = 1.2 * prog(frame, 26.0, 27.0, inOut) * (1 - recede) + 2.2 * macro;
  const sheen = Math.max(-1, Math.min(1, pose[4] / 25));

  return (
    <AbsoluteFill style={{background: '#000'}}>
      <Background sec={sec} layout={layout} w={w} h={h} />
      <Universe sec={sec} layout={layout} w={w} h={h} layer="back" />
      <AbsoluteFill style={{filter: blur > 0.001 ? `blur(${16 * blur}px) brightness(${1 - 0.5 * blur})` : undefined, opacity: phoneOpacity}}>
        <ThreeCanvas width={w} height={h} linear={false} gl={{antialias: true, alpha: true, preserveDrawingBuffer: true}} camera={{fov: CAM.fov, position: [0, 0, CAM.z], near: 0.1, far: 200}}>
          <CameraRig />
          <PhoneModel pose={pose} streak={streak} rimBoost={rimBoost} />
        </ThreeCanvas>
        {pose[4] > -74 && (
          <div
            style={{
              opacity: Math.min(1, Math.max(0, (pose[4] + 74) / 8)),
              position: 'absolute',
              left: 0,
              top: 0,
              width: 390 * SCREEN_ZOOM,
              height: 844 * SCREEN_ZOOM,
              transformOrigin: '0 0',
              transform: matrix,
              backfaceVisibility: 'hidden',
            }}
          >
            <div style={{width: 390, height: 844, zoom: SCREEN_ZOOM, position: 'relative'}}>
              <PhoneUI sec={sec} sheen={sheen} />
            </div>
          </div>
        )}
      </AbsoluteFill>
      <Universe sec={sec} layout={layout} w={w} h={h} layer="front" />
      <BagilahStage sec={sec} layout={layout} project={project} projectLand={projectLand} />
      <Headlines sec={sec} layout={layout} w={w} h={h} />
      <EndCard sec={sec} layout={layout} w={w} h={h} />
      {audio !== 'none' && <Audio src={staticFile({vo: 'audio/mix_vo.wav', 'guide-vo': 'audio/mix_guide_vo.wav', 'no-vo': 'audio/mix_no_vo.wav'}[audio])} />}
      {/* keep frame count honest */}
      <div style={{display: 'none'}}>{s(30)}</div>
    </AbsoluteFill>
  );
};
