import * as THREE from 'three';
import {glide, inOut, Key, settle, track} from './anim';

export type Layout = 'portrait' | 'landscape';

// Phone geometry (world units). Screen is 390x844 logical, so 0.01 unit per px.
export const PHONE = {W: 4.26, H: 8.78, D: 0.66, R: 0.62, SW: 3.9, SH: 8.44, SR: 0.47};
export const CAM = {fov: 30, z: 23.4};
export const SCREEN_ZOOM = 3; // DOM rendered at 3x logical px, projected down: always crisp.

const d = (deg: number) => (deg * Math.PI) / 180;

// Pose: [x, y, z, rotX°, rotY°, rotZ°]
const portrait: Key[] = [
  {t: 0.0, v: [-0.05, 0.1, 14.6, 5, -83, -11]},
  {t: 0.9, v: [-0.15, 0.05, 14.0, 5, -79, -10], e: (x) => x},
  {t: 2.45, v: [0.55, -2.9, 6.0, 4, -46, -5], e: glide},
  {t: 3.35, v: [0.2, -2.05, 1.6, 3, -22, -2], e: settle},
  {t: 4.7, v: [0, -1.52, 0.4, 0, -3, 0], e: settle},
  {t: 6.6, v: [0, -1.78, 1.8, 0, -1, 0], e: inOut},
  {t: 7.5, v: [0, -1.52, 1.0, 0, 2, 0], e: inOut},
  {t: 10.1, v: [0, -1.55, 0.9, 0, 4, 0], e: (x) => x},
  {t: 11.1, v: [0, -0.9, -4.2, 0, 7, 0], e: inOut},
  {t: 15.6, v: [0, -0.85, -4.8, 0, 3, 0], e: (x) => x},
  {t: 16.9, v: [0, -1.8, 0.2, 0, -6, 0], e: settle},
  {t: 19.6, v: [0, -1.82, 0.5, 1, 6, 0], e: inOut},
  {t: 20.7, v: [0, -1.62, 1.4, 0, 2, 0], e: inOut},
  {t: 23.05, v: [0, -1.62, 1.3, 0, 0, 0], e: (x) => x},
  {t: 24.3, v: [0, -0.6, -10.5, 0, -7, 0], e: inOut},
  {t: 25.3, v: [0, -0.6, -11.0, 0, 5, 0], e: (x) => x},
  {t: 26.45, v: [0, -1.52, 0.3, 0, -2, 0], e: inOut},
  {t: 28.0, v: [0, -1.52, 0.7, 0, -1, 0], e: (x) => x},
  {t: 29.0, v: [0, -0.35, -15, 0, 0, 0], e: inOut},
  {t: 30.0, v: [0, -0.35, -15, 0, 0, 0]},
];

// 16:9 is recomposed: device to the right, copy to the left.
const landscape: Key[] = [
  {t: 0.0, v: [1.0, 0.4, 14.2, 5, -83, -11]},
  {t: 0.9, v: [1.0, 0.35, 13.6, 5, -79, -10], e: (x) => x},
  {t: 2.45, v: [3.6, -0.4, 6.5, 4, -46, -5], e: glide},
  {t: 3.35, v: [3.3, -0.2, 3.2, 3, -24, -2], e: glide},
  {t: 4.7, v: [3.3, 0, 1.6, 0, -8, 0], e: settle},
  {t: 6.6, v: [3.1, -0.3, 4.2, 0, -5, 0], e: inOut},
  {t: 7.5, v: [3.3, 0, 2.4, 0, -6, 0], e: inOut},
  {t: 10.1, v: [3.3, 0, 2.1, 0, -4, 0], e: (x) => x},
  {t: 11.1, v: [3.0, 0.1, -5.5, 0, -2, 0], e: inOut},
  {t: 15.6, v: [3.0, 0.1, -6.0, 0, -4, 0], e: (x) => x},
  {t: 16.9, v: [3.3, 0, 1.8, 0, -10, 0], e: settle},
  {t: 19.6, v: [3.3, 0, 2.2, 1, -2, 0], e: inOut},
  {t: 20.7, v: [3.2, 0.1, 3.0, 0, -5, 0], e: inOut},
  {t: 23.05, v: [3.2, 0.05, 2.8, 0, -6, 0], e: (x) => x},
  {t: 24.3, v: [0, -0.45, -4.6, 0, -6, 0], e: inOut},
  {t: 25.3, v: [0, -0.45, -5.0, 0, 5, 0], e: (x) => x},
  {t: 26.45, v: [3.3, 0, 1.8, 0, -7, 0], e: inOut},
  {t: 28.0, v: [3.3, 0, 2.2, 0, -6, 0], e: (x) => x},
  {t: 29.0, v: [0, 0.7, -16, 0, 0, 0], e: inOut},
  {t: 30.0, v: [0, 0.7, -16, 0, 0, 0]},
];

export const poseAt = (layout: Layout, sec: number) => track(layout === 'portrait' ? portrait : landscape, sec);

export const makeCamera = (w: number, h: number) => {
  const cam = new THREE.PerspectiveCamera(CAM.fov, w / h, 0.1, 200);
  cam.position.set(0, 0, CAM.z);
  cam.lookAt(0, 0, 0);
  cam.updateMatrixWorld();
  cam.updateProjectionMatrix();
  return cam;
};

export const phoneMatrix = (pose: number[]) => {
  const o = new THREE.Object3D();
  o.position.set(pose[0], pose[1], pose[2]);
  o.rotation.set(d(pose[3]), d(pose[4]), d(pose[5]));
  o.updateMatrixWorld();
  return o.matrixWorld.clone();
};

export const applyPose = (o: THREE.Object3D, pose: number[]) => {
  o.position.set(pose[0], pose[1], pose[2]);
  o.rotation.set(d(pose[3]), d(pose[4]), d(pose[5]));
};

/** Project a point on the screen plane (logical px, origin top-left) to frame px. */
export const projector = (w: number, h: number, pose: number[]) => {
  const cam = makeCamera(w, h);
  const m = phoneMatrix(pose);
  const z = PHONE.D / 2 + 0.004;
  return (x: number, y: number) => {
    const v = new THREE.Vector3(-PHONE.SW / 2 + (x / 390) * PHONE.SW, PHONE.SH / 2 - (y / 844) * PHONE.SH, z);
    v.applyMatrix4(m).project(cam);
    return [((v.x + 1) / 2) * w, ((1 - v.y) / 2) * h];
  };
};

/** CSS matrix3d mapping a (sw x sh) element onto the projected quad. */
export const homography = (sw: number, sh: number, q: number[][]) => {
  const [p0, p1, p2, p3] = q;
  const sx = p0[0] - p1[0] + p2[0] - p3[0];
  const sy = p0[1] - p1[1] + p2[1] - p3[1];
  const dx1 = p1[0] - p2[0], dx2 = p3[0] - p2[0], dy1 = p1[1] - p2[1], dy2 = p3[1] - p2[1];
  const det = dx1 * dy2 - dx2 * dy1;
  const g = (sx * dy2 - dx2 * sy) / det;
  const hh = (dx1 * sy - sx * dy1) / det;
  const a = p1[0] - p0[0] + g * p1[0];
  const b = p3[0] - p0[0] + hh * p3[0];
  const c = p0[0];
  const dd = p1[1] - p0[1] + g * p1[1];
  const e = p3[1] - p0[1] + hh * p3[1];
  const f = p0[1];
  const m = [a / sw, dd / sw, 0, g / sw, b / sh, e / sh, 0, hh / sh, 0, 0, 1, 0, c, f, 0, 1];
  return `matrix3d(${m.map((x) => x.toFixed(9)).join(',')})`;
};

/** Pixels per world unit at z=0 and the equivalent CSS perspective. */
export const cssPerspective = (h: number) => {
  const pxPerUnit = h / (2 * CAM.z * Math.tan(d(CAM.fov / 2)));
  return {pxPerUnit, perspective: CAM.z * pxPerUnit};
};
