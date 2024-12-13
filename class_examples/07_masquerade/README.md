# 07 Window Dressing

Demonstrates different methods of masking (clip, subViewport) along with basic tweening and rotation.

## Basic Clipping

The simplest version of masking is demonstrated in the `GradientMask` layer. The mask is created by switching on `Canvas Item > Clip Children > Clip Only` in the inspector.  The animation of the gradient is controlled by a tween in  [gradient_mask.md](scripts/gradient_mask.gd).

## SubViewport Clipping

The other three masks (the outlines, the color and the X-rays that show up when you hold the mouse down) are created with animated SubViewports. Because SubViewports can be used as a texture for a sprite, this same setting (Clip Children) can be used to create animated masks. To replicate this effect place the nodes you would like to use as the mask inside a SubViewport (they will disappear), create a new Sprite2D (outside the SubViewport) and click the `<empty>` text inside the "Texture" field. From the menu that pops up, select "New ViewportTexture."  A list of the SubViewports in your scene will pop up. Select one, and then scroll down to the same "Clip Children > Clip Only" setting from above.

### 🚨 POTENTIAL ISSUES

- SubViewport doesn't always obey HiDPI settings, and therefore you might need to scale it to 2x the game screen.
- Godot has a bug where duplicated subViewports hang on to their linked status as textures, which means that if you don't create a new one (instead of duplicating), then any sprite assigned to the original will switch over and vice versa. **tldr; Do not duplicate SubViewport nodes. Always create a new one.**


## Credits
This demo was created by [Nate Laffan](https://github.com/laffan).
