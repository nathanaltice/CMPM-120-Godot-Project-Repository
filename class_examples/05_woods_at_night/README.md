# 05 Woods at Night

A demo which demonstrates a basic navMesh (ie. click-to-navigate), audio zones and 2D lighting.

## NavMesh

NavMesh a simple way to add basic click navigation to your character with (almost) no code. There are two components to a NavMesh system : `NavigationRegion2D` and `NavigationAgent2D`. To create a basic NavMesh setup, follow these steps :

1. Add a `NavigationRegion2D` to your scene.
2. Add any collision objects in your scene (ie. the things you would like your character to avoid) as children of the NavigationRegion2D.
3. In the inspector of the NavigationRegion2D, create a new "NavigationPolygon" and trace out the boundary of the area you would like your character to navigate.
4. Click the "BakeNavigationPolygon" at the top of the 2D editor. If Debug > Visible Navigation is switched on, you should see a series of triangles that represent the NavMesh Region.
5. Select your character node and add a `NavigationAgent2D` to it.
6. Use gdscript to have your character be controlled by the NavigationAgent [like so](./scripts/character.gd).

**NOTE:** The above setup doesn't create the world's smartest NavigationAgent. It will take some tweaking of settings to keep from getting stuck behind items.

## Audio Zones

The audio for the scene is just a few `AudioStreamPlayer2D` nodes that have had their Max Distance value tweaked. Max Distance fades the audio in when the camera is within the set pixel range.

## 2D Lighting

There are three types of elements lighting the scene: `DirectionalLight2D`, which (confusingly) is used to darken the scene, `PointLight2D` which is used for the flickering character and the "party" of three colored lights and `LightOccluder2D`, which is a polygon (like a collider) which blocks the light, creating shadows.

- `DirectionalLight2D` is a light which covers the entire scene equally.  In our case, we are using the light to _darken_ the scene, by going to the inspector and setting Light2D > Blend Mode to **Subtract**.
- `PointLight2D` projects light from a specific point in the shape of a texture that you designate.  In this example, the "Lantern" node is a PointLight2D with a [custom texture](./assets/png/pointlight_texture.png) to give the edge of light some roughness.  The PointLight2Ds that make up the "Party" node have all been assigned a radial gradient texture.  (To create this kind of round light, in the texture field click <empty>, then "New GradientTexture2D".  Click the box that appears to adjust the gradient's settings.  Then click Fill > Fill > Radial. Then use the dots of the gradient editor tool at the top to edit the center and edge of your gradient.)
- `LightOccluder2D` is used in each one of the rock scenes.  Just like a CollisionPolygon2D, the rocks require a polygon shape. You can use the polygon editor to create an occlusion shape, however, **you do not need to re-draw your polygon if you already have a CollisionPolygon2D**.  Simply select the CollisionPolygon2D node, and in the inspector right click the "Polygon" field label. You should see the option to "Copy Value".  Pasting this value in to your LightOccluder2D polygon will create an exact copy, so your shadow follows your collision shape.


## Credits
This demo was created by [Nate Laffan](https://github.com/laffan).
