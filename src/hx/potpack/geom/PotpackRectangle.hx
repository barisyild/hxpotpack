package hx.potpack.geom;

#if openfl
typedef PotpackRectangle = openfl.geom.Rectangle;
#else
class PotpackRectangle {
    public var x:Float;
    public var y:Float;
    public var width:Float;
    public var height:Float;

    public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0):Void {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
}
#end