import React from 'react';

// Port of DuitlahTrajectory's painter: a labelled ratio path, never a fake time series.
const cubic = (p0: number[], p1: number[], p2: number[], p3: number[], t: number) => {
  const u = 1 - t;
  return [0, 1].map(
    (i) => u * u * u * p0[i] + 3 * u * u * t * p1[i] + 3 * u * t * t * p2[i] + t * t * t * p3[i],
  );
};

export const Trajectory: React.FC<{width: number; height?: number; progress: number; ink: string; track: string}> = ({
  width,
  height = 72,
  progress,
  ink,
  track,
}) => {
  const p0 = [6, height * 0.8];
  const p1 = [width * 0.32, height * 0.85];
  const p2 = [width * 0.56, height * 0.12];
  const p3 = [width - 6, height * 0.2];
  // Arc-length table so progress is along the curve, as PathMetric does.
  const N = 120;
  const pts = Array.from({length: N + 1}, (_, i) => cubic(p0, p1, p2, p3, i / N));
  const lens = [0];
  for (let i = 1; i <= N; i++) lens.push(lens[i - 1] + Math.hypot(pts[i][0] - pts[i - 1][0], pts[i][1] - pts[i - 1][1]));
  const total = lens[N];
  const target = total * Math.min(1, Math.max(0, progress));
  let k = 0;
  while (k < N && lens[k + 1] < target) k++;
  const seg = lens[k + 1] - lens[k] || 1;
  const f = (target - lens[k]) / seg;
  const pos = [pts[k][0] + (pts[Math.min(N, k + 1)][0] - pts[k][0]) * f, pts[k][1] + (pts[Math.min(N, k + 1)][1] - pts[k][1]) * f];
  const d = `M${p0.join(' ')} C${p1.join(' ')} ${p2.join(' ')} ${p3.join(' ')}`;
  return (
    <svg width={width} height={height} style={{display: 'block', overflow: 'visible'}}>
      <path d={d} fill="none" stroke={track} strokeWidth={1.5} />
      <path d={d} fill="none" stroke={ink} strokeWidth={1.5} strokeDasharray={`${target} ${total + 10}`} />
      {progress > 0.001 && (
        <>
          <circle cx={pos[0]} cy={pos[1]} r={9} fill={ink} fillOpacity={0.12} />
          <circle cx={pos[0]} cy={pos[1]} r={3.5} fill={ink} />
        </>
      )}
    </svg>
  );
};
