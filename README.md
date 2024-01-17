# Yet Another Demake Shader (Unity)
![alt text](https://rikovmike.ru/upload/images/LimitPaletteRaw/title.png)

Simple fullscreen render shader for demake projects.
Contains only one shader file and two helper images.
No additional scripts or other garbage stuff.

## How To Use

Use this shader on the material of your final render texture. 
In the material, you need to set the `palette` parameter and 
the `dithering` texture. Use only single-pixel images as 
a palette (for example, from [lospec.com](https://lospec.com/) ). 

The `Color Count` parameter is set to 256 by default. 
You can set it to the number of colors in your palette 
to eliminate unnecessary calculations. A larger number 
of colors in the parameter does not affect the final 
image in any way.

Use the dithering texture included. 
Use the `Dither Treshold` slider to fine-tune the dithering
effect: from zero (solid effect) to one (no effect).

Refer to the demo scene as a reference for setting up the render.
Works on any type of project - both 2D and 3D. 
It can be configured on ready-made projects and templates.

![alt text](https://rikovmike.ru/upload/_temp/shader_CGA_test6.gif)

## Demo

Get the `*.unitypackage` from releases and import it into your project. Check `demo scene` from imported package for basic rendering setup. Have fun! 
