package hx.potpack;

// Original Source Code: https://github.com/mapbox/potpack/blob/main/index.js
// Converted to Haxe by: barisyild
import hx.potpack.geom.PotpackRectangle;
import haxe.ds.Vector;

class Potpack
{
    // Ordering feature has been added to the original source code as an extra.
    // If you want to keep the order of the boxes, you can use this feature.
    // Also Vector has been used instead of Array for performance reasons. (Fixed Array)
    public static function pack(boxes:Vector<PotpackRectangle>, keepOrder:Bool = true):{width:Int, height:Int, size:Int, fill:Float}
    {
        // calculate total box area and maximum box width
        var area:Int = 0;
        var maxWidth:Int = 0;

        var tmpBoxes:Vector<PotpackRectangle> = keepOrder ? boxes.copy() : boxes;

        for (box in tmpBoxes) {
            area += cast box.width * box.height;
            maxWidth = cast Math.max(maxWidth, box.width);
        }

        // sort the boxes for insertion by height, descending
        tmpBoxes.sort((a, b) -> cast b.height - cast a.height);

        // aim for a squarish resulting container,
        // slightly adjusted for sub-100% space utilization
        final startWidth:Int = cast Math.max(Math.ceil(Math.sqrt(area / 0.95)), maxWidth);


        #if js
        final spaces:Vector<{x:Float, y:Float, width:Float, height:Float}> = new Vector(tmpBoxes.length);
        spaces.set(0, {x: 0, y: 0, width: startWidth, height: 2147483647});
        #else
        final spaces:Vector<PotpackRectangle> = new Vector<PotpackRectangle>(tmpBoxes.length);
        spaces.set(0, new PotpackRectangle(0, 0, startWidth, 2147483647));
        #end

        var width:Int = 0;
        var height:Int = 0;
        var spacesLength:Int = 1;

        for (box in tmpBoxes) {
            // look through spaces backwards so that we check smaller spaces first

            var i:Int = spacesLength - 1;
            while (i >= 0)
            {
                final space:#if js {x:Float, y:Float, width:Float, height:Float} #else PotpackRectangle #end = spaces[i];

                // look for empty spaces that can accommodate the current box
                if (box.width > space.width || box.height > space.height)
                {
                    i--;
                    continue;
                }

                // found the space; add the box to its top-left corner
                // |-------|-------|
                // |  box  |       |
                // |_______|       |
                // |         space |
                // |_______________|
                box.x = space.x;
                box.y = space.y;

                height = cast Math.max(height, box.y + box.height);
                width = cast Math.max(width, box.x + box.width);

                if (box.width == space.width && box.height == space.height) {
                    // space matches the box exactly; remove it
                    final lastSpace:#if js {x:Float, y:Float, width:Float, height:Float} #else PotpackRectangle #end = spaces.get(spacesLength - 1);
                    spacesLength--;

                    if (i < spacesLength)
                        spaces.set(i, lastSpace);

                } else if (box.height == space.height) {
                    // space matches the box height; update it accordingly
                    // |-------|---------------|
                    // |  box  | updated space |
                    // |_______|_______________|
                    space.x += box.width;
                    space.width -= box.width;

                } else if (box.width == space.width) {
                    // space matches the box width; update it accordingly
                    // |---------------|
                    // |      box      |
                    // |_______________|
                    // | updated space |
                    // |_______________|
                    space.y += box.height;
                    space.height -= box.height;

                } else {
                    // otherwise the box splits the space into two spaces
                    // |-------|-----------|
                    // |  box  | new space |
                    // |_______|___________|
                    // | updated space     |
                    // |___________________|

                    #if js
                        spaces.set(spacesLength, {
                            x: space.x + box.width,
                            y: space.y,
                            width: space.width - box.width,
                            height: box.height
                        });
                    #else
                        spaces.set(spacesLength, new PotpackRectangle(
                            space.x + box.width,
                            space.y,
                            space.width - box.width,
                            box.height
                        ));
                    #end
                    spacesLength++;

                    space.y += box.height;
                    space.height -= box.height;
                }
                break;
            }
        }

        return {
            width: width,
            height: height,
            size: cast Math.max(width, height),
            fill: area / (width * height)
        };
    }
}