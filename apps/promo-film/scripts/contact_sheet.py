"""Builds Duitlah_Promo_Storyboard.png from out/stills/{portrait,landscape}."""
import sys
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
FONT = ROOT / 'public/fonts/PlusJakartaSans-Variable.ttf'
SCENES = [('01_wake', '0:00 Wake'), ('02_dashboard', '0:03 See everything'), ('03_transactions', '0:07 Transactions'),
          ('04_bagilah', '0:11 Bagilah'), ('05_analytics', '0:16 Analytics'), ('06_assistant', '0:20 Just ask'),
          ('07_universe', '0:23 More than tracking'), ('08_hero', '0:26 Duitlah'), ('09_end', '0:28 End card')]

def font(size, weight=600):
    f = ImageFont.truetype(str(FONT), size)
    try:
        f.set_variation_by_axes([weight])
    except Exception:
        pass
    return f

def sheet(which, out):
    bg = (5, 8, 13)
    if which == 'both':
        pw, ph = 300, 533
        lw, lh = 620, 349
        cols = 3
        cell_w = pw + 24 + lw
        cell_h = ph
        pad, gap, head = 48, 36, 140
        rows = (len(SCENES) + cols - 1) // cols
        W = pad * 2 + cols * cell_w + (cols - 1) * gap
        H = head + pad + rows * (cell_h + 60) + (rows - 1) * gap
        img = Image.new('RGB', (W, H), bg)
        d = ImageDraw.Draw(img)
        d.text((pad, 44), 'duitlah.  Product film storyboard', font=font(44, 700), fill=(247, 249, 252))
        d.text((pad, 100), '30 s · 30 fps · 9:16 (left) and recomposed 16:9 (right) · one still per scene', font=font(22, 500), fill=(144, 161, 182))
        for i, (key, label) in enumerate(SCENES):
            r, c = divmod(i, cols)
            x = pad + c * (cell_w + gap)
            y = head + pad + r * (cell_h + 60 + gap)
            d.text((x, y), label, font=font(22, 600), fill=(175, 207, 244))
            p = Image.open(ROOT / f'out/stills/portrait/{key}.png').convert('RGB').resize((pw, ph), Image.LANCZOS)
            l = Image.open(ROOT / f'out/stills/landscape/{key}.png').convert('RGB').resize((lw, lh), Image.LANCZOS)
            img.paste(p, (x, y + 40))
            img.paste(l, (x + pw + 24, y + 40 + (ph - lh) // 2))
        img.save(out)
        return
    layout = which
    tw, th = (360, 640) if layout == 'portrait' else (640, 360)
    cols = 5 if layout == 'portrait' else 3
    pad, gap = 30, 20
    rows = (len(SCENES) + cols - 1) // cols
    W = pad * 2 + cols * tw + (cols - 1) * gap
    H = pad * 2 + rows * (th + 40) + (rows - 1) * gap
    img = Image.new('RGB', (W, H), bg)
    d = ImageDraw.Draw(img)
    for i, (key, label) in enumerate(SCENES):
        r, c = divmod(i, cols)
        x = pad + c * (tw + gap)
        y = pad + r * (th + 40 + gap)
        d.text((x, y), label, font=font(20, 600), fill=(175, 207, 244))
        im = Image.open(ROOT / f'out/stills/{layout}/{key}.png').convert('RGB').resize((tw, th), Image.LANCZOS)
        img.paste(im, (x, y + 34))
    img.save(out)

if __name__ == '__main__':
    which = sys.argv[1] if len(sys.argv) > 1 else 'both'
    out = sys.argv[2] if len(sys.argv) > 2 else str(ROOT / 'out/Duitlah_Promo_Storyboard.png')
    sheet(which, out)
    print(out)
