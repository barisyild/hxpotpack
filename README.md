# hxpotpack
hxpotpack is the haxe port of the original [potpack](https://github.com/mapbox/potpack) project.

A variation of algorithms used in [rectpack2D](https://github.com/TeamHypersomnia/rectpack2D) and [bin-pack](https://github.com/bryanburgers/bin-pack), which are in turn based on [this article by Blackpawn](http://blackpawn.com/texts/lightmaps/default.html).

## Ordered Example usage
```haxe
import haxe.ds.Vector;
import hx.potpack.Potpack;
import hx.potpack.geom.PotpackRectangle; //or you can import "openfl.display.Rectangle" for openfl

class Test {
    static function main() {
        final boxes:Vector<PotpackRectangle> = new Vector<PotpackRectangle>(2);
        boxes.set(0, new PotpackRectangle(0, 0, 300, 50));
        boxes.set(1, new PotpackRectangle(0, 0, 100, 200));

        final data = Potpack.pack(boxes);
        trace('width: ${data.width}, height: ${data.height}, rect size: ${data.size} fill: ${data.fill}');

        // potpack mutates the boxes array: it's sorted by height,
        // and box objects are augmented with x, y coordinates:
        trace(boxes[0]); // {x: 0, y: 200, width: 300, height: 50}
        trace(boxes[1]); // {x: 0, y: 0, width: 100, height: 200}
    }
}
```

## Unordered Example usage
```haxe
import haxe.ds.Vector;
import hx.potpack.Potpack;
import hx.potpack.geom.PotpackRectangle; //or you can import "openfl.display.Rectangle" for openfl

class Test {
    static function main() {
        final boxes:Vector<PotpackRectangle> = new Vector<PotpackRectangle>(2);
        boxes.set(0, new PotpackRectangle(0, 0, 300, 50));
        boxes.set(1, new PotpackRectangle(0, 0, 100, 200));

        final data = Potpack.pack(boxes, false);
        trace('width: ${data.width}, height: ${data.height}, rect size: ${data.size} fill: ${data.fill}');

        // potpack mutates the boxes array: it's sorted by height,
        // and box objects are augmented with x, y coordinates:
        trace(boxes[0]); // {x: 0, y: 0, width: 100, height: 200}
        trace(boxes[1]); // {x: 0, y: 200, width: 300, height: 50}
    }
}
```

## Compatibility
Compatible with all haxe projects.

There is an additional compatibility feature for OpenFL, you can use OpenFL Rectangles.

## Install
Install with haxelib: `haxelib git hxpotpack https://github.com/barisyild/hxpotpack.git`

### Original project created by [Mapbox](https://github.com/mapbox)