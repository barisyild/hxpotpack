package hx.potpack.geom;

#if ((neko || cs || java || eval) && openfl)
typedef PotpackVector<T> = openfl.Vector<T>;
#else
typedef PotpackVector<T> = haxe.ds.Vector<T>;
#end
