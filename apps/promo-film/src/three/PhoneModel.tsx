import React, {useEffect, useMemo} from 'react';
import {useThree} from '@react-three/fiber';
import * as THREE from 'three';
import {RoundedBoxGeometry} from 'three/examples/jsm/geometries/RoundedBoxGeometry.js';
import {applyPose, PHONE} from '../camera';


const rrect = (w: number, h: number, r: number) => {
  const s = new THREE.Shape();
  const x = -w / 2, y = -h / 2;
  s.moveTo(x + r, y);
  s.lineTo(x + w - r, y);
  s.absarc(x + w - r, y + r, r, -Math.PI / 2, 0, false);
  s.lineTo(x + w, y + h - r);
  s.absarc(x + w - r, y + h - r, r, 0, Math.PI / 2, false);
  s.lineTo(x + r, y + h);
  s.absarc(x + r, y + h - r, r, Math.PI / 2, Math.PI, false);
  s.lineTo(x, y + r);
  s.absarc(x + r, y + r, r, Math.PI, Math.PI * 1.5, false);
  return s;
};

/** A dark studio: one large soft key, cool edge strips, dim fill. During the opening a
 *  thin strip sweeps behind the lens, which is what the macro edge reflects as a streak. */
const buildEnv = (gl: THREE.WebGLRenderer, streak: number) => {
  const envScene = new THREE.Scene();
  envScene.background = new THREE.Color('#020306');
  const panel = (w: number, h: number, color: string, k: number, pos: number[]) => {
    const m = new THREE.Mesh(
      new THREE.PlaneGeometry(w, h),
      new THREE.MeshBasicMaterial({color: new THREE.Color(color).multiplyScalar(k), side: THREE.DoubleSide}),
    );
    m.position.set(pos[0], pos[1], pos[2]);
    m.lookAt(0, 0, 0);
    envScene.add(m);
  };
  panel(9, 6, '#ffffff', 3.6, [8, 7, 9]); // large soft key
  panel(12, 3, '#e8f0fb', 1.6, [0, 12, 9]); // top strip: catches the upper bevel
  panel(1.6, 18, '#ffffff', 2.6, [12, 0, 8]); // right strip: side bevels
  panel(1.6, 18, '#78B5FF', 2.4, [-12, 0, 8]); // cool left strip
  panel(1.4, 16, '#dfe9f7', 1.6, [10, 0, -8]); // right rear: flat side walls
  panel(1.4, 16, '#78B5FF', 1.5, [-10, 0, -8]); // left rear, cool
  panel(12, 12, '#cfe0f5', 0.12, [0, 12, 0]); // dim top fill
  panel(14, 2, '#0c1a2c', 0.8, [0, -9, 4]); // navy floor bounce
  panel(44, 24, '#6f8fb8', 0.5, [4, 0, 30]); // soft navy wall behind the lens
  if (streak > 0 && streak < 1) {
    panel(1.6, 40, '#eef4ff', 7 * Math.sin(streak * Math.PI), [THREE.MathUtils.lerp(-4, 24, streak), 0, 26]);
  }
  const pmrem = new THREE.PMREMGenerator(gl);
  const rt = pmrem.fromScene(envScene, 0.015);
  pmrem.dispose();
  envScene.traverse((o) => {
    if (o instanceof THREE.Mesh) {
      o.geometry.dispose();
      (o.material as THREE.Material).dispose();
    }
  });
  return rt;
};

const useStudioEnvironment = (streak: number) => {
  const gl = useThree((st) => st.gl);
  const scene = useThree((st) => st.scene);
  const key = streak > 0 && streak < 1 ? Math.round(streak * 400) / 400 : 0;
  const rt = useMemo(() => buildEnv(gl, key), [gl, key]);
  useEffect(() => () => rt.dispose(), [rt]);
  // Assigned during render, not in an effect: a single-frame capture must already see it.
  scene.environment = rt.texture;
};

const materials = () => ({
  titanium: new THREE.MeshPhysicalMaterial({color: '#8a8d95', metalness: 1, roughness: 0.26, clearcoat: 0.2, clearcoatRoughness: 0.3}),
  titaniumBrushed: new THREE.MeshPhysicalMaterial({color: '#8f929a', metalness: 1, roughness: 0.36}),
  frontGlass: new THREE.MeshPhysicalMaterial({color: '#010203', metalness: 0, roughness: 0.04, clearcoat: 1, clearcoatRoughness: 0.03, reflectivity: 0.55}),
  backGlass: new THREE.MeshPhysicalMaterial({color: '#2a2d33', metalness: 0.1, roughness: 0.55, clearcoat: 0.4, clearcoatRoughness: 0.5}),
  lensGlass: new THREE.MeshPhysicalMaterial({color: '#05070b', metalness: 0.2, roughness: 0.05, clearcoat: 1}),
  lensRing: new THREE.MeshPhysicalMaterial({color: '#8b8e96', metalness: 1, roughness: 0.2}),
  dark: new THREE.MeshStandardMaterial({color: '#0b0c0f', roughness: 0.6}),
  antenna: new THREE.MeshStandardMaterial({color: '#2b2d31', roughness: 0.7}),
});

export const PhoneModel: React.FC<{pose: number[]; streak: number; rimBoost: number}> = ({pose, streak, rimBoost}) => {
  useStudioEnvironment(streak);
  const {W, H, D, R} = PHONE;
  const m = useMemo(materials, []);
  const geo = useMemo(() => {
    const b = 0.085;
    const bt = 0.11;
    const body = new THREE.ExtrudeGeometry(rrect(W - 2 * b, H - 2 * b, R - b), {
      depth: D - 2 * bt,
      bevelEnabled: true,
      bevelThickness: bt,
      bevelSize: b,
      bevelSegments: 10,
      curveSegments: 64,
    });
    body.translate(0, 0, -(D - 2 * bt) / 2);
    return {
      body,
      front: new THREE.ShapeGeometry(rrect(W - 0.075, H - 0.075, R - 0.037), 64),
      back: new THREE.ShapeGeometry(rrect(W - 0.075, H - 0.075, R - 0.037), 64),
      plateau: new RoundedBoxGeometry(1.82, 1.92, 0.08, 6, 0.42),
      buttons: Object.fromEntries([0.34, 0.62, 0.98, 0.5].map((l) => [l, new RoundedBoxGeometry(0.07, l, 0.2, 4, 0.03)])) as Record<number, THREE.BufferGeometry>,
      lens: new THREE.CylinderGeometry(0.33, 0.33, 0.1, 64),
      lensInner: new THREE.CylinderGeometry(0.22, 0.22, 0.102, 64),
      speaker: new RoundedBoxGeometry(0.86, 0.036, 0.01, 2, 0.015),
    };
  }, [W, H, D, R]);

  const group = useMemo(() => new THREE.Group(), []);
  applyPose(group, pose);

  const zf = D / 2;
  const btn = (x: number, y: number, len: number, key: string) => (
    <mesh key={key} geometry={geo.buttons[len]} material={m.titaniumBrushed} position={[x, y, 0]} />
  );
  return (
    <>
      <ambientLight intensity={0.04} />
      <directionalLight position={[6, 8, 10]} intensity={1.1} color="#ffffff" />
      <directionalLight position={[-8, 3, -5]} intensity={1.6 + rimBoost} color="#78B5FF" />
      <primitive object={group}>
        <mesh geometry={geo.body} material={m.titanium} />
        <mesh geometry={geo.front} material={m.frontGlass} position={[0, 0, zf + 0.001]} />
        <mesh geometry={geo.speaker} material={m.antenna} position={[0, H / 2 - 0.095, zf + 0.004]} />
        <mesh geometry={geo.back} material={m.backGlass} position={[0, 0, -zf - 0.001]} rotation={[0, Math.PI, 0]} />
        <group position={[-W / 2 + 0.22 + 0.91, H / 2 - 0.22 - 0.96, -zf - 0.04]}>
          <mesh geometry={geo.plateau} material={m.backGlass} />
          {[
            [-0.42, 0.44],
            [-0.42, -0.44],
            [0.44, 0.0],
          ].map(([x, y], i) => (
            <group key={i} position={[x, y, -0.06]} rotation={[Math.PI / 2, 0, 0]}>
              <mesh geometry={geo.lens} material={m.lensRing} />
              <mesh geometry={geo.lensInner} material={m.lensGlass} position={[0, -0.002, 0]} />
            </group>
          ))}
        </group>
        {btn(-W / 2 - 0.02, 2.55, 0.34, 'action')}
        {btn(-W / 2 - 0.02, 1.75, 0.62, 'volup')}
        {btn(-W / 2 - 0.02, 0.95, 0.62, 'voldn')}
        {btn(W / 2 + 0.02, 1.35, 0.98, 'power')}
        {btn(W / 2 + 0.02, -1.25, 0.5, 'control')}
        {[
          [W / 2 + 0.001, 3.4],
          [-W / 2 - 0.001, -3.5],
        ].map(([x, y], i) => (
          <mesh key={i} position={[x, y, 0]} material={m.antenna}>
            <boxGeometry args={[0.01, 0.05, D * 0.7]} />
          </mesh>
        ))}
      </primitive>
    </>
  );
};
