import React from 'react';
import {dark, FONT, type} from '../theme';
import {assistant} from '../data';
import {Icon} from './Icon';
import {FAB} from './Dock';

// Port of AssistantScreen inside DuitlahAssistantExpansion: the panel keeps its
// final layout while a material aperture grows from the Ask Duitlah control.

const W = 390;
const H = 844;
const target = {x: 0, y: H * 0.06, w: W, h: H * 0.94};

const lerp = (a: number, b: number, t: number) => a + (b - a) * t;

export const assistantRect = (t: number) => ({
  x: lerp(FAB.x, target.x, t),
  y: lerp(FAB.y, target.y, t),
  w: lerp(FAB.w, target.w, t),
  h: lerp(FAB.h, target.h, t),
  r: 16 + 8 * t,
});

const words = (s: string, p: number) => {
  const parts = s.split(' ');
  const n = Math.floor(parts.length * p + 0.0001);
  return parts.slice(0, n).join(' ');
};

const PanelContent: React.FC<{typed: number; sent: number; thinking: number; answer: number; phase: number}> = ({typed, sent, thinking, answer, phase}) => {
  const q = assistant.question;
  const field = sent > 0.02 ? '' : q.slice(0, Math.round(q.length * typed));
  const ph = target.h;
  return (
    <div style={{position: 'absolute', left: 0, top: 0, width: W, height: ph, fontFamily: FONT, color: dark.textPrimary}}>
      <div style={{position: 'absolute', left: W / 2 - 18, top: 10, width: 36, height: 5, borderRadius: 3, background: 'rgba(171,180,192,0.45)'}} />
      <div style={{position: 'absolute', left: 20, top: 38, ...type.appBar, lineHeight: '32px'}}>Assistant</div>
      <div style={{position: 'absolute', right: 20, top: 42}}>
        <Icon name="document" size={24} color={dark.textPrimary} />
      </div>
      <div style={{position: 'absolute', left: 20, right: 20, top: 104}}>
        {sent > 0 && (
          <div style={{display: 'flex', justifyContent: 'flex-end', margin: '4px 0', opacity: sent, transform: `translateY(${10 * (1 - sent)}px)`}}>
            <div
              style={{
                maxWidth: W * 0.8,
                padding: '10px 14px',
                borderRadius: 20,
                background: dark.primary,
                color: dark.textOnPrimary,
                fontSize: 14,
                lineHeight: 1.45,
              }}
            >
              {q}
            </div>
          </div>
        )}
        {answer > 0 && (
          <div style={{display: 'flex', justifyContent: 'flex-start', margin: '8px 0', opacity: Math.min(1, answer * 6)}}>
            <div
              style={{
                width: W * 0.8,
                padding: '10px 14px',
                borderRadius: 20,
                background: dark.surface,
                border: '1px solid rgba(255,255,255,0.04)',
                fontSize: 14,
                lineHeight: 1.5,
                boxSizing: 'border-box',
              }}
            >
              {/* Full text reserves layout; revealed words sit on top so nothing reflows. */}
              <div style={{position: 'relative'}}>
                <div style={{visibility: 'hidden'}}>{assistant.answer}</div>
                <div style={{position: 'absolute', inset: 0}}>{words(assistant.answer, answer)}</div>
              </div>
            </div>
          </div>
        )}
      </div>
      {thinking > 0 && (
        <div style={{position: 'absolute', left: 0, right: 0, top: ph - 128, height: 4, background: dark.primarySoft, opacity: thinking, overflow: 'hidden'}}>
          <div style={{position: 'absolute', top: 0, bottom: 0, left: `${((phase * 1.6) % 1) * 130 - 38}%`, width: '38%', background: dark.primary}} />
        </div>
      )}
      <div style={{position: 'absolute', left: 12, top: ph - 111, ...type.titleSmall}}>Ask a question</div>
      <div
        style={{
          position: 'absolute',
          left: 12,
          width: 310,
          top: ph - 94,
          height: 56,
          borderRadius: 14,
          border: `1px solid ${dark.borderSubtle}`,
          background: dark.surface,
          display: 'flex',
          alignItems: 'center',
          padding: '0 14px',
          fontSize: 14,
          overflow: 'hidden',
          whiteSpace: 'nowrap',
        }}
      >
        <span>{field}</span>
        {typed > 0 && typed < 1 && <span style={{width: 1.5, height: 18, background: dark.primary, marginLeft: 1}} />}
      </div>
      <div
        style={{
          position: 'absolute',
          left: 330,
          top: ph - 90,
          width: 48,
          height: 48,
          borderRadius: 24,
          background: dark.primary,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
        }}
      >
        <Icon name="out" size={22} color={dark.textOnPrimary} />
      </div>
    </div>
  );
};

export const AssistantPanel: React.FC<{expand: number; typed: number; sent: number; thinking: number; answer: number; phase: number}> = ({
  expand,
  ...content
}) => {
  if (expand <= 0) return null;
  const r = assistantRect(expand);
  return (
    <div
      style={{
        position: 'absolute',
        left: r.x,
        top: r.y,
        width: r.w,
        height: r.h,
        borderRadius: r.r,
        overflow: 'hidden',
        zIndex: 45,
        border: '1px solid rgba(255,255,255,0.08)',
        background: 'linear-gradient(180deg, #18222F, #111823)',
        boxShadow: '0 -10px 40px rgba(0,0,0,0.35)',
      }}
    >
      <div style={{position: 'absolute', top: 0, left: 14, right: 14, height: 1, background: 'rgba(255,255,255,0.10)'}} />
      {/* OverflowBox aligned bottom-right: the content never reflows while the aperture grows. */}
      <div style={{position: 'absolute', right: 0, bottom: 0, width: W, height: target.h, opacity: Math.min(1, expand * 1.4)}}>
        <PanelContent {...content} />
      </div>
    </div>
  );
};
